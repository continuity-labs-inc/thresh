import Foundation
import SwiftData

@Model
final class Story {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var tags: [String]
    var linkedReflectionIds: [UUID]

    // Soft delete support (photo-like deletion)
    var deletedAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tags: [String] = [],
        linkedReflectionIds: [UUID] = [],
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.linkedReflectionIds = linkedReflectionIds
        self.deletedAt = deletedAt
    }
}

// MARK: - Mock Data
extension Story {
    static var mockData: [Story] {
        [
            Story(
                title: "The Day Everything Changed",
                content: "It started like any other Tuesday morning, but by noon, I realized nothing would ever be quite the same...",
                createdAt: Date().addingTimeInterval(-7200)
            ),
            Story(
                title: "Finding My Voice",
                content: "For years I stayed silent in meetings, afraid my ideas weren't good enough. Then one day, I decided to speak up.",
                createdAt: Date().addingTimeInterval(-259200)
            )
        ]
    }
}
