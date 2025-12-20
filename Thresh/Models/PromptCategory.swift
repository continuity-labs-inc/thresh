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
                "Walk through your morning routine as you intend it vs. how it actually went today. Where did it diverge?",
                "What's one routine you're trying to build? Describe the last time you actually did it, step by step.",
                "Think of a routine that used to work but doesn't anymore. What changed?"
            ]
        }
    }

    var phase2Prompt: String {
        phase2Prompts[0]
    }

    var phase2Prompts: [String] {
        switch self {
        case .person:
            return [
                "What did you leave out about them? What would they say you got wrong?",
                "Why did this person catch your attention today?",
                "What do you think they were feeling that you couldn't see?"
            ]
        case .place:
            return [
                "What's the relationship between this place and how you moved through it?",
                "Why did you choose those details? What did you leave out?",
                "What would this place say about you if it could speak?"
            ]
        case .conversation:
            return [
                "What wasn't said? What was the subtext?",
                "Why did these words stick with you?",
                "What were you hoping they would say instead?"
            ]
        case .object:
            return [
                "Why does this object have weight for you? What does it stand for?",
                "What memory or feeling does this object carry?",
                "Why did you choose those details? What did you leave out?"
            ]
        case .moment:
            return [
                "Where was the tension? What was at stake?",
                "What did this moment reveal that you didn't expect?",
                "Why did you choose those details? What did you leave out?"
            ]
        case .routine:
            return [
                "What does this routine protect you from—or give you?",
                "What would happen if you stopped doing this?",
                "Why did you choose those details? What did you leave out?"
            ]
        }
    }
}

enum PromptDomain: String, Codable, CaseIterable {
    case interpersonal   // relationships, family, friends
    case professional    // work, career, colleagues
    case `internal`      // self-reflection, emotions, body (backticks because reserved word)
    case environmental   // places, objects, surroundings
}
