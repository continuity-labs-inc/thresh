import Foundation

/// A revision layer added to a reflection after the fact.
/// Allows users to add new perspective with temporal distance.
struct RevisionLayer: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for this revision layer
    let id: UUID

    /// When this revision layer was added
    let addedAt: Date

    /// The content of the revision
    let content: String

    /// The type of revision being made
    let revisionType: RevisionType

    init(
        id: UUID = UUID(),
        addedAt: Date = Date(),
        content: String,
        revisionType: RevisionType = .annotation
    ) {
        self.id = id
        self.addedAt = addedAt
        self.content = content
        self.revisionType = revisionType
    }
}

/// The type of revision being made to a reflection
enum RevisionType: String, Codable, CaseIterable, Identifiable, Sendable {
    /// Simple annotation or note
    case annotation

    /// Reframing the original perspective
    case reframing

    /// Correction of facts or understanding
    case correction

    /// Extension with additional context
    case extension

    /// Connection to other reflections or insights
    case connection

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .annotation: return "Annotation"
        case .reframing: return "Reframing"
        case .correction: return "Correction"
        case .extension: return "Extension"
        case .connection: return "Connection"
        }
    }

    var systemImage: String {
        switch self {
        case .annotation: return "note.text"
        case .reframing: return "arrow.triangle.2.circlepath"
        case .correction: return "pencil.line"
        case .extension: return "plus.circle"
        case .connection: return "link"
        }
    }
}
