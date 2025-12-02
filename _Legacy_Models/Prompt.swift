import Foundation

/// A reflective prompt to guide user input
struct Prompt: Identifiable, Codable {
    let id: String
    let type: PromptType
    let content: String
    let subtext: String?

    /// Optional focus type this prompt is specific to
    let focusType: FocusType?

    /// Optional stage this prompt is tailored for
    let stage: DevelopmentalStage?

    /// Optional tier this prompt is designed for
    let tier: ReflectionTier?

    init(
        id: String,
        type: PromptType,
        content: String,
        subtext: String? = nil,
        focusType: FocusType? = nil,
        stage: DevelopmentalStage? = nil,
        tier: ReflectionTier? = nil
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.subtext = subtext
        self.focusType = focusType
        self.stage = stage
        self.tier = tier
    }
}
