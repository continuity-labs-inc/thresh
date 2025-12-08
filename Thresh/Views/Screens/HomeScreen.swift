import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]
    @Query(sort: \Story.createdAt, order: .reverse) private var allStories: [Story]
    @Query(sort: \Idea.createdAt, order: .reverse) private var allIdeas: [Idea]
    @Query(sort: \Question.createdAt, order: .reverse) private var allQuestions: [Question]

    // Filter out deleted and archived items for display
    private var reflections: [Reflection] {
        allReflections.filter { $0.deletedAt == nil && !$0.isArchived }
    }

    private var stories: [Story] {
        allStories.filter { $0.deletedAt == nil }
    }

    private var ideas: [Idea] {
        allIdeas.filter { $0.deletedAt == nil }
    }

    private var questions: [Question] {
        allQuestions.filter { $0.deletedAt == nil }
    }

    @State private var selectedTab: ContentTab = .reflections
    @State private var showingAboutSheet = false

    enum ContentTab: String, CaseIterable {
        case reflections, stories, ideas, questions
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    quickActionButtons
                    buildNarrativeSection
                    contentTabs
                    entryList
                }
                .padding()
            }
            .background(Color.thresh.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: PatternsScreen()) {
                        Image(systemName: "sparkles")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        NavigationLink(destination: RecentlyDeletedScreen()) {
                            Image(systemName: "trash")
                        }
                        if selectedTab == .reflections {
                            NavigationLink(destination: ArchiveScreen()) {
                                Image(systemName: "archivebox")
                            }
                        }
                        Button {
                            showingAboutSheet = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAboutSheet) {
                AboutScreen()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Thresh")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.thresh.textPrimary)
            Text("Capture moments, find patterns")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var quickActionButtons: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickActionButton(
                title: "New Reflection",
                icon: "camera.fill",
                color: Color.thresh.capture,
                destination: NewReflectionScreen()
            )
            QuickActionButton(
                title: "New Story",
                icon: "book.fill",
                color: Color.thresh.story,
                destination: NewStoryScreen()
            )
            QuickActionButton(
                title: "New Idea",
                icon: "lightbulb.fill",
                color: Color.thresh.idea,
                destination: NewIdeaScreen()
            )
            QuickActionButton(
                title: "New Question",
                icon: "questionmark.circle.fill",
                color: Color.thresh.question,
                destination: NewQuestionScreen()
            )
        }
    }

    private var buildNarrativeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BUILD NARRATIVE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.thresh.textSecondary)
                
            NavigationLink(destination: WeeklyReflectionScreen()) {
                HStack {
                    Image(systemName: "book.pages")
                        .font(.title2)
                        .foregroundStyle(Color.thresh.synthesis)
                        .frame(width: 44)
                        
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Weekly Synthesis")
                            .font(.headline)
                            .foregroundStyle(Color.thresh.textPrimary)
                        Text("Review your captures and find patterns")
                            .font(.caption)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                        
                    Spacer()
                        
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(weeklyStatusText)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(hasEnoughCaptures ? Color.thresh.synthesis : Color.thresh.textSecondary)
                        Text("\(capturesThisWeek) captures")
                            .font(.caption2)
                            .foregroundStyle(Color.thresh.textTertiary)
                    }
                        
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textTertiary)
                }
                .padding()
                .background(Color.thresh.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var capturesThisWeek: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return reflections.filter { $0.createdAt >= weekAgo }.count
    }
    
    private var hasEnoughCaptures: Bool {
        capturesThisWeek >= 3
    }
    
    private var weeklyStatusText: String {
        if hasEnoughCaptures {
            return "Ready"
        } else {
            let needed = 3 - capturesThisWeek
            return "Need \(needed) more"
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
                            .background(Color.thresh.capture)
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

#Preview {
    HomeScreen()
        .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self], inMemory: true)
}
