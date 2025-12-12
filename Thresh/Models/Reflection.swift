import Foundation
import SwiftData

// MARK: - Entry Type
enum EntryType: String, Codable, CaseIterable {
    case pureCapture = "pure_capture"
    case groundedReflection = "grounded_reflection"
    case synthesis = "synthesis"
}

// MARK: - Focus Type
enum FocusType: String, Codable, CaseIterable, Identifiable {
    case story = "story"
    case idea = "idea"
    case question = "question"
    
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
        case .story: return "book"
        case .idea: return "lightbulb"
        case .question: return "questionmark.circle"
        }
    }
}

// MARK: - Tier
enum ReflectionTier: String, Codable, CaseIterable {
    case core = "Core"
    case active = "Active"
    case archive = "Archive"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

// MARK: - Mode Balance
enum ModeBalance: String, Codable, CaseIterable {
    case captureOnly = "capture_only"
    case captureWithReflection = "capture_with_reflection"
    case synthesisOnly = "synthesis_only"
}

// MARK: - Reflection Model
@Model
final class Reflection {
    var id: UUID
    var captureContent: String
    var reflectionContent: String?
    var synthesisContent: String?
    var entryType: EntryType
    var tier: ReflectionTier
    var focusType: FocusType?
    var modeBalance: ModeBalance
    var createdAt: Date
    var updatedAt: Date
    var tags: [String]
    var themes: [String]
    var isArchived: Bool
    var marinating: Bool
    var reflectionNumber: Int

    // Soft delete support (photo-like deletion)
    var deletedAt: Date?

    // Revision layers for adding new perspective with temporal distance
    var revisionLayers: [RevisionLayer]
    
    // Linked reflections for synthesis entries
    var linkedReflections: [Reflection]

    init(
        id: UUID = UUID(),
        captureContent: String,
        reflectionContent: String? = nil,
        synthesisContent: String? = nil,
        entryType: EntryType = .pureCapture,
        tier: ReflectionTier = .active,
        focusType: FocusType? = nil,
        modeBalance: ModeBalance = .captureOnly,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tags: [String] = [],
        themes: [String] = [],
        isArchived: Bool = false,
        marinating: Bool = false,
        reflectionNumber: Int = 0,
        deletedAt: Date? = nil,
        revisionLayers: [RevisionLayer] = [],
        linkedReflections: [Reflection] = []
    ) {
        self.id = id
        self.captureContent = captureContent
        self.reflectionContent = reflectionContent
        self.synthesisContent = synthesisContent
        self.entryType = entryType
        self.tier = tier
        self.focusType = focusType
        self.modeBalance = modeBalance
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.themes = themes
        self.isArchived = isArchived
        self.marinating = marinating
        self.reflectionNumber = reflectionNumber
        self.deletedAt = deletedAt
        self.revisionLayers = revisionLayers
        self.linkedReflections = linkedReflections
    }
}

// MARK: - Mock Data
extension Reflection {
    static var mockData: [Reflection] {
        [
            Reflection(
                captureContent: "Today I noticed how the morning light changes everything. The way it filters through the window creates patterns I never paid attention to before.",
                entryType: .pureCapture,
                tier: .active,
                createdAt: Date().addingTimeInterval(-3600)
            ),
            Reflection(
                captureContent: "Feeling overwhelmed with work deadlines.",
                reflectionContent: "When I dig deeper, I realize the overwhelm isn't about the work itself but about my fear of not meeting expectations.",
                entryType: .groundedReflection,
                tier: .core,
                createdAt: Date().addingTimeInterval(-86400)
            ),
            Reflection(
                captureContent: "Had an interesting conversation with a stranger at the coffee shop.",
                reflectionContent: "These random connections remind me how much we all share similar struggles.",
                synthesisContent: "Pattern: I find meaning in unexpected human connections. This links to my value of authentic relationships.",
                entryType: .synthesis,
                tier: .core,
                createdAt: Date().addingTimeInterval(-172800)
            )
        ]
    }
}
