import Foundation
import SwiftData

// MARK: - Question Source
enum QuestionSource: String, Codable, CaseIterable {
    case userCreated = "user_created"
    case extractedFromReflection = "extracted_from_reflection"
    case suggestedByAI = "suggested_by_ai"

    var displayName: String {
        switch self {
        case .userCreated: return "Created"
        case .extractedFromReflection: return "Extracted"
        case .suggestedByAI: return "Suggested"
        }
    }
}

@Model
final class Question {
    var id: UUID
    var text: String
    var context: String?
    var source: QuestionSource
    var createdAt: Date
    var updatedAt: Date
    var isAnswered: Bool
    var answer: String?
    var linkedReflectionIds: [UUID]

    init(
        id: UUID = UUID(),
        text: String,
        context: String? = nil,
        source: QuestionSource = .userCreated,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isAnswered: Bool = false,
        answer: String? = nil,
        linkedReflectionIds: [UUID] = []
    ) {
        self.id = id
        self.text = text
        self.context = context
        self.source = source
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isAnswered = isAnswered
        self.answer = answer
        self.linkedReflectionIds = linkedReflectionIds
    }
}

// MARK: - Mock Data
extension Question {
    static var mockData: [Question] {
        [
            Question(
                text: "What would I do differently if I weren't afraid of failure?",
                context: "Came up during a reflection about career choices",
                createdAt: Date().addingTimeInterval(-21600)
            ),
            Question(
                text: "Why do I find it hard to celebrate my own successes?",
                createdAt: Date().addingTimeInterval(-604800)
            )
        ]
    }
}
