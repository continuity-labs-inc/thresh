import Foundation

// MARK: - Connection Models

/// Represents a detected connection between journal entries
struct Connection: Identifiable, Codable, Equatable {
    let id: UUID
    let entryIds: [String]
    let type: ConnectionType
    let description: String

    init(id: UUID = UUID(), entryIds: [String], type: ConnectionType, description: String) {
        self.id = id
        self.entryIds = entryIds
        self.type = type
        self.description = description
    }
}

/// Types of connections that can be detected between entries
enum ConnectionType: String, Codable, CaseIterable {
    case theme
    case person
    case place
    case contrast
    case pattern

    var displayName: String {
        switch self {
        case .theme: return "Theme"
        case .person: return "Person"
        case .place: return "Place"
        case .contrast: return "Contrast"
        case .pattern: return "Pattern"
        }
    }

    var iconName: String {
        switch self {
        case .theme: return "lightbulb"
        case .person: return "person"
        case .place: return "location"
        case .contrast: return "arrow.left.arrow.right"
        case .pattern: return "repeat"
        }
    }
}

// MARK: - Capture Quality Models

/// Assessment of the observational quality of a journal entry
struct CaptureQuality: Codable, Equatable {
    let specificity: QualityLevel
    let sensoryDetail: QualityLevel
    let verbatimPresence: Bool
    let behavioralVsEmotional: Double
    let suggestions: [String]

    /// Returns the overall quality level based on component scores
    var overallLevel: QualityLevel {
        let scores = [specificity, sensoryDetail].map { level -> Int in
            switch level {
            case .emerging: return 1
            case .developing: return 2
            case .strong: return 3
            }
        }
        let average = Double(scores.reduce(0, +)) / Double(scores.count)

        if average >= 2.5 { return .strong }
        if average >= 1.5 { return .developing }
        return .emerging
    }

    /// Default quality for when assessment fails
    static let `default` = CaptureQuality(
        specificity: .emerging,
        sensoryDetail: .emerging,
        verbatimPresence: false,
        behavioralVsEmotional: 0.5,
        suggestions: []
    )
}

/// Quality levels for observational writing
enum QualityLevel: String, Codable, CaseIterable {
    case emerging
    case developing
    case strong

    var displayName: String {
        rawValue.capitalized
    }

    var color: String {
        switch self {
        case .emerging: return "orange"
        case .developing: return "yellow"
        case .strong: return "green"
        }
    }
}

// MARK: - API Response DTOs

/// DTO for parsing connection responses from GPT
struct ConnectionDTO: Codable {
    let entry_ids: [String]
    let connection_type: String
    let description: String
}

/// DTO for parsing capture quality responses from GPT
struct CaptureQualityDTO: Codable {
    let specificity: String
    let sensory_detail: String
    let verbatim_presence: Bool
    let behavioral_vs_emotional: Double
    let suggestions: [String]
}

/// DTO for parsing GPT API responses
struct GPTResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message
    }

    struct Message: Codable {
        let content: String
    }
}

// MARK: - Reflection Model (Placeholder for integration)

/// Represents a journal reflection entry
/// This is a placeholder that should be replaced with the actual model from the data layer
struct Reflection: Identifiable, Codable {
    let id: UUID
    let captureContent: String
    let createdAt: Date

    init(id: UUID = UUID(), captureContent: String, createdAt: Date = Date()) {
        self.id = id
        self.captureContent = captureContent
        self.createdAt = createdAt
    }
}
