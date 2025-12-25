import Foundation

/// API keys and secrets
/// Uses Xcode Cloud environment variables when available, falls back to hardcoded values for local development
enum Secrets {
    /// Anthropic API key - checks environment variable first (for Xcode Cloud), then falls back to local key
    static var anthropicAPIKey: String {
        // Xcode Cloud environment variable: THRESH_001_ANTHROPIC_251225
        if let envKey = ProcessInfo.processInfo.environment["THRESH_001_ANTHROPIC_251225"], !envKey.isEmpty {
            return envKey
        }
        // Fallback for local development (empty - key must come from Xcode Cloud)
        return ""
    }
}
