import Foundation
import SwiftData

@Model
final class Question {
    var id: UUID
    var text: String
    var context: String?
    var createdAt: Date
    var updatedAt: Date
    var isAnswered: Bool
    var answer: String?
    var linkedReflectionIds: [UUID]

    init(
        id: UUID = UUID(),
        text: String,
        context: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isAnswered: Bool = false,
        answer: String? = nil,
        linkedReflectionIds: [UUID] = []
    ) {
        self.id = id
        self.text = text
        self.context = context
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
