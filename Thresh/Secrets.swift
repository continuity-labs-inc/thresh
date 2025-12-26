// Build trigger: Dec 25 2025
import Foundation

/// API keys and secrets
/// Uses Xcode Cloud environment variables when available, falls back to hardcoded values for local development
enum Secrets {
    /// Anthropic API key - DEPRECATED: Use ClaudeProxyService instead
    /// Kept for backwards compatibility during migration
    static var anthropicAPIKey: String {
        if let envKey = ProcessInfo.processInfo.environment["Thresh_001_anthropic_251225"], !envKey.isEmpty {
            return envKey
        }
        return ""
    }

    /// App secret for signing requests to the proxy server
    /// This is safe to include in the binary - it only proves the request comes from our app
    static var appSecret: String {
        if let envKey = ProcessInfo.processInfo.environment["APP_SECRET"], !envKey.isEmpty {
            return envKey
        }
        return "b724a0e55444927f3c280a3baee32c9ecded44794c508149142a9c56eab66455"
    }

    /// Whether to use the proxy server (true) or direct API calls (false)
    /// Set to true for production, false only for local debugging with direct API key
    static var useProxy: Bool {
        return true
    }
}
