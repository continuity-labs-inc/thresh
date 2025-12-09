import SwiftUI
import SwiftData

struct SearchScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""

    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]
    @Query(sort: \Story.createdAt, order: .reverse) private var allStories: [Story]
    @Query(sort: \Idea.createdAt, order: .reverse) private var allIdeas: [Idea]
    @Query(sort: \Question.createdAt, order: .reverse) private var allQuestions: [Question]

    private var filteredReflections: [Reflection] {
        guard !searchText.isEmpty else { return [] }
        return allReflections.filter {
            $0.deletedAt == nil &&
            $0.captureContent.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var filteredStories: [Story] {
        guard !searchText.isEmpty else { return [] }
        return allStories.filter {
            $0.deletedAt == nil &&
            ($0.title.localizedCaseInsensitiveContains(searchText) ||
             $0.content.localizedCaseInsensitiveContains(searchText))
        }
    }

    private var filteredIdeas: [Idea] {
        guard !searchText.isEmpty else { return [] }
        return allIdeas.filter {
            $0.deletedAt == nil &&
            ($0.title.localizedCaseInsensitiveContains(searchText) ||
             $0.details.localizedCaseInsensitiveContains(searchText))
        }
    }

    private var filteredQuestions: [Question] {
        guard !searchText.isEmpty else { return [] }
        return allQuestions.filter {
            $0.deletedAt == nil &&
            $0.text.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var hasResults: Bool {
        !filteredReflections.isEmpty ||
        !filteredStories.isEmpty ||
        !filteredIdeas.isEmpty ||
        !filteredQuestions.isEmpty
    }

    var body: some View {
        List {
            if searchText.isEmpty {
                emptySearchState
            } else if !hasResults {
                noResultsState
            } else {
                if !filteredReflections.isEmpty {
                    Section("Reflections") {
                        ForEach(filteredReflections) { reflection in
                            NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
                                SearchResultRow(
                                    icon: "camera.fill",
                                    iconColor: Color.thresh.capture,
                                    title: String(reflection.captureContent.prefix(50)),
                                    subtitle: reflection.createdAt.relativeFormatted
                                )
                            }
                        }
                    }
                }

                if !filteredStories.isEmpty {
                    Section("Stories") {
                        ForEach(filteredStories) { story in
                            NavigationLink(destination: StoryDetailScreen(story: story)) {
                                SearchResultRow(
                                    icon: "book.fill",
                                    iconColor: Color.thresh.story,
                                    title: story.title,
                                    subtitle: story.createdAt.relativeFormatted
                                )
                            }
                        }
                    }
                }

                if !filteredIdeas.isEmpty {
                    Section("Ideas") {
                        ForEach(filteredIdeas) { idea in
                            NavigationLink(destination: IdeaDetailScreen(idea: idea)) {
                                SearchResultRow(
                                    icon: "lightbulb.fill",
                                    iconColor: Color.thresh.idea,
                                    title: idea.title,
                                    subtitle: idea.createdAt.relativeFormatted
                                )
                            }
                        }
                    }
                }

                if !filteredQuestions.isEmpty {
                    Section("Questions") {
                        ForEach(filteredQuestions) { question in
                            NavigationLink(destination: QuestionDetailScreen(question: question)) {
                                SearchResultRow(
                                    icon: "questionmark.circle.fill",
                                    iconColor: Color.thresh.question,
                                    title: question.text,
                                    subtitle: question.createdAt.relativeFormatted
                                )
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText, prompt: "Search reflections, stories, ideas...")
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var emptySearchState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(Color.thresh.textTertiary)

            Text("Search your entries")
                .font(.headline)
                .foregroundStyle(Color.thresh.textSecondary)

            Text("Find reflections, stories, ideas, and questions")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .listRowBackground(Color.clear)
    }

    private var noResultsState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(Color.thresh.textTertiary)

            Text("No results found")
                .font(.headline)
                .foregroundStyle(Color.thresh.textSecondary)

            Text("Try a different search term")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .listRowBackground(Color.clear)
    }
}

// MARK: - Search Result Row

struct SearchResultRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(iconColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(Color.thresh.textPrimary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.thresh.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        SearchScreen()
    }
    .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self], inMemory: true)
}
