import Foundation

// MARK: - Focus Type

/// The lens through which a reflection is captured
enum FocusType: String, CaseIterable, Codable {
    case body
    case emotion
    case thought
    case relationship
    case environment
    case spirit
}

// MARK: - Entry Type

/// Classification of how the reflection was created
enum EntryType: String, Codable {
    case pureCapture        // Observation only, no interpretation
    case groundedReflection // Capture + synthesis together
    case synthesisOnly      // Interpretation without concrete observation (discouraged)
}

// MARK: - Mode Balance

/// Tracks the ratio of capture vs synthesis content
enum ModeBalance: String, Codable {
    case captureOnly    // 100% capture, no synthesis
    case captureHeavy   // >70% capture
    case balanced       // 30-70% capture
    case synthesisHeavy // <30% capture
}

// MARK: - Reflection Mode

/// Current mode in the capture-first flow
enum ReflectionMode: String, Codable {
    case capture   // Recording observations
    case synthesis // Finding meaning
}

// MARK: - Developmental Stage

/// User's current stage in their reflective practice
enum DevelopmentalStage: String, Codable {
    case emerging    // New to reflection, needs more guidance
    case developing  // Building skills, moderate guidance
    case established // Comfortable, minimal guidance
    case integrating // Advanced, may mentor others
}

// MARK: - Reflection Tier

/// Temporal scale of the reflection
enum ReflectionTier: String, Codable {
    case daily    // Day-to-day observations
    case weekly   // Weekly patterns and themes
    case monthly  // Monthly synthesis
    case seasonal // Quarterly/seasonal review
    case annual   // Yearly reflection
}

// MARK: - Note Trigger

/// Events that can trigger design notes to appear
enum NoteTrigger: String, Codable {
    case firstDailyEntry
    case firstPureCapture
    case firstSynthesis
    case modeSwitch
    case weeklyReviewAvailable
    case themeEmergence
}

// MARK: - Prompt Type

/// Types of prompts in the prompt library
enum PromptType: String, Codable {
    case orientation   // Initial grounding prompt
    case capture       // Observation prompts
    case synthesis     // Meaning-making prompts
    case transition    // Mode transition prompts
}
