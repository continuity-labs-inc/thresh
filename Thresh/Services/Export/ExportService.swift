import Foundation
import SwiftData

// MARK: - Export Data Models

struct ExportData: Codable {
    let exportDate: Date
    let appVersion: String
    let reflections: [ReflectionExport]
    let stories: [StoryExport]
    let ideas: [IdeaExport]
    let questions: [QuestionExport]
}

struct ReflectionExport: Codable {
    let id: UUID
    let captureContent: String
    let reflectionContent: String?
    let synthesisContent: String?
    let tier: String
    let focusType: String?
    let marinating: Bool
    let tags: [String]
    let themes: [String]
    let createdAt: Date
    let updatedAt: Date
}

struct StoryExport: Codable {
    let id: UUID
    let title: String
    let content: String
    let tags: [String]
    let linkedReflectionIds: [UUID]
    let createdAt: Date
    let updatedAt: Date
}

struct IdeaExport: Codable {
    let id: UUID
    let title: String
    let details: String
    let category: String?
    let tags: [String]
    let linkedReflectionIds: [UUID]
    let createdAt: Date
    let updatedAt: Date
}

struct QuestionExport: Codable {
    let id: UUID
    let text: String
    let context: String?
    let source: String
    let isAnswered: Bool
    let answer: String?
    let linkedReflectionIds: [UUID]
    let createdAt: Date
    let updatedAt: Date
}

// MARK: - Export Service

class ExportService {
    static let shared = ExportService()

    private init() {}

    func exportAllData(
        reflections: [Reflection],
        stories: [Story],
        ideas: [Idea],
        questions: [Question]
    ) -> Data? {
        let export = ExportData(
            exportDate: Date(),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
            reflections: reflections.filter { $0.deletedAt == nil }.map { r in
                ReflectionExport(
                    id: r.id,
                    captureContent: r.captureContent,
                    reflectionContent: r.reflectionContent,
                    synthesisContent: r.synthesisContent,
                    tier: r.tier.rawValue,
                    focusType: r.focusType?.rawValue,
                    marinating: r.marinating,
                    tags: r.tags,
                    themes: r.themes,
                    createdAt: r.createdAt,
                    updatedAt: r.updatedAt
                )
            },
            stories: stories.filter { $0.deletedAt == nil }.map { s in
                StoryExport(
                    id: s.id,
                    title: s.title,
                    content: s.content,
                    tags: s.tags,
                    linkedReflectionIds: s.linkedReflectionIds,
                    createdAt: s.createdAt,
                    updatedAt: s.updatedAt
                )
            },
            ideas: ideas.filter { $0.deletedAt == nil }.map { i in
                IdeaExport(
                    id: i.id,
                    title: i.title,
                    details: i.details,
                    category: i.category,
                    tags: i.tags,
                    linkedReflectionIds: i.linkedReflectionIds,
                    createdAt: i.createdAt,
                    updatedAt: i.updatedAt
                )
            },
            questions: questions.filter { $0.deletedAt == nil }.map { q in
                QuestionExport(
                    id: q.id,
                    text: q.text,
                    context: q.context,
                    source: q.source.rawValue,
                    isAnswered: q.isAnswered,
                    answer: q.answer,
                    linkedReflectionIds: q.linkedReflectionIds,
                    createdAt: q.createdAt,
                    updatedAt: q.updatedAt
                )
            }
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        return try? encoder.encode(export)
    }

    func generateFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmmss"
        return "Thresh-Backup-\(formatter.string(from: Date())).json"
    }
}
