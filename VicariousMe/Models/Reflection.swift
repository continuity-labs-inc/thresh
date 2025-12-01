import Foundation
import SwiftData

// MARK: - Reflection Tier

enum ReflectionTier: String, Codable, CaseIterable {
    case daily
    case weekly
    case monthly
    case yearly

    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }
}

// MARK: - Focus Type

enum FocusType: String, Codable, CaseIterable {
    case work
    case personal
    case health
    case relationships
    case creativity
    case learning
    case general

    var displayName: String {
        rawValue.capitalized
    }

    var iconName: String {
        switch self {
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .health: return "heart.fill"
        case .relationships: return "person.2.fill"
        case .creativity: return "paintbrush.fill"
        case .learning: return "book.fill"
        case .general: return "circle.fill"
        }
    }
}

// MARK: - Entry Type

enum EntryType: String, Codable, CaseIterable {
    case pureCapture      // Quick capture, no processing
    case guided           // Full guided reflection flow
    case freeform         // User-initiated freeform entry
    case synthesized      // AI-synthesized reflection

    var displayName: String {
        switch self {
        case .pureCapture: return "Quick Capture"
        case .guided: return "Guided"
        case .freeform: return "Freeform"
        case .synthesized: return "Synthesized"
        }
    }
}

// MARK: - Mode Balance

enum ModeBalance: String, Codable, CaseIterable {
    case captureOnly      // Pure capture, no synthesis
    case captureHeavy     // Mostly capture, light synthesis
    case balanced         // Equal capture and synthesis
    case synthesisHeavy   // Light capture, deep synthesis
    case synthesisOnly    // Pure synthesis/reflection

    var displayName: String {
        switch self {
        case .captureOnly: return "Capture Only"
        case .captureHeavy: return "Capture Heavy"
        case .balanced: return "Balanced"
        case .synthesisHeavy: return "Synthesis Heavy"
        case .synthesisOnly: return "Synthesis Only"
        }
    }
}

// MARK: - Reflection Model

@Model
final class Reflection {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var tier: ReflectionTier
    var focusType: FocusType?
    var captureContent: String
    var synthesisContent: String?
    var entryType: EntryType
    var modeBalance: ModeBalance
    var themes: [String]
    var marinating: Bool

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tier: ReflectionTier = .daily,
        focusType: FocusType? = nil,
        captureContent: String,
        synthesisContent: String? = nil,
        entryType: EntryType = .freeform,
        modeBalance: ModeBalance = .balanced,
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
}
