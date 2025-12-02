import Foundation
import SwiftData

/// A reflection entry capturing observations and optional interpretations
@Model
final class Reflection {
    // MARK: - Identity

    @Attribute(.unique)
    var id: UUID

    // MARK: - Timestamps

    var createdAt: Date
    var updatedAt: Date

    // MARK: - Classification

    var tier: ReflectionTier
    var focusType: FocusType?
    var entryType: EntryType

    // MARK: - Content

    /// The observation/capture content (REQUIRED)
    var captureContent: String

    /// The interpretation/synthesis content (OPTIONAL)
    var synthesisContent: String?

    // MARK: - Metadata

    /// Balance between capture and synthesis content
    var modeBalance: ModeBalance

    /// Extracted or assigned themes
    var themes: [String]

    /// Whether this reflection is "marinating" for later synthesis
    var marinating: Bool

    // MARK: - Relationships

    /// Questions extracted from this reflection
    @Relationship(deleteRule: .cascade)
    var extractedQuestions: [Question]?

    // MARK: - Initialization

    init(
        id: UUID,
        createdAt: Date,
        updatedAt: Date,
        tier: ReflectionTier,
        focusType: FocusType? = nil,
        captureContent: String,
        synthesisContent: String? = nil,
        entryType: EntryType,
        modeBalance: ModeBalance,
        themes: [String] = [],
        marinating: Bool = false
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
    }

    // MARK: - Computed Properties

    /// Whether this is a pure capture without synthesis
    var isPureCapture: Bool {
        entryType == .pureCapture
    }

    /// Whether this reflection has both capture and synthesis
    var isGrounded: Bool {
        entryType == .groundedReflection
    }

    /// Total content length
    var totalLength: Int {
        captureContent.count + (synthesisContent?.count ?? 0)
    }
}
