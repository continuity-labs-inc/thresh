import SwiftUI
import SwiftData

/// Modal for reviewing AI-extracted stories, ideas, and questions from a reflection.
/// Users can select which items to keep or discard.
struct ExtractionReviewModal: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let extractionResult: ExtractionResult
    let sourceReflection: Reflection
    let onComplete: () -> Void

    // Track which items are selected (default: all selected)
    @State private var selectedStories: Set<UUID>
    @State private var selectedIdeas: Set<UUID>
    @State private var selectedQuestions: Set<UUID>
    @State private var isSaving = false
    @State private var showExtractionTooltip = true

    init(extractionResult: ExtractionResult, sourceReflection: Reflection, onComplete: @escaping () -> Void) {
        self.extractionResult = extractionResult
        self.sourceReflection = sourceReflection
        self.onComplete = onComplete

        // Initialize all items as selected
        _selectedStories = State(initialValue: Set(extractionResult.stories.map { $0.id }))
        _selectedIdeas = State(initialValue: Set(extractionResult.ideas.map { $0.id }))
        _selectedQuestions = State(initialValue: Set(extractionResult.questions.map { $0.id }))
    }

    private var totalSelected: Int {
        selectedStories.count + selectedIdeas.count + selectedQuestions.count
    }

    private var hasSelections: Bool {
        totalSelected > 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Stories section
                    if !extractionResult.stories.isEmpty {
                        extractionSection(
                            title: "Stories",
                            icon: "book.fill",
                            color: Color.thresh.story,
                            items: extractionResult.stories,
                            selectedIds: $selectedStories
                        )
                    }

                    // Ideas section
                    if !extractionResult.ideas.isEmpty {
                        extractionSection(
                            title: "Ideas",
                            icon: "lightbulb.fill",
                            color: Color.thresh.idea,
                            items: extractionResult.ideas,
                            selectedIds: $selectedIdeas
                        )
                    }

                    // Questions section
                    if !extractionResult.questions.isEmpty {
                        extractionSection(
                            title: "Questions",
                            icon: "questionmark.circle.fill",
                            color: Color.thresh.question,
                            items: extractionResult.questions,
                            selectedIds: $selectedQuestions
                        )
                    }

                    Spacer(minLength: 80)
                }
                .padding()
            }
            .background(Color.thresh.background)
            .navigationTitle("We noticed something")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Skip All") {
                        dismiss()
                        onComplete()
                    }
                    .foregroundStyle(Color.thresh.textSecondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
            .featureTooltip(
                title: "We Found Something",
                message: "We noticed stories, ideas, or questions in your reflection. Select the ones worth keeping — they'll be saved as separate entries linked back to the source.",
                featureKey: "extraction_review",
                isPresented: $showExtractionTooltip
            )
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: extractionResult.isEmpty ? "magnifyingglass" : "sparkles")
                .font(.largeTitle)
                .foregroundStyle(extractionResult.isEmpty ? Color.thresh.textSecondary : Color.thresh.synthesis)

            Text(extractionResult.isEmpty ? "Nothing Found" : "These emerged from your reflection")
                .font(.headline)
                .foregroundStyle(Color.thresh.textPrimary)

            Text(extractionResult.isEmpty
                 ? "We analyzed your reflection but didn't find distinct stories, ideas, or questions to extract. That's okay - not every reflection has extractable items."
                 : "Keep what resonates. Extracted items link back to this reflection.")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Extraction Section (Stories)

    private func extractionSection(
        title: String,
        icon: String,
        color: Color,
        items: [ExtractionResult.ExtractedStory],
        selectedIds: Binding<Set<UUID>>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)

            VStack(spacing: 8) {
                ForEach(items) { item in
                    ExtractionItemRow(
                        title: item.title,
                        content: item.content,
                        color: color,
                        isSelected: selectedIds.wrappedValue.contains(item.id),
                        onToggle: {
                            if selectedIds.wrappedValue.contains(item.id) {
                                selectedIds.wrappedValue.remove(item.id)
                            } else {
                                selectedIds.wrappedValue.insert(item.id)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Extraction Section (Ideas)

    private func extractionSection(
        title: String,
        icon: String,
        color: Color,
        items: [ExtractionResult.ExtractedIdea],
        selectedIds: Binding<Set<UUID>>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)

            VStack(spacing: 8) {
                ForEach(items) { item in
                    ExtractionItemRow(
                        title: item.title,
                        content: item.details,
                        color: color,
                        isSelected: selectedIds.wrappedValue.contains(item.id),
                        onToggle: {
                            if selectedIds.wrappedValue.contains(item.id) {
                                selectedIds.wrappedValue.remove(item.id)
                            } else {
                                selectedIds.wrappedValue.insert(item.id)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Extraction Section (Questions)

    private func extractionSection(
        title: String,
        icon: String,
        color: Color,
        items: [ExtractionResult.ExtractedQuestion],
        selectedIds: Binding<Set<UUID>>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)

            VStack(spacing: 8) {
                ForEach(items) { item in
                    ExtractionItemRow(
                        title: nil,
                        content: item.text,
                        color: color,
                        isSelected: selectedIds.wrappedValue.contains(item.id),
                        onToggle: {
                            if selectedIds.wrappedValue.contains(item.id) {
                                selectedIds.wrappedValue.remove(item.id)
                            } else {
                                selectedIds.wrappedValue.insert(item.id)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 16) {
                // Selection count
                Text("\(totalSelected) selected")
                    .font(.subheadline)
                    .foregroundStyle(Color.thresh.textSecondary)

                Spacer()

                // Save button
                Button {
                    saveSelectedItems()
                } label: {
                    HStack(spacing: 6) {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(hasSelections ? "Save Selected" : "Done")
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.thresh.synthesis)
                    .clipShape(Capsule())
                }
                .disabled(isSaving)
            }
            .padding()
            .background(Color.thresh.cardBackground)
        }
    }

    // MARK: - Save Logic

    private func saveSelectedItems() {
        isSaving = true

        // Save selected stories
        for item in extractionResult.stories where selectedStories.contains(item.id) {
            let story = Story(
                title: item.title,
                content: item.content,
                linkedReflectionIds: [sourceReflection.id],
                source: .extractedFromReflection
            )
            modelContext.insert(story)
        }

        // Save selected ideas
        for item in extractionResult.ideas where selectedIdeas.contains(item.id) {
            let idea = Idea(
                title: item.title,
                details: item.details,
                category: item.category,
                linkedReflectionIds: [sourceReflection.id],
                source: .extractedFromReflection
            )
            modelContext.insert(idea)
        }

        // Save selected questions
        for item in extractionResult.questions where selectedQuestions.contains(item.id) {
            let question = Question(
                text: item.text,
                context: item.context,
                source: .extractedFromReflection,
                linkedReflectionIds: [sourceReflection.id]
            )
            modelContext.insert(question)
        }

        // Save context
        do {
            try modelContext.save()
        } catch {
            // Handle save error silently
        }

        isSaving = false
        dismiss()
        onComplete()
    }
}

// MARK: - Extraction Item Row

struct ExtractionItemRow: View {
    let title: String?
    let content: String
    let color: Color
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {
                // Checkbox
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? color : Color.thresh.textTertiary)

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    if let title = title {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.thresh.textPrimary)
                    }

                    Text(content)
                        .font(.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                        .lineLimit(3)
                }

                Spacer()
            }
            .padding()
            .background(isSelected ? color.opacity(0.12) : Color.thresh.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? color.opacity(0.25) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ExtractionReviewModal(
        extractionResult: ExtractionResult(
            stories: [
                ExtractionResult.ExtractedStory(title: "Mom's Childhood", content: "Mom told me about her childhood in a way I'd never heard before.")
            ],
            ideas: [
                ExtractionResult.ExtractedIdea(title: "Living Memories", details: "Memories are living things - they change each time we share them.", category: nil)
            ],
            questions: [
                ExtractionResult.ExtractedQuestion(text: "Do I really know my mother, or just the version she shows me?", context: nil)
            ]
        ),
        sourceReflection: Reflection(captureContent: "Had coffee with Mom today..."),
        onComplete: {}
    )
    .modelContainer(for: [Story.self, Idea.self, Question.self], inMemory: true)
}
