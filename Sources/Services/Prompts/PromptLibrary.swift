import Foundation
import SwiftUI

// MARK: - Prompt Model

/// A prompt used to guide reflection.
/// Prompts are categorized by mode, type, tier, focus, and user development stage.
struct Prompt: Codable, Identifiable, Equatable {
    let id: String
    let mode: PromptMode
    let type: PromptType
    let tier: ReflectionTier?
    let focusType: FocusType?
    let stage: DevelopmentStage?
    let text: String
    let followUp: String?
    let isHumor: Bool

    init(
        id: String,
        mode: PromptMode,
        type: PromptType,
        tier: ReflectionTier? = nil,
        focusType: FocusType? = nil,
        stage: DevelopmentStage? = nil,
        text: String,
        followUp: String? = nil,
        isHumor: Bool = false
    ) {
        self.id = id
        self.mode = mode
        self.type = type
        self.tier = tier
        self.focusType = focusType
        self.stage = stage
        self.text = text
        self.followUp = followUp
        self.isHumor = isHumor
    }
}

// MARK: - Prompt Mode

/// The fundamental mode of a prompt.
/// Capture prompts focus on observation; synthesis prompts focus on meaning.
enum PromptMode: String, Codable, CaseIterable {
    case capture      // Observation prompts—what happened
    case synthesis    // Interpretation prompts—what it means
    case either       // Works for both modes

    var displayName: String {
        switch self {
        case .capture: return "Capture"
        case .synthesis: return "Synthesis"
        case .either: return "Either"
        }
    }
}

// MARK: - Prompt Type

/// The functional type of a prompt—what role it plays in the reflection process.
enum PromptType: String, Codable, CaseIterable {
    case orientation        // Lens selection—what to focus on
    case primary            // Main prompt—the core question
    case captureQuality     // Improving observation quality
    case lensProgression    // Moving deeper (synthesis only)
    case voiceExpansion     // Adding perspectives
    case refinement         // Post-writing enhancement
    case aggregation        // Weekly+ synthesis across captures

    var displayName: String {
        switch self {
        case .orientation: return "Orientation"
        case .primary: return "Primary"
        case .captureQuality: return "Capture Quality"
        case .lensProgression: return "Lens Progression"
        case .voiceExpansion: return "Voice Expansion"
        case .refinement: return "Refinement"
        case .aggregation: return "Aggregation"
        }
    }
}

// MARK: - Prompt Library

/// The central service for accessing reflection prompts.
/// Manages prompts by mode, type, tier, and user development stage.
///
/// Key design principle: Capture is HARDER than synthesis.
/// "What happened?" requires discipline.
/// "What did you learn?" is easy—we do it automatically.
@Observable
final class PromptLibrary {
    // MARK: - Properties

    private var prompts: [Prompt] = []
    private let humorChance: Double = 0.15

    // MARK: - Initialization

    init() {
        loadPrompts()
    }

    /// Initialize with custom prompts (for testing)
    init(prompts: [Prompt]) {
        self.prompts = prompts
    }

    // MARK: - Loading

    private func loadPrompts() {
        // Try to load from bundle
        guard let url = Bundle.main.url(forResource: "PromptLibrary", withExtension: "json") else {
            print("PromptLibrary.json not found in bundle, loading defaults")
            loadDefaultPrompts()
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            prompts = try decoder.decode([Prompt].self, from: data)
        } catch {
            print("Error loading prompts: \(error). Loading defaults.")
            loadDefaultPrompts()
        }
    }

    private func loadDefaultPrompts() {
        prompts = Self.defaultPrompts
    }

    // MARK: - Capture Prompts (The Hard Skill)

