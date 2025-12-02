import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse) private var reflections: [Reflection]
    @Query(sort: \Story.createdAt, order: .reverse) private var stories: [Story]
    @Query(sort: \Idea.createdAt, order: .reverse) private var ideas: [Idea]
    @Query(sort: \Question.createdAt, order: .reverse) private var questions: [Question]

    @State private var selectedTab: ContentTab = .reflections

    enum ContentTab: String, CaseIterable {
        case reflections, stories, ideas, questions
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    header

                    // Quick Actions
                    quickActionButtons

                    // Content Tabs
                    contentTabs

                    // Entry List
                    entryList
                }
                .padding()
            }
            .background(Color.vm.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if selectedTab == .reflections {
                        NavigationLink(destination: ArchiveScreen()) {
                            Image(systemName: "archivebox")
                        }
                    }
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Vicarious Me")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Capture moments, find patterns")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var quickActionButtons: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickActionButton(
                title: "New Reflection",
                icon: "camera.fill",
                color: Color.vm.capture,
                destination: NewReflectionScreen()
            )
            QuickActionButton(
                title: "New Story",
                icon: "book.fill",
                color: Color.vm.story,
                destination: NewStoryScreen()
            )
            QuickActionButton(
                title: "New Idea",
                icon: "lightbulb.fill",
                color: Color.vm.idea,
                destination: NewIdeaScreen()
            )
            QuickActionButton(
                title: "New Question",
                icon: "questionmark.circle.fill",
                color: Color.vm.question,
                destination: NewQuestionScreen()
            )
        }
    }

    private var contentTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ContentTab.allCases, id: \.self) { tab in
                    TabButton(
                        title: tab.rawValue.capitalized,
                        count: countFor(tab),
                        isSelected: selectedTab == tab,
                        action: { selectedTab = tab }
                    )
                }
            }
        }
    }

    private var entryList: some View {
        LazyVStack(spacing: 12) {
            switch selectedTab {
            case .reflections:
                ForEach(reflections.prefix(10)) { reflection in
                    ReflectionRow(reflection: reflection)
                }
            case .stories:
                ForEach(stories.prefix(10)) { story in
                    StoryRow(story: story)
                }
            case .ideas:
                ForEach(ideas.prefix(10)) { idea in
                    IdeaRow(idea: idea)
                }
            case .questions:
                ForEach(questions.prefix(10)) { question in
                    QuestionRow(question: question)
                }
            }

            if isEmpty(selectedTab) {
                EmptyStateView(tab: selectedTab)

                if selectedTab == .reflections {
                    NavigationLink(destination: NewReflectionScreen()) {
                        Label("Start your first capture", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.vm.capture)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    private func countFor(_ tab: ContentTab) -> Int {
        switch tab {
        case .reflections: return reflections.count
        case .stories: return stories.count
        case .ideas: return ideas.count
        case .questions: return questions.count
        }
    }

    private func isEmpty(_ tab: ContentTab) -> Bool {
        return countFor(tab) == 0
    }
}

// MARK: - Preview
#Preview {
    HomeScreen()
        .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self], inMemory: true)
}
