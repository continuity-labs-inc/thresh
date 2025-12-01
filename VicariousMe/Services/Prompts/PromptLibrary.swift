import Foundation

/// The PromptLibrary provides contextual prompts for reflection activities.
/// It manages prompts for different tiers, modes, and user development stages.
@Observable
final class PromptLibrary {
    /// Shared instance for app-wide access
    static let shared = PromptLibrary()

    /// Loaded prompt data
    private var promptData: PromptData?

    /// Aggregation prompts for synthesis at different tiers
    private let aggregationPrompts: [ReflectionTier: [AggregationPrompt]] = [
        .weekly: [
            AggregationPrompt(
                id: "weekly-1",
                text: "Looking back at this week's captures, what thread connects them?",
                guidance: "Don't summarize what happened. Ask what it means.",
                stages: [.emerging, .developing, .established, .fluent]
            ),
            AggregationPrompt(
                id: "weekly-2",
                text: "What question is this week asking you?",
                guidance: "Let the patterns reveal what you're grappling with.",
                stages: [.developing, .established, .fluent]
            ),
            AggregationPrompt(
                id: "weekly-3",
                text: "What do you understand now that you didn't at the start of the week?",
                guidance: "Synthesis generates new insight, it doesn't just collect old ones.",
                stages: [.established, .fluent]
            )
        ],
        .monthly: [
            AggregationPrompt(
                id: "monthly-1",
                text: "What theme has been quietly persistent this month?",
                guidance: "Monthly synthesis reveals what you've been circling around.",
                stages: [.emerging, .developing, .established, .fluent]
            ),
            AggregationPrompt(
                id: "monthly-2",
                text: "If this month were a chapter, what would it be titled?",
                guidance: "Find the narrative arc in your experiences.",
                stages: [.developing, .established, .fluent]
            )
        ],
        .yearly: [
            AggregationPrompt(
                id: "yearly-1",
                text: "What transformation happened this year that you couldn't have predicted?",
                guidance: "Yearly synthesis is about seeing the shape of your growth.",
                stages: [.emerging, .developing, .established, .fluent]
            )
        ]
    ]

    init() {
        loadPrompts()
    }

    private func loadPrompts() {
        guard let url = Bundle.main.url(forResource: "PromptLibrary", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(PromptData.self, from: data) else {
            return
        }
        promptData = decoded
    }

    /// Get an aggregation prompt for the given tier, optionally filtered by stage
    func getAggregationPrompt(tier: ReflectionTier, stage: DevelopmentStage? = nil) -> AggregationPrompt {
        guard let prompts = aggregationPrompts[tier] else {
            return AggregationPrompt(
                id: "default",
                text: "What patterns do you notice?",
                guidance: "Look for connections across your reflections.",
                stages: DevelopmentStage.allCases
            )
        }

        let filtered: [AggregationPrompt]
        if let stage = stage {
            filtered = prompts.filter { $0.stages.contains(stage) }
        } else {
            filtered = prompts
        }

        return filtered.randomElement() ?? prompts.first!
    }

    /// Get a capture prompt for the given focus type and stage
    func getCapturePrompt(focusType: FocusType, stage: DevelopmentStage) -> String {
        // Default prompts if JSON not loaded
        let defaults: [FocusType: String] = [
            .story: "Tell me about a moment that stood out today.",
            .idea: "What's been on your mind lately?",
            .question: "What are you curious about right now?"
        ]

        guard let data = promptData,
              let prompts = data.prompts.capture[focusType.rawValue],
              let prompt = prompts.first(where: { $0.stages.contains(stage.rawValue) }) else {
            return defaults[focusType] ?? "What would you like to capture?"
        }

        return prompt.text
    }
}

// MARK: - Supporting Types

/// A prompt for aggregation/synthesis activities
struct AggregationPrompt: Identifiable, Sendable {
    let id: String
    let text: String
    let guidance: String
    let stages: [DevelopmentStage]
}

// MARK: - JSON Decoding Types

private struct PromptData: Codable {
    let version: String
    let lastUpdated: String
    let prompts: PromptCategories
}

private struct PromptCategories: Codable {
    let capture: [String: [PromptItem]]
    let synthesis: [String: [PromptItem]]
}

private struct PromptItem: Codable {
    let id: String
    let text: String
    let stage: [String]

    var stages: [String] { stage }
}
