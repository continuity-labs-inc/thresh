import Foundation

/// Represents the temporal tier of reflection, determining scope and synthesis depth.
/// Higher tiers aggregate and synthesize from lower tiers.
enum ReflectionTier: String, Codable, CaseIterable, Comparable {
    case daily      // Individual captures, raw observations
    case weekly     // First synthesis layer, pattern recognition
    case monthly    // Deeper synthesis, emerging themes
    case quarterly  // Strategic patterns, life direction
    case yearly     // Narrative arc, identity evolution

    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .quarterly: return "Quarterly"
        case .yearly: return "Yearly"
        }
    }

    var synthesisDescription: String {
        switch self {
        case .daily:
            return "Raw capture—what happened"
        case .weekly:
            return "First synthesis—what patterns emerge"
        case .monthly:
            return "Deeper synthesis—what themes are forming"
        case .quarterly:
            return "Strategic view—where am I heading"
        case .yearly:
            return "Narrative arc—who am I becoming"
        }
    }

    /// How many days this tier spans
    var daySpan: Int {
        switch self {
        case .daily: return 1
        case .weekly: return 7
        case .monthly: return 30
        case .quarterly: return 90
        case .yearly: return 365
        }
    }

    private var sortOrder: Int {
        switch self {
        case .daily: return 0
        case .weekly: return 1
        case .monthly: return 2
        case .quarterly: return 3
        case .yearly: return 4
        }
    }

    static func < (lhs: ReflectionTier, rhs: ReflectionTier) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