    /// Get a capture prompt appropriate for the focus type and development stage.
    /// Capture prompts emphasize observation over interpretation.
    func getCapturePrompt(focusType: FocusType?, stage: DevelopmentStage) -> Prompt {
        var candidates = prompts.filter { prompt in
            prompt.mode == .capture &&
            prompt.type == .primary
        }

        // Filter by focus type if specified
        if let focusType = focusType {
            let focusMatches = candidates.filter { $0.focusType == focusType }
            if !focusMatches.isEmpty {
                candidates = focusMatches
            }
        }

        // Filter by stage (or lower)
        let stageMatches = candidates.filter {
            guard let promptStage = $0.stage else { return true }
            return promptStage.rawValue <= stage.rawValue
        }
        if !stageMatches.isEmpty {
            candidates = stageMatches
        }

        // Consider humor injection
        if shouldInjectHumor() {
            let humorPrompts = candidates.filter { $0.isHumor }
            if let humor = humorPrompts.randomElement() {
                return humor
            }
        }

        // Return random non-humor prompt, or fallback
        let nonHumorPrompts = candidates.filter { !$0.isHumor }
        return nonHumorPrompts.randomElement() ?? candidates.randomElement() ?? Self.fallbackCapturePrompt
    }

    /// Get a prompt to improve capture quality based on what's missing.
    func getCaptureQualityPrompt(for quality: CaptureQuality) -> Prompt? {
        guard quality != .excellent else { return nil }

        let candidates = prompts.filter { $0.type == .captureQuality }

        // Match based on typical gaps at this quality level
        let gaps = quality.typicalGaps
        if let gap = gaps.randomElement() {
            return candidates.first { $0.id.contains(gap.rawValue) } ?? candidates.randomElement()
        }

        return candidates.randomElement()
    }

    /// Get a prompt for a specific capture gap
    func getCaptureQualityPrompt(for gap: CaptureGap) -> Prompt? {
        return prompts.first { $0.type == .captureQuality && $0.id.contains(gap.rawValue) }
    }

    // MARK: - Synthesis Prompts (Offered After Capture)

    /// Get a synthesis prompt appropriate for the tier and development stage.
    /// Only offered after capture is complete.
    func getSynthesisPrompt(tier: ReflectionTier, stage: DevelopmentStage) -> Prompt {
        var candidates = prompts.filter { prompt in
            prompt.mode == .synthesis &&
            prompt.type == .primary
        }

        // Filter by tier
        let tierMatches = candidates.filter { $0.tier == tier || $0.tier == nil }
        if !tierMatches.isEmpty {
            candidates = tierMatches
        }

        // Filter by stage
        let stageMatches = candidates.filter {
            guard let promptStage = $0.stage else { return true }
            return promptStage.rawValue <= stage.rawValue
        }
        if !stageMatches.isEmpty {
            candidates = stageMatches
        }

        // Consider humor injection
        if shouldInjectHumor() {
            let humorPrompts = candidates.filter { $0.isHumor }
            if let humor = humorPrompts.randomElement() {
                return humor
            }
        }

        let nonHumorPrompts = candidates.filter { !$0.isHumor }
        return nonHumorPrompts.randomElement() ?? candidates.randomElement() ?? Self.fallbackSynthesisPrompt
    }

    /// Get an aggregation prompt for weekly+ synthesis.
    /// Emphasizes finding threads, not summarizing.
    func getAggregationPrompt(tier: ReflectionTier) -> Prompt {
        var candidates = prompts.filter { $0.type == .aggregation }

        // Filter by tier
        let tierMatches = candidates.filter { $0.tier == tier || $0.tier == nil }
        if !tierMatches.isEmpty {
            candidates = tierMatches
        }

        return candidates.randomElement() ?? Self.fallbackAggregationPrompt
    }

    // MARK: - Adaptive Prompts

    /// Get a prompt adjusted for user development stage.
    /// Stage 1: High scaffolding, examples
    /// Stage 4: Minimal prompt or blank space
    func getPromptForStage(_ stage: DevelopmentStage, mode: PromptMode) -> Prompt {
        // Fluent users may prefer blank space
        if stage == .fluent && Bool.random() {
            return mode == .capture ? Self.blankSpaceCapturePrompt : Self.blankSpaceSynthesisPrompt
        }

        if mode == .capture {
            return getCapturePrompt(focusType: nil, stage: stage)
        } else {
            return getSynthesisPrompt(tier: .daily, stage: stage)
        }
    }

