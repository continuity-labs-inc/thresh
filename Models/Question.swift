import Foundation
import SwiftData

/// A question extracted from a reflection for future exploration
@Model
final class Question {
    // MARK: - Identity

    @Attribute(.unique)
    var id: UUID

    // MARK: - Timestamps

    var createdAt: Date
    var answeredAt: Date?

    // MARK: - Content

    /// The question text
    var content: String

    /// Whether this question has been addressed
    var answered: Bool

    /// Optional answer or resolution
    var answer: String?

    // MARK: - Relationships

    /// The reflection this question was extracted from
    @Relationship(inverse: \Reflection.extractedQuestions)
    var sourceReflection: Reflection?

    // MARK: - Initialization

    init(
        id: UUID,
        createdAt: Date,
        content: String,
        answered: Bool = false,
        answer: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.content = content
        self.answered = answered
        self.answer = answer
    }

    // MARK: - Methods

    /// Mark the question as answered
    func markAnswered(with answer: String? = nil) {
        self.answered = true
        self.answeredAt = Date()
        self.answer = answer
    }
}
