import SwiftUI
import SwiftData

/// Adaptive root view that uses NavigationSplitView on iPad and NavigationStack on iPhone
struct AdaptiveRootView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Environment(DesignNotesService.self) private var designNotesService

    // iPad navigation state
    @State private var selectedSection: SidebarSection? = .reflections
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        if sizeClass == .regular {
            // iPad: NavigationSplitView with sidebar
            iPadLayout
        } else {
            // iPhone: Standard NavigationStack
            HomeScreen()
        }
    }

    // MARK: - iPad Layout

    private var iPadLayout: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selectedSection: $selectedSection)
        } detail: {
            detailView
        }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder
    private var detailView: some View {
        switch selectedSection {
        // Capture
        case .newReflection:
            NewReflectionScreen()
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
        case .newStory:
            NewStoryScreen()
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
        case .newIdea:
            NewIdeaScreen()
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
        case .newQuestion:
            NewQuestionScreen()
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)

        // Library
        case .reflections:
            ReflectionsListView()
        case .stories:
            StoriesListView()
        case .ideas:
            IdeasListView()
        case .questions:
            QuestionsListView()

        // Synthesize
        case .weekly:
            WeeklyReflectionScreen()
        case .quarterly:
            QuarterlyReflectionScreen()

        // Explore
        case .patterns:
            NavigationStack {
                PatternsScreen()
            }

        // Manage
        case .archive:
            NavigationStack {
                ArchiveScreen()
            }
        case .recentlyDeleted:
            NavigationStack {
                RecentlyDeletedScreen()
            }
        case .settings:
            NavigationStack {
                SettingsScreen()
            }

        case .none:
            ContentUnavailableView(
                "Select a section",
                systemImage: "sidebar.left",
                description: Text("Choose from the sidebar to get started")
            )
        }
    }
}

// MARK: - Sidebar Section Enum

enum SidebarSection: String, Identifiable, CaseIterable {
    // Capture
    case newReflection
    case newStory
    case newIdea
    case newQuestion

    // Library
    case reflections
    case stories
    case ideas
    case questions

    // Synthesize
    case weekly
    case quarterly

    // Explore
    case patterns

    // Manage
    case archive
    case recentlyDeleted
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newReflection: return "New Reflection"
        case .newStory: return "New Story"
        case .newIdea: return "New Idea"
        case .newQuestion: return "New Question"
        case .reflections: return "Reflections"
        case .stories: return "Stories"
        case .ideas: return "Ideas"
        case .questions: return "Questions"
        case .weekly: return "Weekly Synthesis"
        case .quarterly: return "Quarterly Review"
        case .patterns: return "Patterns"
        case .archive: return "Archive"
        case .recentlyDeleted: return "Recently Deleted"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .newReflection: return "camera.fill"
        case .newStory: return "book.fill"
        case .newIdea: return "lightbulb.fill"
        case .newQuestion: return "questionmark.circle.fill"
        case .reflections: return "doc.text"
        case .stories: return "book"
        case .ideas: return "lightbulb"
        case .questions: return "questionmark.circle"
        case .weekly: return "calendar.badge.clock"
        case .quarterly: return "calendar"
        case .patterns: return "sparkles"
        case .archive: return "archivebox"
        case .recentlyDeleted: return "trash"
        case .settings: return "gearshape"
        }
    }

    var color: Color {
        switch self {
        case .newReflection: return Color.thresh.capture
        case .newStory: return Color.thresh.story
        case .newIdea: return Color.thresh.idea
        case .newQuestion: return Color.thresh.question
        case .reflections: return Color.thresh.capture
        case .stories: return Color.thresh.story
        case .ideas: return Color.thresh.idea
        case .questions: return Color.thresh.question
        case .weekly, .quarterly: return Color.thresh.synthesis
        case .patterns: return Color.thresh.synthesis
        case .archive, .recentlyDeleted, .settings: return Color.thresh.textSecondary
        }
    }

    static var captureItems: [SidebarSection] {
        [.newReflection, .newStory, .newIdea, .newQuestion]
    }

    static var libraryItems: [SidebarSection] {
        [.reflections, .stories, .ideas, .questions]
    }

    static var synthesizeItems: [SidebarSection] {
        [.weekly, .quarterly]
    }

    static var exploreItems: [SidebarSection] {
        [.patterns]
    }

    static var manageItems: [SidebarSection] {
        [.archive, .recentlyDeleted, .settings]
    }
}

// MARK: - List Views for iPad (wrapping existing components)

