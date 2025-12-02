//
//  ReflectionModels.swift
//  Vicarious Me
//
//  SwiftData models for the reflection app.
//
//  Design Philosophy:
//  - Observation (Capture) is the harder skill; interpretation (Synthesis) is easy
//  - Entries can be pure captures (no interpretation) and this is VALID
//  - The Two Modes (Capture/Synthesis) are distinct cognitive activities, not levels
//

import Foundation
import SwiftData

// MARK: - Enums

/// The temporal tier of a reflection, from daily captures to yearly synthesis
enum ReflectionTier: String, Codable, CaseIterable {
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
}

/// What the reflection focuses on
enum FocusType: String, Codable, CaseIterable {
    case event
    case person
    case relationship
    case place
    case object
    case routine
    case conversation
    case question
    case day
    case theme
    case other
}

/// The type of entry based on mode composition
enum EntryType: String, Codable, CaseIterable {
    /// 📷 Only observation, no interpretation
    case pureCapture
    /// 📷→🔮 Both modes, balanced
    case groundedReflection
    /// 🔮 Aggregation-level (weekly+)
    case synthesis
}

/// Balance between capture and synthesis modes
enum ModeBalance: String, Codable, CaseIterable {
    case captureOnly
    case captureHeavy
    case balanced
    case synthesisHeavy
    case synthesisOnly
}

/// Type of revision added to a reflection over time
enum RevisionType: String, Codable, CaseIterable {
    /// Changed interpretation
    case reframing
    /// Added detail
    case expansion
    /// Linked to other entries
    case connection
    /// Question that emerged later
    case newQuestion
}

/// Type of question extracted by AI
enum QuestionType: String, Codable, CaseIterable {
    /// Seeks answer
    case practical
    /// Seeks meaning
    case interpretive
    /// Seeks patterns
    case connective
    /// Opens new inquiry
    case generative
}

/// Quality level for capture assessment
enum QualityLevel: String, Codable, CaseIterable {
    case emerging
    case developing
    case strong
}

/// User's development stage in reflection practice
enum DevelopmentStage: String, Codable, CaseIterable {
    case beginner
    case developing
    case intermediate
    case advanced
    case expert
}

// MARK: - Supporting Structs

/// AI assessment of observation quality
struct CaptureQuality: Codable, Equatable {
    /// How specific and detailed the observation is
    var specificity: QualityLevel
    /// Presence of sensory details (sight, sound, smell, etc.)
    var sensoryDetail: QualityLevel
    /// Whether direct quotes or exact words are captured
    var verbatimPresence: Bool
    /// 0-1, higher = more behavioral vs emotional language
    var behavioralVsEmotional: Double
    /// AI suggestions for improving capture quality
    var suggestions: [String]

    init(
        specificity: QualityLevel = .emerging,
        sensoryDetail: QualityLevel = .emerging,
        verbatimPresence: Bool = false,
        behavioralVsEmotional: Double = 0.5,
        suggestions: [String] = []
    ) {
        self.specificity = specificity
        self.sensoryDetail = sensoryDetail
        self.verbatimPresence = verbatimPresence
        self.behavioralVsEmotional = min(1.0, max(0.0, behavioralVsEmotional))
        self.suggestions = suggestions
    }
}

// MARK: - Main Models

/// The main reflection entity - captures daily observations and optional synthesis
@Model
final class Reflection {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var tier: ReflectionTier
    var focusType: FocusType?

    // Two Modes content - kept separate!
    /// What happened (observation) - the harder skill
    var captureContent: String
    /// What it means (interpretation) - optional! Pure capture is valid
    var synthesisContent: String?

    var entryType: EntryType
    var modeBalance: ModeBalance

    @Relationship(deleteRule: .cascade, inverse: \RevisionLayer.reflection)
    var revisionLayers: [RevisionLayer]

    @Relationship(deleteRule: .cascade, inverse: \ExtractedQuestion.reflection)
    var extractedQuestions: [ExtractedQuestion]

    @Relationship
    var linkedReflections: [Reflection]

    var themes: [String]

    /// Stored as JSON data for the CaptureQuality struct
    var captureQualityData: Data?

    /// User chose to let it sit without interpreting
    var marinating: Bool

    /// Computed property to access CaptureQuality
    var captureQuality: CaptureQuality? {
        get {
            guard let data = captureQualityData else { return nil }
            return try? JSONDecoder().decode(CaptureQuality.self, from: data)
        }
        set {
            captureQualityData = try? JSONEncoder().encode(newValue)
        }
    }

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tier: ReflectionTier = .daily,
        focusType: FocusType? = nil,
        captureContent: String = "",
        synthesisContent: String? = nil,
        entryType: EntryType = .pureCapture,
        modeBalance: ModeBalance = .captureOnly,
        revisionLayers: [RevisionLayer] = [],
        extractedQuestions: [ExtractedQuestion] = [],
        linkedReflections: [Reflection] = [],
        themes: [String] = [],
        captureQuality: CaptureQuality? = nil,
        marinating: Bool = false
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tier = tier
        self.focusType = focusType
        self.captureContent = captureContent
        self.synthesisContent = synthesisContent
        self.entryType = entryType
        self.modeBalance = modeBalance
        self.revisionLayers = revisionLayers
        self.extractedQuestions = extractedQuestions
        self.linkedReflections = linkedReflections
        self.themes = themes
        self.captureQualityData = try? JSONEncoder().encode(captureQuality)
        self.marinating = marinating
    }
}

