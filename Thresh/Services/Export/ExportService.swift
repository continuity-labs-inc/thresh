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

// MARK: - Import Result

struct ImportResult {
    let reflectionsImported: Int
    let storiesImported: Int
    let ideasImported: Int
    let questionsImported: Int
    let skipped: Int
}

// MARK: - Import Errors

enum ImportError: LocalizedError {
    case invalidJSON
    case missingRequiredField(String)
    case invalidTier(String)
    case invalidSource(String)

    var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "The file does not contain valid JSON data"
        case .missingRequiredField(let field):
            return "Missing required field: \(field)"
        case .invalidTier(let tier):
            return "Invalid reflection tier: \(tier)"
        case .invalidSource(let source):
            return "Invalid question source: \(source)"
        }
    }
}

// MARK: - Export Service

final class ExportService: @unchecked Sendable {
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

    // MARK: - Import

    func importData(from data: Data, into context: ModelContext) throws -> ImportResult {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let exportData: ExportData
        do {
            exportData = try decoder.decode(ExportData.self, from: data)
        } catch {
            throw ImportError.invalidJSON
        }

        var reflectionsImported = 0
        var storiesImported = 0
        var ideasImported = 0
        var questionsImported = 0
        var skipped = 0

        // Get existing IDs to avoid duplicates
        let existingReflectionIds = Set((try? context.fetch(FetchDescriptor<Reflection>()))?.map { $0.id } ?? [])
        let existingStoryIds = Set((try? context.fetch(FetchDescriptor<Story>()))?.map { $0.id } ?? [])
        let existingIdeaIds = Set((try? context.fetch(FetchDescriptor<Idea>()))?.map { $0.id } ?? [])
        let existingQuestionIds = Set((try? context.fetch(FetchDescriptor<Question>()))?.map { $0.id } ?? [])

        // Import reflections
        for r in exportData.reflections {
            if existingReflectionIds.contains(r.id) {
                skipped += 1
                continue
            }

            guard let tier = ReflectionTier(rawValue: r.tier) else {
                throw ImportError.invalidTier(r.tier)
            }

            let focusType: FocusType? = r.focusType.flatMap { FocusType(rawValue: $0) }

            let reflection = Reflection(
                id: r.id,
                captureContent: r.captureContent,
                reflectionContent: r.reflectionContent,
                synthesisContent: r.synthesisContent,
                entryType: r.synthesisContent != nil ? .synthesis : (r.reflectionContent != nil ? .groundedReflection : .pureCapture),
                tier: tier,
                focusType: focusType,
                modeBalance: r.synthesisContent != nil ? .synthesisOnly : (r.reflectionContent != nil ? .captureWithReflection : .captureOnly),
                createdAt: r.createdAt,
                updatedAt: r.updatedAt,
                tags: r.tags,
                themes: r.themes,
                isArchived: tier == .archive,
                marinating: r.marinating
            )
            context.insert(reflection)
            reflectionsImported += 1
        }

        // Import stories
        for s in exportData.stories {
            if existingStoryIds.contains(s.id) {
                skipped += 1
                continue
            }

            let story = Story(
                id: s.id,
                title: s.title,
                content: s.content,
                createdAt: s.createdAt,
                updatedAt: s.updatedAt,
                tags: s.tags,
                linkedReflectionIds: s.linkedReflectionIds
            )
            context.insert(story)
            storiesImported += 1
        }

        // Import ideas
        for i in exportData.ideas {
            if existingIdeaIds.contains(i.id) {
                skipped += 1
                continue
            }

            let idea = Idea(
                id: i.id,
                title: i.title,
                details: i.details,
                category: i.category,
                createdAt: i.createdAt,
                updatedAt: i.updatedAt,
                tags: i.tags,
                linkedReflectionIds: i.linkedReflectionIds
            )
            context.insert(idea)
            ideasImported += 1
        }

        // Import questions
        for q in exportData.questions {
            if existingQuestionIds.contains(q.id) {
                skipped += 1
                continue
            }

            guard let source = QuestionSource(rawValue: q.source) else {
                throw ImportError.invalidSource(q.source)
            }

            let question = Question(
                id: q.id,
                text: q.text,
                context: q.context,
                source: source,
                createdAt: q.createdAt,
                updatedAt: q.updatedAt,
                isAnswered: q.isAnswered,
                answer: q.answer,
                linkedReflectionIds: q.linkedReflectionIds
            )
            context.insert(question)
            questionsImported += 1
        }

        try context.save()

        return ImportResult(
            reflectionsImported: reflectionsImported,
            storiesImported: storiesImported,
            ideasImported: ideasImported,
            questionsImported: questionsImported,
            skipped: skipped
        )
    }
}
