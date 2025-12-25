import Foundation

// MARK: - PromptLevel

enum PromptLevel: String, Codable, CaseIterable {
    case accessible      // 0-4 captures
    case observational   // 5-14 captures
    case ethnographic    // 15+ captures

    static func forCaptureCount(_ count: Int) -> PromptLevel {
        switch count {
        case 0..<5: return .accessible
        case 5..<15: return .observational
        default: return .ethnographic
        }
    }
}

// MARK: - LeveledPrompt

struct LeveledPrompt: Codable {
    let text: String
    let level: PromptLevel

    init(_ text: String, _ level: PromptLevel) {
        self.text = text
        self.level = level
    }
}

// MARK: - PromptCategory

enum PromptCategory: String, CaseIterable, Codable {
    case open
    case person
    case place
    case conversation
    case object
    case moment
    case routine

    var displayName: String {
        rawValue.capitalized
    }

    // MARK: - Phase 1 Prompts (Describe)

    var phase1Prompts: [LeveledPrompt] {
        switch self {

        case .open:
            return [
                // Accessible
                LeveledPrompt("Describe an interaction you had today. What did the other person say or do?", .accessible),
                LeveledPrompt("Who did you talk to today? Pick one conversation and describe what happened.", .accessible),
                LeveledPrompt("What's something that happened today involving another person? Try to include what was said.", .accessible),
                LeveledPrompt("Describe something that happened today. Try to include details you might normally skip over.", .accessible),
                LeveledPrompt("What do you remember from today? Pick one moment and describe it.", .accessible),
                LeveledPrompt("What happened today that you'd tell a friend about? Describe it.", .accessible),
                LeveledPrompt("Pick something from your day and describe it. Who was involved? What happened?", .accessible),
                // Observational
                LeveledPrompt("What moment from today would you want to remember a year from now? Describe what happened.", .observational),
                LeveledPrompt("Describe something that happened today without saying how you felt about it.", .observational),
                LeveledPrompt("What would a camera have recorded from your day? Pick a scene and describe it.", .observational),
                LeveledPrompt("What's something you noticed today that you normally wouldn't mention?", .observational),
                LeveledPrompt("Describe a moment from today as if you're telling someone who wasn't there.", .observational),
                // Ethnographic
                LeveledPrompt("What caught your attention today that seemed out of place? Describe what you saw, heard, or noticed.", .ethnographic),
                LeveledPrompt("Describe a moment from today using only what your senses perceived — no interpretation.", .ethnographic),
                LeveledPrompt("Pick a moment from today and describe it as if you're an anthropologist observing an unfamiliar culture.", .ethnographic),
            ]

        case .person:
            return [
                // Accessible
                LeveledPrompt("Pick someone you saw today. Describe what they were doing when you noticed them.", .accessible),
                LeveledPrompt("Who did you interact with today? What do you remember about how they looked or acted?", .accessible),
                LeveledPrompt("Describe someone you talked to today. What did they say? How did they say it?", .accessible),
                LeveledPrompt("Think of a person from your day. What were they wearing? What was their mood like?", .accessible),
                LeveledPrompt("Who made an impression on you today? Describe what they did.", .accessible),
                LeveledPrompt("Describe someone you spent time with today. What do you remember about them?", .accessible),
                // Observational
                LeveledPrompt("Describe someone from your day as if you're introducing them as a character in a story.", .observational),
                LeveledPrompt("What did someone do today that was characteristic of them? Describe the action.", .observational),
                LeveledPrompt("Pick a person from your day. What would someone else have noticed about them?", .observational),
                LeveledPrompt("Describe how someone moved or gestured today. What did their body language look like?", .observational),
                // Ethnographic
                LeveledPrompt("Describe someone from today as if you've never met a human before. What do you observe?", .ethnographic),
                LeveledPrompt("What did someone's hands do while they talked today? Describe the movements.", .ethnographic),
                LeveledPrompt("Pick a person from your day. Describe their voice — tone, speed, texture.", .ethnographic),
            ]

        case .place:
            return [
                // Accessible
                LeveledPrompt("Where did you spend time today? Describe what the space looked like.", .accessible),
                LeveledPrompt("Pick a room or location from your day. What do you remember seeing there?", .accessible),
                LeveledPrompt("Describe somewhere you went today. What did you notice about it?", .accessible),
                LeveledPrompt("Where were you when something happened today? Describe that place.", .accessible),
                LeveledPrompt("Think of a space you were in today. What sounds or activity were around you?", .accessible),
                LeveledPrompt("Describe a place you visited today. What was it like?", .accessible),
                // Observational
                LeveledPrompt("Describe a place from today as if giving directions to someone who's never been there.", .observational),
                LeveledPrompt("What did a space you were in today feel like? Crowded? Quiet? Bright? Describe it.", .observational),
                LeveledPrompt("Pick a place from your day. What would a photograph of it show?", .observational),
                LeveledPrompt("Describe the light in a place you were today. What did it do to the space?", .observational),
                // Ethnographic
                LeveledPrompt("Describe a room you were in today. What would an architect notice?", .ethnographic),
                LeveledPrompt("What did a place smell like today? What sounds were there? Describe the sensory environment.", .ethnographic),
                LeveledPrompt("Pick a space from your day. How did people move through it? What paths did they take?", .ethnographic),
            ]

        case .conversation:
            return [
                // Accessible
                LeveledPrompt("Describe a conversation you had today. What words did the other person use?", .accessible),
                LeveledPrompt("What did someone say to you today? Try to remember their exact words.", .accessible),
                LeveledPrompt("Pick a conversation from today. What was it about? What do you remember being said?", .accessible),
                LeveledPrompt("Who did you talk to today? Describe how the conversation went.", .accessible),
                LeveledPrompt("What's one thing someone said to you today that you remember?", .accessible),
                LeveledPrompt("Describe a conversation from today. Who spoke first? What did they say?", .accessible),
                // Observational
                LeveledPrompt("Describe a conversation from today. What was said vs. what was meant?", .observational),
                LeveledPrompt("What was the tone of a conversation you had today? Fast? Slow? Tense? Describe it.", .observational),
                LeveledPrompt("Pick a conversation from today. What wasn't said that was present anyway?", .observational),
                LeveledPrompt("Describe an exchange from today. Who was talking more? Who was listening?", .observational),
                // Ethnographic
                LeveledPrompt("Describe a conversation from today as if you're transcribing it for a researcher.", .ethnographic),
                LeveledPrompt("What was the subtext of a conversation you had today? What was really being discussed?", .ethnographic),
                LeveledPrompt("Pick a conversation from today. Describe the pauses, the interruptions, the rhythm.", .ethnographic),
            ]

        case .object:
            return [
                // Accessible
                LeveledPrompt("What's something you used today? Describe what it looked like.", .accessible),
                LeveledPrompt("Pick an object you touched or held today. What do you remember about it?", .accessible),
                LeveledPrompt("Describe something you saw today that you interacted with.", .accessible),
                LeveledPrompt("What's an object from your day that you remember? Describe it.", .accessible),
                LeveledPrompt("Think of something you picked up or used today. What was it like?", .accessible),
                LeveledPrompt("Describe something you looked at today. What did it look like?", .accessible),
                // Observational
                LeveledPrompt("Pick an object from your day. Describe it as if someone has never seen one.", .observational),
                LeveledPrompt("What object did you interact with today that you usually don't think about? Describe it.", .observational),
                LeveledPrompt("Describe something you used today. What does it look like after being used?", .observational),
                LeveledPrompt("Pick an object from today. What details would you include if drawing it?", .observational),
                // Ethnographic
                LeveledPrompt("Describe an object you touched today. Its weight in your hand. Its texture. Its temperature.", .ethnographic),
                LeveledPrompt("Pick something you used today. What would an archaeologist conclude about it?", .ethnographic),
                LeveledPrompt("What object from today has a history? Describe the object and imagine its past.", .ethnographic),
            ]

        case .moment:
            return [
                // Accessible
                LeveledPrompt("Describe a specific moment from today. What happened?", .accessible),
                LeveledPrompt("Pick one thing that happened today and describe it in detail.", .accessible),
                LeveledPrompt("What's a moment from today you'd tell someone about? What happened?", .accessible),
                LeveledPrompt("Describe something that happened today — beginning, middle, and end.", .accessible),
                LeveledPrompt("Think of one moment from today. Who was there? What occurred?", .accessible),
                LeveledPrompt("What happened today that stood out? Describe that moment.", .accessible),
                // Observational
                LeveledPrompt("Describe a moment from today that shifted something — your mood, the room, the conversation.", .observational),
                LeveledPrompt("What's a moment from today that lasted less than a minute? Describe it fully.", .observational),
                LeveledPrompt("Pick a moment from today. What happened right before it? Right after?", .observational),
                LeveledPrompt("Describe a transition from today — arriving, leaving, starting, or ending something.", .observational),
                // Ethnographic
                LeveledPrompt("Describe a moment from today in slow motion. What would frame-by-frame reveal?", .ethnographic),
                LeveledPrompt("Pick a moment of tension from today — even small tension. Describe what created it.", .ethnographic),
                LeveledPrompt("What moment from today contained a decision? Describe the moment, not the decision.", .ethnographic),
            ]

        case .routine:
            return [
                // Accessible
                LeveledPrompt("Describe something you do every day. What happened when you did it today?", .accessible),
                LeveledPrompt("Pick a routine from your day. Walk through what you did.", .accessible),
                LeveledPrompt("What's something you did today that you do most days? Describe how it went.", .accessible),
                LeveledPrompt("Describe your morning (or evening) today. What did you do?", .accessible),
                LeveledPrompt("Think of a habit or routine. What do you remember about doing it today?", .accessible),
                LeveledPrompt("What's something you do regularly? Describe doing it today.", .accessible),
                // Observational
                LeveledPrompt("Describe a routine from today. What was different about it this time?", .observational),
                LeveledPrompt("Walk through something you do automatically. What steps are involved?", .observational),
                LeveledPrompt("Pick a routine from today. What would someone watching you see?", .observational),
                LeveledPrompt("Describe a habit from today. How long did it take? What did you do with your hands?", .observational),
                // Ethnographic
                LeveledPrompt("Describe a routine from today as if you're an anthropologist observing it for the first time.", .ethnographic),
                LeveledPrompt("Pick a daily ritual. Describe the objects, movements, and sequence involved.", .ethnographic),
                LeveledPrompt("What routine from today would confuse someone from another century? Describe it for them.", .ethnographic),
            ]
        }
    }

