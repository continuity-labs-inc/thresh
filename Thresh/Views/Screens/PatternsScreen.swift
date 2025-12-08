import SwiftUI
import SwiftData

struct PatternsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]
    @Query(sort: \Question.createdAt, order: .reverse) private var questions: [Question]

    private var marinatingReflections: [Reflection] {
        allReflections.filter { $0.marinating && !$0.isArchived }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                holdingSection
                connectionsSection
                questionsSection
            }
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("Patterns")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Holding Section

    private var holdingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Holding", systemImage: "hand.raised.fill")
                .font(.headline)
                .foregroundStyle(Color.vm.synthesis)

            Text("Things you're sitting with")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)

            if marinatingReflections.isEmpty {
                Text("Nothing marinating. Long-press a reflection to hold it.")
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.vm.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(marinatingReflections) { reflection in
                    NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(reflection.captureContent.prefix(100) + (reflection.captureContent.count > 100 ? "..." : ""))
                                .font(.subheadline)
                                .foregroundStyle(Color.vm.textPrimary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)

                            Text(reflection.createdAt.relativeFormatted)
                                .font(.caption)
                                .foregroundStyle(Color.vm.textTertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Connections Section

    private var connectionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Connections", systemImage: "link")
                .font(.headline)
                .foregroundStyle(Color.vm.synthesis)

            Text("Patterns across your captures")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)

            Text("Connections will appear as you add more captures.")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textTertiary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.vm.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Questions Section

    private var questionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Questions", systemImage: "questionmark.circle.fill")
                .font(.headline)
                .foregroundStyle(Color.vm.question)

            Text("Questions you're exploring")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)

            if questions.isEmpty {
                Text("No questions yet")
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.vm.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(questions) { question in
                    HStack(alignment: .top, spacing: 8) {
                        Text(question.text)
                            .font(.subheadline)
                            .foregroundStyle(Color.vm.textPrimary)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if question.source == .extractedFromReflection {
                            Text("↗")
                                .font(.caption)
                                .foregroundStyle(Color.vm.synthesis)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.vm.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PatternsScreen()
            .modelContainer(for: [Reflection.self, Question.self], inMemory: true)
    }
}
