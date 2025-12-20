import Foundation
import SwiftData

@Model
final class UserProgress {
    var id: UUID
    var currentStage: Int                    // 1-4
    var captureCount: Int
    var phase2CompletionCount: Int
    var totalWordCount: Int
    var causalLanguageHits: Int
    var perspectiveMarkerHits: Int
    var crossReferenceCount: Int
    var domainDistribution: [String: Int]    // {"interpersonal": 12, "professional": 8}
    var categoryLastUsed: [String: Date]     // {"person": Date, "place": Date, ...}
    var stageAdvancedAt: [Int: Date]         // {2: Date, 3: Date, ...}
    var createdAt: Date
    var updatedAt: Date

    init() {
        self.id = UUID()
        self.currentStage = 1
        self.captureCount = 0
        self.phase2CompletionCount = 0
        self.totalWordCount = 0
        self.causalLanguageHits = 0
        self.perspectiveMarkerHits = 0
        self.crossReferenceCount = 0
        self.domainDistribution = [:]
        self.categoryLastUsed = [:]
        self.stageAdvancedAt = [:]
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
