import Foundation
import SwiftUI

/// Service providing contextual prompts for reflection
@Observable
final class PromptLibrary {
    // MARK: - Prompts Storage

    private let prompts: [Prompt]

    // MARK: - Initialization

    init() {
        self.prompts = Self.createPromptLibrary()
    }

    // MARK: - Public Methods

    /// Get a prompt by type
    func getPrompt(type: PromptType) -> Prompt? {
        prompts.first { $0.type == type }
    }

    /// Get a capture prompt, optionally filtered by focus type and stage
    func getCapturePrompt(focusType: FocusType?, stage: DevelopmentalStage) -> Prompt {
        // Try to find a prompt matching focus type
        if let focus = focusType,
           let prompt = prompts.first(where: {
               $0.type == .capture && $0.focusType == focus
           }) {
            return prompt
        }

        // Fall back to stage-appropriate generic capture prompt
        if let prompt = prompts.first(where: {
            $0.type == .capture && $0.focusType == nil && $0.stage == stage
        }) {
            return prompt
        }

        // Default capture prompt
        return prompts.first { $0.type == .capture && $0.focusType == nil }
            ?? Prompt(
                id: "default_capture",
                type: .capture,
                content: "What did you notice?",
                subtext: "Describe what you observed without interpretation."
            )
    }

    /// Get a synthesis prompt for a specific tier and stage
    func getSynthesisPrompt(tier: ReflectionTier, stage: DevelopmentalStage) -> Prompt {
        // Try to find tier-specific prompt
        if let prompt = prompts.first(where: {
            $0.type == .synthesis && $0.tier == tier
        }) {
            return prompt
        }

        // Default synthesis prompt
        return prompts.first { $0.type == .synthesis }
            ?? Prompt(
                id: "default_synthesis",
                type: .synthesis,
                content: "What might this mean?",
                subtext: "If you want, explore what significance this holds."
            )
    }

    /// Get all prompts of a specific type
    func getPrompts(ofType type: PromptType) -> [Prompt] {
        prompts.filter { $0.type == type }
    }

    // MARK: - Prompt Library Creation

    private static func createPromptLibrary() -> [Prompt] {
        var library: [Prompt] = []

        // MARK: Orientation Prompts

        library.append(Prompt(
            id: "orientation_main",
            type: .orientation,
            content: "Take a breath. What's present for you right now?",
            subtext: "Ground yourself before reflecting."
        ))

        // MARK: Generic Capture Prompts

        library.append(Prompt(
            id: "capture_emerging",
            type: .capture,
            content: "What happened? Describe the scene.",
            subtext: "Focus on what you saw, heard, or experienced—like a camera recording.",
            stage: .emerging
        ))

        library.append(Prompt(
            id: "capture_developing",
            type: .capture,
            content: "What did you notice?",
            subtext: "Capture the details before interpreting.",
            stage: .developing
        ))

        library.append(Prompt(
            id: "capture_established",
            type: .capture,
            content: "What's the raw material?",
            subtext: nil,
            stage: .established
        ))

        library.append(Prompt(
            id: "capture_integrating",
            type: .capture,
            content: "Observe.",
            subtext: nil,
            stage: .integrating
        ))

        // MARK: Focus-Specific Capture Prompts

        library.append(Prompt(
            id: "capture_body",
            type: .capture,
            content: "What sensations did you notice in your body?",
            subtext: "Temperature, tension, movement, position, breathing.",
            focusType: .body
        ))

        library.append(Prompt(
            id: "capture_emotion",
            type: .capture,
            content: "What feelings arose?",
            subtext: "Name them without explaining them.",
            focusType: .emotion
        ))

        library.append(Prompt(
            id: "capture_thought",
            type: .capture,
            content: "What thoughts passed through?",
            subtext: "Capture them like clouds drifting by.",
            focusType: .thought
        ))

        library.append(Prompt(
            id: "capture_relationship",
            type: .capture,
            content: "What happened between you and others?",
            subtext: "Words exchanged, looks shared, distance felt.",
            focusType: .relationship
        ))

        library.append(Prompt(
            id: "capture_environment",
            type: .capture,
            content: "What was your surroundings like?",
            subtext: "Light, sound, space, objects, atmosphere.",
            focusType: .environment
        ))

        library.append(Prompt(
            id: "capture_spirit",
            type: .capture,
            content: "What stirred in your deeper self?",
            subtext: "Moments of meaning, connection, or transcendence.",
            focusType: .spirit
        ))

        // MARK: Synthesis Prompts

        library.append(Prompt(
            id: "synthesis_daily",
            type: .synthesis,
            content: "What might this mean to you?",
            subtext: "If you want, explore what significance this moment holds.",
            tier: .daily
        ))

        library.append(Prompt(
            id: "synthesis_weekly",
            type: .synthesis,
            content: "What patterns do you notice across these moments?",
            subtext: "Look for threads connecting your daily observations.",
            tier: .weekly
        ))

        library.append(Prompt(
            id: "synthesis_monthly",
            type: .synthesis,
            content: "What story is emerging from this month?",
            subtext: "Step back and see the larger arc.",
            tier: .monthly
        ))

        library.append(Prompt(
            id: "synthesis_seasonal",
            type: .synthesis,
            content: "How has this season shaped you?",
            subtext: "Consider growth, challenges, and transformations.",
            tier: .seasonal
        ))

        library.append(Prompt(
            id: "synthesis_annual",
            type: .synthesis,
            content: "What has this year meant for your journey?",
            subtext: "Reflect on the whole arc of the year.",
            tier: .annual
        ))

        // MARK: Transition Prompts

        library.append(Prompt(
            id: "transition_to_synthesis",
            type: .transition,
            content: "Now, if you'd like, step back and find meaning.",
            subtext: "This part is optional—the capture alone has value."
        ))

        return library
    }
}
