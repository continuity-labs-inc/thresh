import Foundation

/// A connection between reflections detected by AI or created by the user.
/// Represents meaningful relationships between captures.
struct Connection: Identifiable, Hashable, Sendable {
    /// Unique identifier for this connection
    let id: UUID

    /// The first reflection in the connection
    let sourceReflectionId: UUID

    /// The second reflection in the connection
    let targetReflectionId: UUID

    /// The type of connection detected
    let connectionType: ConnectionType

    /// Description of why these are connected
    let description: String

    /// Confidence score (0.0 to 1.0) for AI-detected connections
    let confidence: Double

    /// Whether this connection was created by the user or detected by AI
    let isUserCreated: Bool

    /// When this connection was detected or created
    let createdAt: Date

    init(
        id: UUID = UUID(),
        sourceReflectionId: UUID,
        targetReflectionId: UUID,
        connectionType: ConnectionType,
        description: String,
        confidence: Double = 1.0,
        isUserCreated: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.sourceReflectionId = sourceReflectionId
        self.targetReflectionId = targetReflectionId
        self.connectionType = connectionType
        self.description = description
        self.confidence = confidence
        self.isUserCreated = isUserCreated
        self.createdAt = createdAt
    }
}

/// Types of connections that can exist between reflections
enum ConnectionType: String, Codable, CaseIterable, Identifiable, Sendable {
    /// Shared theme or topic
    case thematic

    /// Temporal relationship (before/after)
    case temporal

    /// Causal relationship (one led to another)
    case causal

    /// Contrasting perspectives
    case contrasting

    /// Evolution of an idea
    case evolution

    /// Question and potential answer
    case questionAnswer

    /// Pattern repetition
    case pattern

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .thematic: return "Shared Theme"
        case .temporal: return "Timeline"
        case .causal: return "Cause & Effect"
        case .contrasting: return "Contrast"
        case .evolution: return "Evolution"
        case .questionAnswer: return "Q&A"
        case .pattern: return "Pattern"
        }
    }

    var systemImage: String {
        switch self {
        case .thematic: return "tag"
        case .temporal: return "clock"
        case .causal: return "arrow.right"
        case .contrasting: return "arrow.left.arrow.right"
        case .evolution: return "arrow.up.right"
        case .questionAnswer: return "bubble.left.and.bubble.right"
        case .pattern: return "repeat"
        }
    }

    var description: String {
        switch self {
        case .thematic: return "These reflections share common themes"
        case .temporal: return "These reflections are related in time"
        case .causal: return "One reflection led to another"
        case .contrasting: return "These reflections show different perspectives"
        case .evolution: return "An idea evolved between these reflections"
        case .questionAnswer: return "A question and its potential answer"
        case .pattern: return "A recurring pattern appears"
        }
    }
}