    // MARK: - Phase 2 Prompts (Reflect)

    var phase2Prompts: [String] {
        switch self {

        case .open:
            return [
                "Why did you choose to describe that moment?",
                "What did you leave out of this description?",
                "What would someone else have noticed that you didn't mention?",
                "What made this worth capturing?",
                "What were you not paying attention to while this happened?",
            ]

        case .person:
            return [
                "What did you leave out about this person?",
                "What would they say you got wrong?",
                "Why did you notice what you noticed about them?",
                "What do you usually notice about people that you didn't mention here?",
                "What might this person have been thinking that you didn't see?",
            ]

        case .place:
            return [
                "What's your relationship to this place?",
                "What did you leave out about this space?",
                "How did this place affect how you felt or moved?",
                "What would someone visiting for the first time notice that you didn't?",
                "Why did this place matter to the moment you described?",
            ]

        case .conversation:
            return [
                "What wasn't said in this conversation?",
                "What was the subtext?",
                "How would the other person describe this same conversation?",
                "What were you trying to communicate that you didn't say directly?",
                "Where was the tension, if any?",
            ]

        case .object:
            return [
                "Why does this object matter to you?",
                "What does this object represent or stand for?",
                "What's the history of this object that you didn't mention?",
                "Why did you notice this object and not others around it?",
                "What would be different if this object wasn't there?",
            ]

        case .moment:
            return [
                "What was at stake in this moment?",
                "What happened right before this that you didn't include?",
                "Why did this moment stick with you?",
                "What did you feel that you didn't describe?",
                "What question does this moment raise?",
            ]

        case .routine:
            return [
                "What does this routine give you?",
                "What would be different if you didn't do this?",
                "Why did you start doing this? Do you remember?",
                "What does this routine protect you from — or connect you to?",
                "What would someone learn about you from watching this routine?",
            ]
        }
    }

    // MARK: - Helper to get filtered Phase 1 prompts

    func phase1Prompts(forCaptureCount count: Int) -> [LeveledPrompt] {
        let maxLevel = PromptLevel.forCaptureCount(count)
        return phase1Prompts.filter { prompt in
            switch (prompt.level, maxLevel) {
            case (.accessible, _): return true
            case (.observational, .observational), (.observational, .ethnographic): return true
            case (.ethnographic, .ethnographic): return true
            default: return false
            }
        }
    }

    func randomPhase1Prompt(forCaptureCount count: Int) -> String {
        let eligible = phase1Prompts(forCaptureCount: count)
        return eligible.randomElement()?.text ?? phase1Prompts.first!.text
    }

    func randomPhase2Prompt() -> String {
        return phase2Prompts.randomElement() ?? phase2Prompts.first!
    }
}

// MARK: - PromptDomain

enum PromptDomain: String, Codable, CaseIterable {
    case interpersonal   // relationships, family, friends
    case professional    // work, career, colleagues
    case `internal`      // self-reflection, emotions, body (backticks because reserved word)
    case environmental   // places, objects, surroundings
}