struct ReflectionsListView: View {
    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]

    private var reflections: [Reflection] {
        allReflections.filter { $0.deletedAt == nil && !$0.isArchived }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(reflections) { reflection in
                    NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
                        ReflectionRowContent(reflection: reflection)
                    }
                }
            }
            .navigationTitle("Reflections")
            .listStyle(.plain)
            .overlay {
                if reflections.isEmpty {
                    ContentUnavailableView(
                        "No Reflections",
                        systemImage: "doc.text",
                        description: Text("Start capturing moments with New Reflection")
                    )
                }
            }
        }
    }
}

struct StoriesListView: View {
    @Query(sort: \Story.createdAt, order: .reverse) private var allStories: [Story]

    private var stories: [Story] {
        allStories.filter { $0.deletedAt == nil }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(stories) { story in
                    NavigationLink(destination: StoryDetailScreen(story: story)) {
                        StoryRowContent(story: story)
                    }
                }
            }
            .navigationTitle("Stories")
            .listStyle(.plain)
            .overlay {
                if stories.isEmpty {
                    ContentUnavailableView(
                        "No Stories",
                        systemImage: "book",
                        description: Text("Stories emerge from your reflections or can be created directly")
                    )
                }
            }
        }
    }
}

struct IdeasListView: View {
    @Query(sort: \Idea.createdAt, order: .reverse) private var allIdeas: [Idea]

    private var ideas: [Idea] {
        allIdeas.filter { $0.deletedAt == nil }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(ideas) { idea in
                    NavigationLink(destination: IdeaDetailScreen(idea: idea)) {
                        IdeaRowContent(idea: idea)
                    }
                }
            }
            .navigationTitle("Ideas")
            .listStyle(.plain)
            .overlay {
                if ideas.isEmpty {
                    ContentUnavailableView(
                        "No Ideas",
                        systemImage: "lightbulb",
                        description: Text("Ideas emerge from your reflections or can be created directly")
                    )
                }
            }
        }
    }
}

struct QuestionsListView: View {
    @Query(sort: \Question.createdAt, order: .reverse) private var allQuestions: [Question]

    private var questions: [Question] {
        allQuestions.filter { $0.deletedAt == nil }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(questions) { question in
                    NavigationLink(destination: QuestionDetailScreen(question: question)) {
                        QuestionRowContent(question: question)
                    }
                }
            }
            .navigationTitle("Questions")
            .listStyle(.plain)
            .overlay {
                if questions.isEmpty {
                    ContentUnavailableView(
                        "No Questions",
                        systemImage: "questionmark.circle",
                        description: Text("Questions emerge from your reflections or can be created directly")
                    )
                }
            }
        }
    }
}

// MARK: - Simplified Row Content (for List style)

struct ReflectionRowContent: View {
    let reflection: Reflection

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let number = reflection.reflectionNumber, number > 0 {
                    Text("#\(number)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.thresh.capture)
                }

                if reflection.marinating {
                    Image(systemName: "hand.raised.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }

                Spacer()

                Text(reflection.createdAt.relativeFormatted)
                    .font(.caption)
                    .foregroundStyle(Color.thresh.textSecondary)
            }

            Text(reflection.captureContent)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundStyle(Color.thresh.textPrimary)
        }
        .padding(.vertical, 4)
    }
}

struct StoryRowContent: View {
    let story: Story

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if story.source == .extractedFromReflection {
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.synthesis)
                }
                Spacer()
                Text(story.createdAt.relativeFormatted)
                    .font(.caption)
                    .foregroundStyle(Color.thresh.textSecondary)
            }

            Text(story.title)
                .font(.headline)
                .lineLimit(1)

            Text(story.content)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundStyle(Color.thresh.textSecondary)
        }
        .padding(.vertical, 4)
    }
}

struct IdeaRowContent: View {
    let idea: Idea

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if idea.source == .extractedFromReflection {
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.synthesis)
                }
                if let category = idea.category {
                    Text(category)
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.textSecondary)
                }
                Spacer()
                Text(idea.createdAt.relativeFormatted)
                    .font(.caption)
                    .foregroundStyle(Color.thresh.textSecondary)
            }

            Text(idea.title)
                .font(.headline)
                .lineLimit(1)

            Text(idea.details)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundStyle(Color.thresh.textSecondary)
        }
        .padding(.vertical, 4)
    }
}

struct QuestionRowContent: View {
    let question: Question

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if question.source == .extractedFromReflection {
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.synthesis)
                }
                if question.isAnswered {
                    Text("ANSWERED")
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.questionAnswered)
                }
                Spacer()
                Text(question.createdAt.relativeFormatted)
                    .font(.caption)
                    .foregroundStyle(Color.thresh.textSecondary)
            }

            Text(question.text)
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

#Preview("iPad") {
    AdaptiveRootView()
        .environment(AppState())
        .environment(DesignNotesService(modelContext: try! ModelContainer(for: Reflection.self).mainContext))
        .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self, ActiveHabit.self], inMemory: true)
}