    // MARK: - Orientation Prompts

    /// Get a prompt to help the user choose a focus lens
    func getOrientationPrompt(stage: DevelopmentStage) -> Prompt {
        let candidates = prompts.filter { $0.type == .orientation }

        let stageMatches = candidates.filter {
            guard let promptStage = $0.stage else { return true }
            return promptStage.rawValue <= stage.rawValue
        }

        return stageMatches.randomElement() ?? candidates.randomElement() ?? Self.fallbackOrientationPrompt
    }

    // MARK: - Lens Progression Prompts

    /// Get a prompt to move deeper into a topic (synthesis only)
    func getLensProgressionPrompt() -> Prompt {
        let candidates = prompts.filter { $0.type == .lensProgression }
        return candidates.randomElement() ?? Self.fallbackLensProgressionPrompt
    }

    // MARK: - Voice Expansion Prompts

    /// Get a prompt to add perspectives
    func getVoiceExpansionPrompt() -> Prompt {
        let candidates = prompts.filter { $0.type == .voiceExpansion }
        return candidates.randomElement() ?? Self.fallbackVoiceExpansionPrompt
    }

    // MARK: - Refinement Prompts

    /// Get a prompt for post-writing enhancement
    func getRefinementPrompt(mode: PromptMode) -> Prompt {
        let candidates = prompts.filter {
            $0.type == .refinement &&
            ($0.mode == mode || $0.mode == .either)
        }
        return candidates.randomElement() ?? Self.fallbackRefinementPrompt
    }

    // MARK: - Humor Injection

    /// Determine if humor should be injected (15% chance)
    func shouldInjectHumor() -> Bool {
        return Double.random(in: 0...1) < humorChance
    }

    // MARK: - Filtering

    /// Get all prompts matching the given criteria
    func getPrompts(
        mode: PromptMode? = nil,
        type: PromptType? = nil,
        tier: ReflectionTier? = nil,
        focusType: FocusType? = nil,
        stage: DevelopmentStage? = nil
    ) -> [Prompt] {
        return prompts.filter { prompt in
            if let mode = mode, prompt.mode != mode && prompt.mode != .either { return false }
            if let type = type, prompt.type != type { return false }
            if let tier = tier, prompt.tier != nil && prompt.tier != tier { return false }
            if let focusType = focusType, prompt.focusType != nil && prompt.focusType != focusType { return false }
            if let stage = stage, prompt.stage != nil && prompt.stage!.rawValue > stage.rawValue { return false }
            return true
        }
    }

    /// Get the total number of prompts
    var promptCount: Int {
        prompts.count
    }
}

// MARK: - Fallback Prompts

extension PromptLibrary {
    static let fallbackCapturePrompt = Prompt(
        id: "fallback_capture",
        mode: .capture,
        type: .primary,
        text: "What happened? Describe it like a camera would record it.",
        followUp: "What did you see or hear specifically?"
    )

    static let fallbackSynthesisPrompt = Prompt(
        id: "fallback_synthesis",
        mode: .synthesis,
        type: .primary,
        text: "Now that you've captured it: what does this mean to you?",
        followUp: "What assumption might you be making?"
    )

    static let fallbackAggregationPrompt = Prompt(
        id: "fallback_aggregation",
        mode: .synthesis,
        type: .aggregation,
        text: "What thread connects these captures? Not a summary—what do you understand now?",
        followUp: nil
    )

    static let fallbackOrientationPrompt = Prompt(
        id: "fallback_orientation",
        mode: .either,
        type: .orientation,
        text: "What's calling for your attention today?",
        followUp: nil
    )

    static let fallbackLensProgressionPrompt = Prompt(
        id: "fallback_lens_progression",
        mode: .synthesis,
        type: .lensProgression,
        text: "What's beneath what you just wrote?",
        followUp: nil
    )

