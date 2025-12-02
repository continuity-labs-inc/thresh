import Foundation

/// Represents the user's development level in reflective practice.
/// Scaffolding decreases as users progress; prompts become more open.
enum DevelopmentStage: Int, Codable, CaseIterable, Comparable {
    case emerging = 1       // New to reflection, needs high scaffolding
    case developing = 2     // Building habits, moderate scaffolding
    case practiced = 3      // Consistent practice, light scaffolding
    case fluent = 4         // Skilled reflector, minimal prompts

    var displayName: String {
        switch self {
        case .emerging: return "Emerging"
        case .developing: return "Developing"
        case .practiced: return "Practiced"
        case .fluent: return "Fluent"
        }
    }

    var description: String {
        switch self {
        case .emerging:
            return "Building the foundation of reflective practice"
        case .developing:
            return "Strengthening observation and synthesis skills"
        case .practiced:
            return "Reflection is becoming natural"
        case .fluent:
            return "Deep, intuitive reflective practice"
        }
    }

    /// How much scaffolding to provide (1.0 = maximum, 0.0 = none)
    var scaffoldingLevel: Double {
        switch self {
        case .emerging: return 1.0
        case .developing: return 0.7
        case .practiced: return 0.4
        case .fluent: return 0.15
        }
    }

    /// Whether to show examples in prompts
    var showExamples: Bool {
        switch self {
        case .emerging, .developing: return true
        case .practiced, .fluent: return false
        }
    }

    /// Whether to offer blank space as a prompt option
    var offerBlankSpace: Bool {
        switch self {
        case .emerging, .developing: return false
        case .practiced, .fluent: return true
        }
    }

    static func < (lhs: DevelopmentStage, rhs: DevelopmentStage) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
