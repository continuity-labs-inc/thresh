import Foundation

/// Represents the quality of observational capture in a reflection.
/// Good capture is HARD—it requires discipline to observe without interpreting.
enum CaptureQuality: String, Codable, CaseIterable {
    case needsWork      // Missing concrete details, too abstract
    case developing     // Some specifics, but gaps remain
    case solid          // Clear observation with sensory details
    case excellent      // Rich, camera-like capture

    var displayName: String {
        switch self {
        case .needsWork: return "Needs Detail"
        case .developing: return "Developing"
        case .solid: return "Solid"
        case .excellent: return "Excellent"
        }
    }

    /// What's typically missing at this quality level
    var typicalGaps: [CaptureGap] {
        switch self {
        case .needsWork:
            return [.missingScene, .missingDialogue, .missingSequence, .tooAbstract]
        case .developing:
            return [.missingDialogue, .missingSequence]
        case .solid:
            return [] // Minor improvements possible but not necessary
        case .excellent:
            return []
        }
    }

    /// Whether synthesis should be offered
    var readyForSynthesis: Bool {
        switch self {
        case .needsWork: return false
        case .developing, .solid, .excellent: return true
        }
    }
}

/// Specific gaps in capture quality that prompts can address
enum CaptureGap: String, Codable, CaseIterable {
    case missingScene       // No sense of where/when
    case missingDialogue    // No actual words quoted
    case missingSequence    // No temporal ordering
    case missingAction      // No concrete behaviors
    case missingSensory     // No physical details
    case tooAbstract        // Interpretation instead of observation

    var improvementPrompt: String {
        switch self {
        case .missingScene:
            return "Where exactly were you? What did the space look like?"
        case .missingDialogue:
            return "Can you recall any exact words? Even a fragment helps."
        case .missingSequence:
            return "Walk through it step by step. What happened first?"
        case .missingAction:
            return "What did people actually do? Describe the actions."
        case .missingSensory:
            return "What did you see, hear, or feel physically?"
        case .tooAbstract:
            return "That's an interpretation. What did you actually observe?"
        }
    }
}
