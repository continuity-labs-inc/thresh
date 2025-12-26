import Foundation
import CryptoKit
import Security

/// Service to route Claude API requests through our secure proxy server.
/// The proxy holds the actual API keys - apps never see them.
/// Authenticates to Google Cloud Run using a service account.
actor ClaudeProxyService {
    static let shared = ClaudeProxyService()

    private let proxyURL = URL(string: "https://claude-proxy-346833315644.us-central1.run.app")!
    private let appName = "Thresh_001_anthropic_251225"

    // Google Cloud Run authentication
    private var cachedIdentityToken: String?
    private var tokenExpirationTime: Date?
    private var serviceAccountCredentials: ServiceAccountCredentials?

    private init() {
        loadServiceAccountCredentials()
    }

    // MARK: - Service Account Loading

    private func loadServiceAccountCredentials() {
        guard let url = Bundle.main.url(forResource: "thresh-ios-client-key", withExtension: "json") else {
            print("❌ ClaudeProxy: Service account key file not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let credentials = try JSONDecoder().decode(ServiceAccountCredentials.self, from: data)
            serviceAccountCredentials = credentials
            print("✅ ClaudeProxy: Loaded service account: \(credentials.client_email)")
        } catch {
            print("❌ ClaudeProxy: Failed to load service account: \(error)")
        }
    }

    // MARK: - Public API

    /// Send a message to Claude via the proxy server
    func sendMessage(
        messages: [[String: String]],
        system: String = "",
        model: String = "claude-sonnet-4-20250514",
        maxTokens: Int = 1024
    ) async throws -> String {
        let body: [String: Any] = [
            "app_name": appName,
            "model": model,
            "max_tokens": maxTokens,
            "messages": messages,
            "system": system
        ]

        let response = try await makeProxyRequest(body: body)
        return response.content
    }

    /// Send a raw prompt (convenience wrapper)
    func sendPrompt(_ prompt: String, maxTokens: Int = 1024) async throws -> String {
        let messages: [[String: String]] = [
            ["role": "user", "content": prompt]
        ]
        return try await sendMessage(messages: messages, maxTokens: maxTokens)
    }

    // MARK: - Google Cloud Run Authentication

    private func getIdentityToken() async throws -> String {
        // Check if we have a valid cached token
        if let token = cachedIdentityToken,
           let expiration = tokenExpirationTime,
           Date() < expiration.addingTimeInterval(-60) { // Refresh 1 minute early
            return token
        }

        guard let credentials = serviceAccountCredentials else {
            throw ProxyError.noServiceAccount
        }

        // Create and sign JWT
        let jwt = try createSignedJWT(credentials: credentials)

        // Exchange JWT for identity token
        let identityToken = try await exchangeJWTForIdentityToken(jwt: jwt)

        // Cache the token (valid for ~1 hour, we'll refresh at 59 minutes)
        cachedIdentityToken = identityToken
        tokenExpirationTime = Date().addingTimeInterval(3540) // 59 minutes

        return identityToken
    }

    private func createSignedJWT(credentials: ServiceAccountCredentials) throws -> String {
        let now = Int(Date().timeIntervalSince1970)

        // JWT Header
        let header: [String: Any] = [
            "alg": "RS256",
            "typ": "JWT"
        ]

        // JWT Payload
        let payload: [String: Any] = [
            "iss": credentials.client_email,
            "sub": credentials.client_email,
            "aud": "https://oauth2.googleapis.com/token",
            "iat": now,
            "exp": now + 3600,
            "target_audience": proxyURL.absoluteString
        ]

        // Encode header and payload
        let headerData = try JSONSerialization.data(withJSONObject: header)
        let payloadData = try JSONSerialization.data(withJSONObject: payload)

        let headerBase64 = headerData.base64URLEncodedString()
        let payloadBase64 = payloadData.base64URLEncodedString()

        let signatureInput = "\(headerBase64).\(payloadBase64)"

        // Sign with RS256
        let signature = try signWithRS256(message: signatureInput, privateKeyPEM: credentials.private_key)
        let signatureBase64 = signature.base64URLEncodedString()

        return "\(signatureInput).\(signatureBase64)"
    }

    private func signWithRS256(message: String, privateKeyPEM: String) throws -> Data {
        // Parse PEM format - strip headers and newlines
        let pemContent = privateKeyPEM
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\\n", with: "")  // Handle escaped newlines from JSON
            .replacingOccurrences(of: "\n", with: "")

        guard let pkcs8Data = Data(base64Encoded: pemContent) else {
            print("❌ ClaudeProxy: Failed to base64 decode private key")
            throw ProxyError.invalidPrivateKey
        }

        // PKCS#8 wraps the RSA key with an ASN.1 header. For RSA keys from Google,
        // the header is 26 bytes. We need to strip it to get the raw PKCS#1 key.
        // PKCS#8 structure: SEQUENCE { AlgorithmIdentifier, OCTET STRING { PKCS#1 key } }
        // The RSA PKCS#1 key starts after the PKCS#8 header (26 bytes for 2048-bit RSA)
        let pkcs8HeaderLength = 26
        guard pkcs8Data.count > pkcs8HeaderLength else {
            print("❌ ClaudeProxy: Private key data too short")
            throw ProxyError.invalidPrivateKey
        }

        let rsaKeyData = pkcs8Data.dropFirst(pkcs8HeaderLength)

        // Create SecKey from raw RSA key data
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateWithData(Data(rsaKeyData) as CFData, attributes as CFDictionary, &error) else {
            if let err = error?.takeRetainedValue() {
                print("❌ ClaudeProxy: SecKey creation failed: \(err)")
            }
            throw ProxyError.invalidPrivateKey
        }

        // Sign the message
        guard let messageData = message.data(using: .utf8) else {
            throw ProxyError.invalidPrivateKey
        }

        guard let signatureData = SecKeyCreateSignature(
            privateKey,
            .rsaSignatureMessagePKCS1v15SHA256,
            messageData as CFData,
            &error
        ) as Data? else {
            if let err = error?.takeRetainedValue() {
                print("❌ ClaudeProxy: Signing failed: \(err)")
            }
            throw ProxyError.signatureFailed
        }

        return signatureData
    }

    private func exchangeJWTForIdentityToken(jwt: String) async throws -> String {
        let tokenURL = URL(string: "https://oauth2.googleapis.com/token")!

        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(jwt)"
        request.httpBody = body.data(using: .utf8)

        print("📡 ClaudeProxy: Exchanging JWT for identity token...")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ProxyError.noResponse
        }

        guard httpResponse.statusCode == 200 else {
            if let errorText = String(data: data, encoding: .utf8) {
                print("❌ ClaudeProxy: Token exchange failed: \(errorText)")
            }
            throw ProxyError.tokenExchangeFailed(statusCode: httpResponse.statusCode)
        }

        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        print("✅ ClaudeProxy: Got identity token")
        return tokenResponse.id_token
    }

    // MARK: - Private Implementation

    private func makeProxyRequest(body: [String: Any]) async throws -> ProxyResponse {
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        let timestamp = String(Int(Date().timeIntervalSince1970))

        // Get Google Cloud Run identity token
        let identityToken = try await getIdentityToken()

        // Create HMAC signature
        let message = "\(timestamp):\(String(data: jsonData, encoding: .utf8)!)"
        let signature = createHMACSignature(message: message)

        var request = URLRequest(url: proxyURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(identityToken)", forHTTPHeaderField: "Authorization")
        request.setValue(signature, forHTTPHeaderField: "X-App-Signature")
        request.setValue(timestamp, forHTTPHeaderField: "X-Timestamp")
        request.httpBody = jsonData

        print("📡 ClaudeProxy: Sending request to \(proxyURL)...")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ ClaudeProxy: No HTTP response received")
            throw ProxyError.noResponse
        }

        print("📡 ClaudeProxy: Response status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            if let errorText = String(data: data, encoding: .utf8) {
                print("❌ ClaudeProxy: Error body: \(errorText)")
            }

            if httpResponse.statusCode == 401 {
                throw ProxyError.invalidSignature
            }
            throw ProxyError.requestFailed(statusCode: httpResponse.statusCode)
        }

        let result = try JSONDecoder().decode(ProxyResponse.self, from: data)
        print("✅ ClaudeProxy: Response received, \(result.usage?.output_tokens ?? 0) tokens used")
        return result
    }

    private func createHMACSignature(message: String) -> String {
        let key = SymmetricKey(data: Data(Secrets.appSecret.utf8))
        let signature = HMAC<SHA256>.authenticationCode(
            for: Data(message.utf8),
            using: key
        )
        return signature.map { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Response Types

struct ProxyResponse: Codable {
    let content: String
    let usage: Usage?
    let error: String?

    struct Usage: Codable {
        let input_tokens: Int
        let output_tokens: Int
    }
}

struct ServiceAccountCredentials: Codable {
    let type: String
    let project_id: String
    let private_key_id: String
    let private_key: String
    let client_email: String
    let client_id: String
    let auth_uri: String
    let token_uri: String
    let auth_provider_x509_cert_url: String
    let client_x509_cert_url: String
}

struct TokenResponse: Codable {
    let id_token: String
}

enum ProxyError: Error, LocalizedError {
    case noResponse
    case invalidSignature
    case requestFailed(statusCode: Int)
    case noContent
    case noServiceAccount
    case invalidPrivateKey
    case signatureFailed
    case tokenExchangeFailed(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .noResponse:
            return "No response from proxy server"
        case .invalidSignature:
            return "Invalid request signature - check APP_SECRET"
        case .requestFailed(let code):
            return "Proxy request failed with status \(code)"
        case .noContent:
            return "No content in proxy response"
        case .noServiceAccount:
            return "Service account credentials not loaded"
        case .invalidPrivateKey:
            return "Invalid service account private key"
        case .signatureFailed:
            return "Failed to sign JWT"
        case .tokenExchangeFailed(let code):
            return "Token exchange failed with status \(code)"
        }
    }
}

// MARK: - Data Extension for Base64URL Encoding

extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