    static let fallbackVoiceExpansionPrompt = Prompt(
        id: "fallback_voice_expansion",
        mode: .synthesis,
        type: .voiceExpansion,
        text: "How might someone who disagrees see this?",
        followUp: nil
    )

    static let fallbackRefinementPrompt = Prompt(
        id: "fallback_refinement",
        mode: .either,
        type: .refinement,
        text: "Read it back. What's missing?",
        followUp: nil
    )

    static let blankSpaceCapturePrompt = Prompt(
        id: "blank_space_capture",
        mode: .capture,
        type: .primary,
        stage: .fluent,
        text: "",
        followUp: nil
    )

    static let blankSpaceSynthesisPrompt = Prompt(
        id: "blank_space_synthesis",
        mode: .synthesis,
        type: .primary,
        stage: .fluent,
        text: "",
        followUp: nil
    )
}

// MARK: - Default Prompts

extension PromptLibrary {
    static let defaultPrompts: [Prompt] = [
        // MARK: Capture Prompts - Primary

        // General capture prompts
        Prompt(
            id: "capture_camera",
            mode: .capture,
            type: .primary,
            text: "Describe the scene like a camera would record it. No meanings—just what happened.",
            followUp: "What detail stands out most?"
        ),
        Prompt(
            id: "capture_sensory",
            mode: .capture,
            type: .primary,
            text: "What did you see, hear, smell, or feel? One specific detail.",
            followUp: "Can you add another sensory detail?"
        ),
        Prompt(
            id: "capture_dialogue",
            mode: .capture,
            type: .primary,
            text: "What was actually said? Try to recall exact words.",
            followUp: "What was left unsaid?"
        ),
        Prompt(
            id: "capture_action",
            mode: .capture,
            type: .primary,
            text: "What did people do—not what they felt, but what they did?",
            followUp: "What did you do in response?"
        ),
        Prompt(
            id: "capture_sequence",
            mode: .capture,
            type: .primary,
            text: "Walk through the sequence. What happened first? Then what?",
            followUp: "What happened right before it ended?"
        ),

        // Emerging stage capture prompts (high scaffolding)
        Prompt(
            id: "capture_emerging_1",
            mode: .capture,
            type: .primary,
            stage: .emerging,
            text: "Picture yourself back in that moment. What's the first thing you notice?",
            followUp: "Now look around—what else is there?"
        ),
        Prompt(
            id: "capture_emerging_2",
            mode: .capture,
            type: .primary,
            stage: .emerging,
            text: "If you were describing this to someone who wasn't there, what would they need to know?",
            followUp: "What would they still be confused about?"
        ),

        // Focus-type specific capture prompts
        Prompt(
            id: "capture_event",
            mode: .capture,
            type: .primary,
            focusType: .event,
            text: "Walk me through what happened, step by step.",
            followUp: "What was the turning point?"
        ),
        Prompt(
            id: "capture_person",
            mode: .capture,
            type: .primary,
            focusType: .person,
            text: "What did they say? What did they do? Be specific.",
            followUp: "What did their face or body show?"
        ),
        Prompt(
            id: "capture_place",
            mode: .capture,
            type: .primary,
            focusType: .place,
            text: "Describe this place. What would someone notice first?",
            followUp: "What's in the corners? The details?"
        ),
        Prompt(
            id: "capture_emotion",
            mode: .capture,
            type: .primary,
            focusType: .emotion,
            text: "When did you first notice this feeling? What was happening?",
            followUp: "Where in your body did you feel it?"
        ),

        // Humor capture prompts
        Prompt(
            id: "capture_humor_1",
            mode: .capture,
            type: .primary,
            text: "If your day were a movie scene, what would the camera show?",
            followUp: "What would be on the soundtrack?",
            isHumor: true
        ),
        Prompt(
            id: "capture_humor_2",
            mode: .capture,
            type: .primary,
            text: "Pretend you're a detective taking notes. Just the facts.",
            followUp: "What would Sherlock notice that you missed?",
            isHumor: true
        ),

        // MARK: Capture Quality Prompts

        Prompt(
            id: "quality_missingScene",
            mode: .capture,
            type: .captureQuality,
            text: "A stranger couldn't picture this yet. Where exactly were you?",
            followUp: "What time of day? What was the light like?"
        ),
        Prompt(
            id: "quality_missingDialogue",
            mode: .capture,
            type: .captureQuality,
            text: "Can you recall any exact words? They often reveal more than summaries.",
            followUp: "What about tone—how did they say it?"
        ),
        Prompt(
            id: "quality_missingSequence",
            mode: .capture,
            type: .captureQuality,
            text: "This feels like a snapshot. What happened before? What after?",
            followUp: "What started it? What ended it?"
        ),
        Prompt(
            id: "quality_missingAction",
            mode: .capture,
            type: .captureQuality,
            text: "You wrote about feelings. What did people actually *do*?",
            followUp: "What did their hands do? Their eyes?"
        ),
        Prompt(
            id: "quality_missingSensory",
            mode: .capture,
            type: .captureQuality,
            text: "I can't hear or see this yet. What sounds were there? Colors?",
            followUp: "What did the air feel like?"
        ),
        Prompt(
            id: "quality_tooAbstract",
            mode: .capture,
            type: .captureQuality,
            text: "You wrote 'she was upset.' What did she actually do or say that showed this?",
            followUp: "What did you observe, separate from what you concluded?"
        ),

        // MARK: Synthesis Prompts - Primary

        Prompt(
            id: "synthesis_why",
            mode: .synthesis,
            type: .primary,
            text: "Now that you've captured it: why did this stick with you?",
            followUp: "What does that tell you about what you value?"
        ),
        Prompt(
            id: "synthesis_assumption",
            mode: .synthesis,
            type: .primary,
            text: "What assumption might you be making here?",
            followUp: "What if the opposite were true?"
        ),
        Prompt(
            id: "synthesis_question",
            mode: .synthesis,
            type: .primary,
            text: "What question is this experience asking you?",
            followUp: "Do you want to answer it?"
        ),
        Prompt(
            id: "synthesis_pattern",
            mode: .synthesis,
            type: .primary,
            text: "Have you been here before? Does this remind you of anything?",
            followUp: "What's different this time?"
        ),
        Prompt(
            id: "synthesis_learning",
            mode: .synthesis,
            type: .primary,
            text: "What are you learning from this—not what you should learn, but what you *are* learning?",
            followUp: "Is that the lesson you want?"
        ),

        // Weekly synthesis prompts
        Prompt(
            id: "synthesis_weekly_1",
            mode: .synthesis,
            type: .primary,
            tier: .weekly,
            text: "Looking at this week: what surprised you?",
            followUp: "Why was it surprising?"
        ),
        Prompt(
            id: "synthesis_weekly_2",
            mode: .synthesis,
            type: .primary,
            tier: .weekly,
            text: "What's different about you now compared to Monday?",
            followUp: "Is that growth or just change?"
        ),

        // Humor synthesis prompts
        Prompt(
            id: "synthesis_humor_1",
            mode: .synthesis,
            type: .primary,
            text: "If your wisest friend were reading this, what would they say?",
            followUp: "Do you agree with them?",
            isHumor: true
        ),

        // MARK: Aggregation Prompts

        Prompt(
            id: "aggregation_thread",
            mode: .synthesis,
            type: .aggregation,
            text: "What thread connects these captures? Not a summary—what do you understand now?",
            followUp: nil
        ),
        Prompt(
            id: "aggregation_chapter",
            mode: .synthesis,
            type: .aggregation,
            tier: .weekly,
            text: "If this week were a chapter, what would it be called?",
            followUp: "What's the first line of the next chapter?"
        ),
        Prompt(
            id: "aggregation_pattern",
            mode: .synthesis,
            type: .aggregation,
            text: "Looking at these moments together: what pattern emerges?",
            followUp: "Is it a pattern you want to continue?"
        ),
        Prompt(
            id: "aggregation_monthly",
            mode: .synthesis,
            type: .aggregation,
            tier: .monthly,
            text: "This month, you captured many moments. What theme connects them?",
            followUp: "What does that theme reveal about where you are?"
        ),
        Prompt(
            id: "aggregation_quarterly",
            mode: .synthesis,
            type: .aggregation,
            tier: .quarterly,
            text: "Across these months, what direction are you moving in?",
            followUp: "Is it the direction you want?"
        ),
        Prompt(
            id: "aggregation_yearly",
            mode: .synthesis,
            type: .aggregation,
            tier: .yearly,
            text: "This year told a story. What was it about?",
            followUp: "What story do you want next year to tell?"
        ),

        // MARK: Orientation Prompts

        Prompt(
            id: "orientation_attention",
            mode: .either,
            type: .orientation,
            text: "What's calling for your attention today?",
            followUp: nil
        ),
        Prompt(
            id: "orientation_emerging",
            mode: .either,
            type: .orientation,
            stage: .emerging,
            text: "Something happened today worth noticing. It could be big or small. What comes to mind first?",
            followUp: nil
        ),
        Prompt(
            id: "orientation_event",
            mode: .either,
            type: .orientation,
            text: "Did something happen today that you're still thinking about?",
            followUp: nil
        ),
        Prompt(
            id: "orientation_person",
            mode: .either,
            type: .orientation,
            text: "Who showed up in your thoughts today?",
            followUp: nil
        ),

        // MARK: Lens Progression Prompts

        Prompt(
            id: "lens_beneath",
            mode: .synthesis,
            type: .lensProgression,
            text: "What's beneath what you just wrote?",
            followUp: nil
        ),
        Prompt(
            id: "lens_deeper",
            mode: .synthesis,
            type: .lensProgression,
            text: "Go deeper. What are you not saying yet?",
            followUp: nil
        ),
        Prompt(
            id: "lens_really",
            mode: .synthesis,
            type: .lensProgression,
            text: "What's this really about?",
            followUp: nil
        ),
        Prompt(
            id: "lens_afraid",
            mode: .synthesis,
            type: .lensProgression,
            text: "What are you afraid to admit here?",
            followUp: nil
        ),

        // MARK: Voice Expansion Prompts

        Prompt(
            id: "voice_disagree",
            mode: .synthesis,
            type: .voiceExpansion,
            text: "How might someone who disagrees see this?",
            followUp: nil
        ),
        Prompt(
            id: "voice_other",
            mode: .synthesis,
            type: .voiceExpansion,
            text: "What would the other person in this story say happened?",
            followUp: nil
        ),
        Prompt(
            id: "voice_future",
            mode: .synthesis,
            type: .voiceExpansion,
            text: "What would you-in-five-years say about this moment?",
            followUp: nil
        ),
        Prompt(
            id: "voice_young",
            mode: .synthesis,
            type: .voiceExpansion,
            text: "What would you-at-fifteen have thought of this?",
            followUp: nil
        ),

        // MARK: Refinement Prompts

        Prompt(
            id: "refinement_missing",
            mode: .either,
            type: .refinement,
            text: "Read it back. What's missing?",
            followUp: nil
        ),
        Prompt(
            id: "refinement_true",
            mode: .either,
            type: .refinement,
            text: "Is this actually true, or just how you want to see it?",
            followUp: nil
        ),
        Prompt(
            id: "refinement_capture",
            mode: .capture,
            type: .refinement,
            text: "You've told the story. Now: what did you leave out?",
            followUp: nil
        ),
        Prompt(
            id: "refinement_synthesis",
            mode: .synthesis,
            type: .refinement,
            text: "You've found meaning. Does it hold up? Or is it convenient?",
            followUp: nil
        ),
    ]
}
