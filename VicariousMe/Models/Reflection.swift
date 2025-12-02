import Foundation
import SwiftData

// MARK: - Entry Type
enum EntryType: String, Codable, CaseIterable {
    case pureCapture = "pure_capture"
    case groundedReflection = "grounded_reflection"
    case synthesis = "synthesis"
}

// MARK: - Tier
enum ReflectionTier: String, Codable, CaseIterable {
    case core = "Core"
    case active = "Active"
    case archive = "Archive"
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
    var createdAt: Date
    var updatedAt: Date
    var tags: [String]
    var isArchived: Bool

    init(
        id: UUID = UUID(),
        captureContent: String,
        reflectionContent: String? = nil,
        synthesisContent: String? = nil,
        entryType: EntryType = .pureCapture,
        tier: ReflectionTier = .active,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tags: [String] = [],
        isArchived: Bool = false
    ) {
        self.id = id
        self.captureContent = captureContent
        self.reflectionContent = reflectionContent
        self.synthesisContent = synthesisContent
        self.entryType = entryType
        self.tier = tier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.isArchived = isArchived
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
