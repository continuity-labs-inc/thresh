import Foundation
import CryptoKit

/// Service to route Claude API requests through our secure proxy server.
/// The proxy holds the actual API keys - apps never see them.
actor ClaudeProxyService {
    static let shared = ClaudeProxyService()

    private let proxyURL = URL(string: "https://claude-proxy-346833315644.us-central1.run.app")!
    private let appName = "thresh"

    private init() {}

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

    // MARK: - Private Implementation

    private func makeProxyRequest(body: [String: Any]) async throws -> ProxyResponse {
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        let timestamp = String(Int(Date().timeIntervalSince1970))

        // Create HMAC signature
        let message = "\(timestamp):\(String(data: jsonData, encoding: .utf8)!)"
        let signature = createSignature(message: message)

        var request = URLRequest(url: proxyURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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

    private func createSignature(message: String) -> String {
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

enum ProxyError: Error, LocalizedError {
    case noResponse
    case invalidSignature
    case requestFailed(statusCode: Int)
    case noContent

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
        }
    }
}