/// Added interpretation or content over time
@Model
final class RevisionLayer {
    @Attribute(.unique) var id: UUID
    var addedAt: Date
    var content: String
    var revisionType: RevisionType

    var reflection: Reflection?

    init(
        id: UUID = UUID(),
        addedAt: Date = Date(),
        content: String = "",
        revisionType: RevisionType = .expansion
    ) {
        self.id = id
        self.addedAt = addedAt
        self.content = content
        self.revisionType = revisionType
    }
}

/// AI-surfaced question from user's words
@Model
final class ExtractedQuestion {
    @Attribute(.unique) var id: UUID
    var content: String
    var extractedAt: Date
    var questionType: QuestionType
    /// User chose to keep this question
    var saved: Bool
    /// The user's text it came from
    var sourceText: String

    var reflection: Reflection?

    init(
        id: UUID = UUID(),
        content: String = "",
        extractedAt: Date = Date(),
        questionType: QuestionType = .interpretive,
        saved: Bool = false,
        sourceText: String = ""
    ) {
        self.id = id
        self.content = content
        self.extractedAt = extractedAt
        self.questionType = questionType
        self.saved = saved
        self.sourceText = sourceText
    }
}

/// A story captured by the user
@Model
final class Story {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var title: String?
    var content: String
    var tags: [String]

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        title: String? = nil,
        content: String = "",
        tags: [String] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.content = content
        self.tags = tags
    }
}

/// An idea captured by the user
@Model
final class Idea {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var content: String

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        content: String = ""
    ) {
        self.id = id
        self.createdAt = createdAt
        self.content = content
    }
}

/// User-saved question for ongoing inquiry
@Model
final class Question {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var content: String
    var sourceReflectionId: UUID?
    var answered: Bool

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        content: String = "",
        sourceReflectionId: UUID? = nil,
        answered: Bool = false
    ) {
        self.id = id
        self.createdAt = createdAt
        self.content = content
        self.sourceReflectionId = sourceReflectionId
        self.answered = answered
    }
}

/// Tracking which design notes the user has seen
@Model
final class DesignNoteStatus {
    @Attribute(.unique) var noteId: String
    var seen: Bool
    var seenAt: Date?
    var expanded: Bool

    init(
        noteId: String,
        seen: Bool = false,
        seenAt: Date? = nil,
        expanded: Bool = false
    ) {
        self.noteId = noteId
        self.seen = seen
        self.seenAt = seenAt
        self.expanded = expanded
    }
}

/// User profile for development tracking
@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var developmentStage: DevelopmentStage
    var totalReflections: Int
    var pureCaptureCount: Int
    var synthesisCount: Int
    var lastReflectionDate: Date?

    // Mode balance tracking
    /// Rolling average of capture quality scores
    var captureQualityTrend: [Double]
    /// How well synthesis links to captures (0-1)
    var interpretationGrounding: Double
    /// Does user distinguish modes? (0-1)
    var modeAwareness: Double

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        developmentStage: DevelopmentStage = .beginner,
        totalReflections: Int = 0,
        pureCaptureCount: Int = 0,
        synthesisCount: Int = 0,
        lastReflectionDate: Date? = nil,
        captureQualityTrend: [Double] = [],
        interpretationGrounding: Double = 0.0,
        modeAwareness: Double = 0.0
    ) {
        self.id = id
        self.createdAt = createdAt
        self.developmentStage = developmentStage
        self.totalReflections = totalReflections
        self.pureCaptureCount = pureCaptureCount
        self.synthesisCount = synthesisCount
        self.lastReflectionDate = lastReflectionDate
        self.captureQualityTrend = captureQualityTrend
        self.interpretationGrounding = min(1.0, max(0.0, interpretationGrounding))
        self.modeAwareness = min(1.0, max(0.0, modeAwareness))
    }
}

// MARK: - Model Container Configuration

/// All SwiftData models for the Vicarious Me app
enum ReflectionSchema {
    static var models: [any PersistentModel.Type] {
        [
            Reflection.self,
            RevisionLayer.self,
            ExtractedQuestion.self,
            Story.self,
            Idea.self,
            Question.self,
            DesignNoteStatus.self,
            UserProfile.self
        ]
    }

    /// Create a ModelContainer with all reflection models
    @MainActor
    static func createContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema(models)
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}

// MARK: - Test Data Factory

/// Factory for creating test data
enum TestDataFactory {

