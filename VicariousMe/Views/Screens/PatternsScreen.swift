import SwiftUI
import SwiftData

struct PatternsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]
    @Query(sort: \Question.createdAt, order: .reverse) private var allQuestions: [Question]

    @State private var isMarinatingExpanded = true
    @State private var isConnectionsExpanded = true
    @State private var isQuestionsExpanded = true

    private var marinatingReflections: [Reflection] {
        allReflections.filter { $0.marinating && !$0.isArchived }
    }

    private var extractedQuestions: [Question] {
        allQuestions.filter { $0.source == .extractedFromReflection }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    marinatingSection
                    connectionsSection
                    questionsSection
                }
                .padding()
            }
            .background(Color.vm.background)
            .navigationTitle("Patterns")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Marinating Section

    private var marinatingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                title: "Marinating",
                icon: "clock.badge.questionmark",
                color: Color.vm.synthesis,
                count: marinatingReflections.count,
                isExpanded: $isMarinatingExpanded
            )

            if isMarinatingExpanded {
                if marinatingReflections.isEmpty {
                    emptyState(
                        icon: "clock",
                        title: "Nothing Marinating",
                        message: "Flag reflections to marinate when you want to revisit them with fresh perspective"
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(marinatingReflections) { reflection in
                            MarinatingReflectionRow(reflection: reflection)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Connections Section

    private var connectionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                title: "Connections",
                icon: "link",
                color: Color.vm.reflect,
                count: 0,
                isExpanded: $isConnectionsExpanded
            )

            if isConnectionsExpanded {
                emptyState(
                    icon: "sparkles",
                    title: "No Connections Yet",
                    message: "AI-detected connections between your reflections will appear here as patterns emerge"
                )
            }
        }
    }

    // MARK: - Questions Section

    private var questionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                title: "Questions",
                icon: "questionmark.bubble",
                color: Color.vm.question,
                count: extractedQuestions.count,
                isExpanded: $isQuestionsExpanded
            )

            if isQuestionsExpanded {
                if extractedQuestions.isEmpty {
                    emptyState(
                        icon: "questionmark.circle",
                        title: "No Extracted Questions",
                        message: "Questions discovered within your reflections will surface here for deeper exploration"
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(extractedQuestions) { question in
                            ExtractedQuestionRow(question: question)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Section Header

    private func sectionHeader(
        title: String,
        icon: String,
        color: Color,
        count: Int,
        isExpanded: Binding<Bool>
    ) -> some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.wrappedValue.toggle() } }) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(color)

                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.vm.textSecondary)

                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.15))
                        .foregroundStyle(color)
                        .clipShape(Capsule())
                }

                Spacer()

                Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .foregroundStyle(Color.vm.textTertiary)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State

    private func emptyState(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(Color.vm.textTertiary)

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.vm.textSecondary)

            Text(message)
                .font(.caption)
                .foregroundStyle(Color.vm.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color.vm.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Marinating Reflection Row

private struct MarinatingReflectionRow: View {
    let reflection: Reflection

    var body: some View {
        NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.badge.questionmark")
                        Text("MARINATING")
                    }
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.vm.synthesis)

                    Spacer()

                    Text(reflection.createdAt.relativeFormatted)
                        .font(.caption)
                        .foregroundStyle(Color.vm.textSecondary)
                }

                Text(previewText)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(Color.vm.textPrimary)
            }
            .padding()
            .background(Color.vm.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var previewText: String {
        let content = reflection.captureContent
        if content.count > 100 {
            return String(content.prefix(100)) + "..."
        }
        return content
    }
}

// MARK: - Extracted Question Row

private struct ExtractedQuestionRow: View {
    let question: Question

    var body: some View {
        NavigationLink(destination: QuestionDetailScreen(question: question)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if question.source == .extractedFromReflection {
                        HStack(spacing: 2) {
                            Text("\u{2197}")
                            Text("Extracted")
                        }
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.vm.synthesis.opacity(0.15))
                        .foregroundStyle(Color.vm.synthesis)
                        .clipShape(Capsule())
                    }

                    Spacer()

                    Text(question.createdAt.relativeFormatted)
                        .font(.caption)
                        .foregroundStyle(Color.vm.textSecondary)
                }

                Text(question.text)
                    .font(.subheadline)
                    .lineLimit(3)
                    .foregroundStyle(Color.vm.textPrimary)

                if question.isAnswered {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Answered")
                    }
                    .font(.caption2)
                    .foregroundStyle(.green)
                }
            }
            .padding()
            .background(Color.vm.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PatternsScreen()
        .modelContainer(for: [Reflection.self, Question.self], inMemory: true)
}
