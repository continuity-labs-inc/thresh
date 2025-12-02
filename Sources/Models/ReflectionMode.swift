import Foundation

/// The two fundamental modes of reflection.
/// Capture is HARDER than synthesis—that's the key insight.
enum ReflectionMode: String, Codable, CaseIterable {
    case capture    // Observation: what happened
    case synthesis  // Interpretation: what it means

    var displayName: String {
        switch self {
        case .capture: return "Capture"
        case .synthesis: return "Synthesis"
        }
    }

    var description: String {
        switch self {
        case .capture:
            return "Observe without interpreting. Record what happened."
        case .synthesis:
            return "Find meaning in what you've captured."
        }
    }

    var icon: String {
        switch self {
        case .capture: return "camera.fill"
        case .synthesis: return "sparkles"
        }
    }

    /// The core difficulty of each mode
    var challenge: String {
        switch self {
        case .capture:
            return "Seeing clearly without adding meaning is the hardest skill."
        case .synthesis:
            return "Finding real patterns, not just telling yourself stories."
        }
    }
}
