import Foundation

enum PromptCategory: String, Codable, CaseIterable {
    case person
    case place
    case conversation
    case object
    case moment
    case routine

    var displayName: String {
        rawValue.capitalized
    }

    var phase1Prompts: [String] {
        switch self {
        case .person:
            return [
                "Describe someone you interacted with today. How do they move? What's their voice like?",
                "Pick a person from today. Describe them as a character entering a scene.",
                "Who did you notice today? Describe their gestures, their presence."
            ]
        case .place:
            return [
                "Describe a room you spent time in today. What could you see, hear, smell?",
                "Pick a place from today. What was the light like? The sounds?",
                "Where were you today that felt distinct? Describe the space."
            ]
        case .conversation:
            return [
                "What did someone say to you today? Write their exact words, not a summary.",
                "Describe a conversation. What was actually said?",
                "What dialogue do you remember from today? Quote it directly."
            ]
        case .object:
            return [
                "Describe an object you touched today. Its weight, texture, temperature.",
                "What thing caught your attention today? Describe it physically.",
                "Pick something you held or used. What did it feel like?"
            ]
        case .moment:
            return [
                "Describe a moment that had tension today—even small tension.",
                "What moment stuck with you? Describe the before and after.",
                "When did something shift today? Capture that instant."
            ]
        case .routine:
            return [
                "Describe something you do every day as if seeing it for the first time.",
                "Pick a routine from today. What details have you stopped noticing?",
                "What did you do on autopilot? Describe it with fresh eyes."
            ]
        }
    }

    var phase2Prompt: String {
        switch self {
        case .person:
            return "What did you leave out about them? What would they say you got wrong?"
        case .place:
            return "What's the relationship between this place and how you moved through it?"
        case .conversation:
            return "What wasn't said? What was the subtext?"
        case .object:
            return "Why does this object have weight for you? What does it stand for?"
        case .moment:
            return "Where was the tension? What was at stake?"
        case .routine:
            return "What does this routine protect you from—or give you?"
        }
    }
}

enum PromptDomain: String, Codable, CaseIterable {
    case interpersonal   // relationships, family, friends
    case professional    // work, career, colleagues
    case `internal`      // self-reflection, emotions, body (backticks because reserved word)
    case environmental   // places, objects, surroundings
}