    /// Create a sample pure capture reflection (observation only)
    static func createPureCapture() -> Reflection {
        Reflection(
            tier: .daily,
            focusType: .conversation,
            captureContent: """
            Had coffee with Sarah at 10am at Blue Bottle. She ordered an oat milk latte, \
            I got a pour-over. She said "I've been thinking about leaving my job" while \
            looking down at her cup. Her voice was quieter than usual. She mentioned her \
            manager three times in 20 minutes. When I asked how she was sleeping, she laughed \
            and said "What's that?"
            """,
            synthesisContent: nil,
            entryType: .pureCapture,
            modeBalance: .captureOnly,
            themes: ["friendship", "work", "stress"],
            marinating: true
        )
    }

    /// Create a sample grounded reflection (both modes)
    static func createGroundedReflection() -> Reflection {
        Reflection(
            tier: .daily,
            focusType: .event,
            captureContent: """
            Team standup ran 45 minutes instead of 15. Marcus interrupted Lisa twice. \
            When she tried to explain the API issue, he said "Let's take this offline" \
            but then kept talking for 10 more minutes about his own project. Lisa's \
            shoulders dropped and she stopped making eye contact with the camera.
            """,
            synthesisContent: """
            This pattern of interruption has happened at least three times this month. \
            I'm noticing my own frustration rising, which makes me wonder if others \
            feel the same. The "take it offline" phrase seems to function as dismissal \
            rather than genuine scheduling.
            """,
            entryType: .groundedReflection,
            modeBalance: .balanced,
            themes: ["team dynamics", "communication", "power"],
            marinating: false
        )
    }

    /// Create a weekly synthesis reflection
    static func createWeeklySynthesis() -> Reflection {
        Reflection(
            tier: .weekly,
            focusType: .theme,
            captureContent: "5 daily entries this week covering: Monday meeting, Wednesday conversation with mom, Thursday deadline pressure, Friday celebration dinner, Sunday walk.",
            synthesisContent: """
            Patterns this week:
            - Energy peaks mid-week then crashes
            - Three separate entries mention "not being heard"
            - Physical sensations (tight shoulders, shallow breathing) appeared in 4/5 entries
            - The Friday celebration felt hollow - need to explore why

            Questions emerging:
            - Is "not being heard" a theme or am I projecting from one incident?
            - What would it look like to feel heard?
            """,
            entryType: .synthesis,
            modeBalance: .synthesisHeavy,
            themes: ["energy", "voice", "body awareness"],
            marinating: false
        )
    }

    /// Create a sample extracted question
    static func createExtractedQuestion(for reflection: Reflection) -> ExtractedQuestion {
        ExtractedQuestion(
            content: "What would it look like to feel truly heard?",
            questionType: .generative,
            saved: true,
            sourceText: "Three separate entries mention 'not being heard'"
        )
    }

    /// Create a sample revision layer
    static func createRevisionLayer() -> RevisionLayer {
        RevisionLayer(
            content: """
            Two weeks later: I realize the "not being heard" pattern connects to \
            my childhood dinner table. Mom would always redirect conversation to \
            my brother's achievements. This isn't just about work meetings.
            """,
            revisionType: .connection
        )
    }

    /// Create a sample story
    static func createStory() -> Story {
        Story(
            title: "The Time I Almost Quit",
            content: """
            It was March 2023, three weeks into the reorg. I'd written my resignation \
            letter and saved it as a draft. Then Sarah called and said four words that \
            changed everything: "It's not about you."
            """,
            tags: ["work", "turning point", "perspective"]
        )
    }

    /// Create a sample idea
    static func createIdea() -> Idea {
        Idea(
            content: "What if standup meetings were silent? Everyone types updates, we read for 5 minutes, then discuss only blockers."
        )
    }

    /// Create a sample user-saved question
    static func createQuestion() -> Question {
        Question(
            content: "What am I avoiding by staying busy?",
            answered: false
        )
    }

    /// Create a new user profile
    static func createUserProfile() -> UserProfile {
        UserProfile(
            developmentStage: .beginner,
            totalReflections: 0,
            pureCaptureCount: 0,
            synthesisCount: 0,
            captureQualityTrend: [],
            interpretationGrounding: 0.0,
            modeAwareness: 0.0
        )
    }

    /// Populate a ModelContext with sample data for testing
    @MainActor
    static func populateWithTestData(context: ModelContext) {
        // Create reflections
        let pureCapture = createPureCapture()
        let groundedReflection = createGroundedReflection()
        let weeklySynthesis = createWeeklySynthesis()

        context.insert(pureCapture)
        context.insert(groundedReflection)
        context.insert(weeklySynthesis)

        // Create and link extracted question
        let question = createExtractedQuestion(for: weeklySynthesis)
        question.reflection = weeklySynthesis
        context.insert(question)

        // Create and link revision layer
        let revision = createRevisionLayer()
        revision.reflection = groundedReflection
        context.insert(revision)

        // Create standalone entries
        context.insert(createStory())
        context.insert(createIdea())
        context.insert(createQuestion())
        context.insert(createUserProfile())

        // Link reflections
        weeklySynthesis.linkedReflections = [pureCapture, groundedReflection]
    }
}
