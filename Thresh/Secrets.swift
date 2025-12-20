import Foundation

/// API keys and secrets
/// Uses Xcode Cloud environment variables when available, falls back to hardcoded values for local development
enum Secrets {
    /// Anthropic API key - checks environment variable first (for Xcode Cloud), then falls back to local key
    static var anthropicAPIKey: String {
        // Xcode Cloud environment variable: Claude_API_KEY_Thresh_001
        if let envKey = ProcessInfo.processInfo.environment["Claude_API_KEY_Thresh_001"], !envKey.isEmpty {
            return envKey
        }
        // Fallback for local development
        return "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"
    }
}
