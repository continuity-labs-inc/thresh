import Foundation

/// Represents what the reflection focuses on—the lens through which we observe.
enum FocusType: String, Codable, CaseIterable {
    case event          // A specific happening or incident
    case person         // An interaction or relationship
    case place          // A location and its significance
    case idea           // A thought, concept, or realization
    case emotion        // A feeling and its context
    case decision       // A choice made or pending
    case pattern        // A recurring behavior or theme
    case question       // An unresolved inquiry
    case gratitude      // Something appreciated
    case challenge      // A difficulty or obstacle

    var displayName: String {
        switch self {
        case .event: return "Event"
        case .person: return "Person"
        case .place: return "Place"
        case .idea: return "Idea"
        case .emotion: return "Emotion"
        case .decision: return "Decision"
        case .pattern: return "Pattern"
        case .question: return "Question"
        case .gratitude: return "Gratitude"
        case .challenge: return "Challenge"
        }
    }

    var icon: String {
        switch self {
        case .event: return "calendar"
        case .person: return "person.fill"
        case .place: return "mappin.circle.fill"
        case .idea: return "lightbulb.fill"
        case .emotion: return "heart.fill"
        case .decision: return "arrow.triangle.branch"
        case .pattern: return "repeat"
        case .question: return "questionmark.circle.fill"
        case .gratitude: return "sparkles"
        case .challenge: return "mountain.2.fill"
        }
    }

    var capturePromptHint: String {
        switch self {
        case .event:
            return "What happened? Walk through it moment by moment."
        case .person:
            return "What did they say or do? Be specific."
        case .place:
            return "What did you notice there? Details matter."
        case .idea:
            return "Where did this thought come from? What triggered it?"
        case .emotion:
            return "When did you first notice this feeling? What was happening?"
        case .decision:
            return "What are the actual options? What's pulling you each way?"
        case .pattern:
            return "When did you notice this happening before?"
        case .question:
            return "What makes this question matter right now?"
        case .gratitude:
            return "What specifically happened that you're grateful for?"
        case .challenge:
            return "What makes this hard? Be concrete."
        }
    }
}
