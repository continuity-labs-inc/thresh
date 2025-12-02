import Foundation
import SwiftData

@Model
final class Idea {
    var id: UUID
    var title: String
    var description: String
    var category: String?
    var createdAt: Date
    var updatedAt: Date
    var tags: [String]
    var linkedReflectionIds: [UUID]

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tags: [String] = [],
        linkedReflectionIds: [UUID] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.linkedReflectionIds = linkedReflectionIds
    }
}

// MARK: - Mock Data
extension Idea {
    static var mockData: [Idea] {
        [
            Idea(
                title: "Morning Journaling Routine",
                description: "Start each day with 10 minutes of free writing before checking any devices.",
                category: "Habits",
                createdAt: Date().addingTimeInterval(-14400)
            ),
            Idea(
                title: "Weekly Reflection Review",
                description: "Set aside time each Sunday to review the week's reflections and identify patterns.",
                category: "Self-improvement",
                createdAt: Date().addingTimeInterval(-432000)
            )
        ]
    }
}
