import Foundation
import SwiftData

/// The core model for all user reflections in Vicarious Me.
/// Reflections can be daily captures, weekly syntheses, monthly, or yearly reviews.
@Model
final class Reflection {
    /// Unique identifier for this reflection
    @Attribute(.unique) var id: UUID

    /// When this reflection was first created
    var createdAt: Date

    /// When this reflection was last modified
    var updatedAt: Date

    /// The temporal tier of this reflection (daily, weekly, monthly, yearly)
    var tier: ReflectionTier

    /// The type of focus for capture entries (story, idea, question)
    /// Nil for synthesis entries
    var focusType: FocusType?

    /// The raw capture content (user's original words)
    var captureContent: String

    /// The synthesis content (user's interpreted meaning)
    var synthesisContent: String?

    /// Whether this is a capture or synthesis entry
    var entryType: EntryType

    /// The balance between capture and synthesis in this entry
    var modeBalance: ModeBalance

    /// Themes detected or assigned to this reflection
    var themes: [String]

    /// Whether this reflection is "marinating" (not yet ready for synthesis)
    var marinating: Bool

    /// Revision layers added over time
    var revisionLayers: [RevisionLayer]

    /// Linked reflections (for synthesis entries, these are the source captures)
    @Relationship var linkedReflections: [Reflection]

    /// The parent reflection (if this was derived from another)
    @Relationship(inverse: \Reflection.linkedReflections) var parentReflection: Reflection?

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tier: ReflectionTier = .daily,
        focusType: FocusType? = nil,
        captureContent: String = "",
        synthesisContent: String? = nil,
        entryType: EntryType = .capture,
        modeBalance: ModeBalance = .captureOnly,
        themes: [String] = [],
        marinating: Bool = false,
        revisionLayers: [RevisionLayer] = [],
        linkedReflections: [Reflection] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tier = tier
        self.focusType = focusType
        self.captureContent = captureContent
        self.synthesisContent = synthesisContent
        self.entryType = entryType
        self.modeBalance = modeBalance
        self.themes = themes
        self.marinating = marinating
        self.revisionLayers = revisionLayers
        self.linkedReflections = linkedReflections
    }
}

// MARK: - Supporting Types

/// The temporal tier of a reflection
enum ReflectionTier: String, Codable, CaseIterable, Identifiable {
    /// Daily captures and immediate reflections
    case daily

    /// Weekly synthesis and review
    case weekly

    /// Monthly synthesis and patterns
    case monthly

    /// Yearly review and major insights
    case yearly

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }

    var emoji: String {
        switch self {
        case .daily: return "📷"
        case .weekly: return "🔮"
        case .monthly: return "🌙"
        case .yearly: return "⭐"
        }
    }
}

/// The type of focus for capture entries
enum FocusType: String, Codable, CaseIterable, Identifiable {
    /// A story or narrative from the user's experience
    case story

    /// An idea or insight the user wants to capture
    case idea

    /// A question the user is pondering
    case question

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .story: return "Story"
        case .idea: return "Idea"
        case .question: return "Question"
        }
    }

    var systemImage: String {
        switch self {
        case .story: return "book.pages"
        case .idea: return "lightbulb"
        case .question: return "questionmark.bubble"
        }
    }

    var emoji: String {
        switch self {
        case .story: return "📖"
        case .idea: return "💡"
        case .question: return "❓"
        }
    }
}

/// Whether an entry is primarily capture or synthesis
enum EntryType: String, Codable, CaseIterable, Identifiable {
    /// Raw capture of experience
    case capture

    /// Synthesis of multiple captures
    case synthesis

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .capture: return "Capture"
        case .synthesis: return "Synthesis"
        }
    }
}

/// The balance of capture vs synthesis content in an entry
enum ModeBalance: String, Codable, CaseIterable, Identifiable {
    /// Pure capture, no synthesis
    case captureOnly

    /// Primarily capture with some synthesis
    case captureHeavy

    /// Equal balance of capture and synthesis
    case balanced

    /// Primarily synthesis with some capture reference
    case synthesisHeavy

    /// Pure synthesis, referencing other captures
    case synthesisOnly

    var id: String { rawValue }
}
