import Foundation
import Security

/// Service for securely storing and retrieving sensitive data from the Keychain
final class KeychainService {

    // MARK: - Singleton

    static let shared = KeychainService()

    private init() {}

    // MARK: - Public Interface

    /// Stores a value in the Keychain for the given key
    /// - Parameters:
    ///   - value: The string value to store
    ///   - key: The key to associate with the value
    /// - Returns: Whether the operation succeeded
    @discardableResult
    func set(_ value: String, for key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        // Delete any existing item first
        delete(key)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: bundleIdentifier,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Retrieves a value from the Keychain for the given key
    /// - Parameter key: The key to look up
    /// - Returns: The stored string value, or nil if not found
    func get(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: bundleIdentifier,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    /// Deletes a value from the Keychain for the given key
    /// - Parameter key: The key to delete
    /// - Returns: Whether the operation succeeded
    @discardableResult
    func delete(_ key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: bundleIdentifier
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    /// Checks if a value exists in the Keychain for the given key
    /// - Parameter key: The key to check
    /// - Returns: Whether a value exists for the key
    func exists(_ key: String) -> Bool {
        return get(key) != nil
    }

    // MARK: - Private

    private var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "com.vicarious.me"
    }
}

// MARK: - Keychain Keys

extension KeychainService {
    /// Standard keys used throughout the app
    enum Keys {
        static let openAIAPIKey = "openai_api_key"
    }
}
