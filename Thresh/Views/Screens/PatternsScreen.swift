import SwiftUI
import SwiftData

struct PatternsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]
    @Query(sort: \Question.createdAt, order: .reverse) private var questions: [Question]
    @State private var connections: [Connection] = []
    @State private var showPatternsTooltip = true

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
        .background(Color.thresh.background)
        .navigationTitle("Patterns")
        .navigationBarTitleDisplayMode(.large)
        .task {
            connections = await AIService.shared.detectConnections(in: allReflections)
        }
        .featureTooltip(
            title: "Patterns",
            message: "This is where things connect. Items you're marinating, questions that emerged from your writing, and thematic connections between entries.",
            featureKey: "patterns_screen",
            isPresented: $showPatternsTooltip
        )
    }

    // MARK: - Holding Section

    private var holdingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Holding", systemImage: "hand.raised.fill")
                .font(.headline)
                .foregroundStyle(Color.thresh.synthesis)

            Text("Things you're sitting with")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)

            if marinatingReflections.isEmpty {
                Text("Nothing marinating. Long-press a reflection to hold it.")
                    .font(.subheadline)
                    .foregroundStyle(Color.thresh.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.thresh.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(marinatingReflections) { reflection in
                    NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(reflection.captureContent.prefix(100) + (reflection.captureContent.count > 100 ? "..." : ""))
                                .font(.subheadline)
                                .foregroundStyle(Color.thresh.textPrimary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)

                            Text(reflection.createdAt.relativeFormatted)
                                .font(.caption)
                                .foregroundStyle(Color.thresh.textTertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.thresh.surface)
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
                .foregroundStyle(Color.thresh.synthesis)

            Text("Patterns across your captures")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)

            if connections.isEmpty {
                Text("Connections will appear as you add more captures.")
                    .font(.subheadline)
                    .foregroundStyle(Color.thresh.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.thresh.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(connections) { connection in
                    connectionCard(for: connection)
                }
            }
        }
    }

    private func connectionCard(for connection: Connection) -> some View {
        let sourceReflection = allReflections.first { $0.id == connection.sourceReflectionId }
        let targetReflection = allReflections.first { $0.id == connection.targetReflectionId }

        return VStack(alignment: .leading, spacing: 12) {
            // Connection type header with confidence
            HStack(spacing: 6) {
                Image(systemName: connection.connectionType.systemImage)
                    .font(.caption)
                Text(connection.connectionType.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                ConfidenceIndicator(confidence: connection.confidence)
            }
            .foregroundStyle(Color.thresh.synthesis)

            // Source reflection snippet
            if let source = sourceReflection {
                VStack(alignment: .leading, spacing: 4) {
                    Text("From:")
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.textTertiary)
                    Text(source.captureContent.prefix(80) + (source.captureContent.count > 80 ? "..." : ""))
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)
                        .lineLimit(2)
                }
            }

            // Target reflection snippet
            if let target = targetReflection {
                VStack(alignment: .leading, spacing: 4) {
                    Text("To:")
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.textTertiary)
                    Text(target.captureContent.prefix(80) + (target.captureContent.count > 80 ? "..." : ""))
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)
                        .lineLimit(2)
                }
            }

            // Connection description
            Text(connection.description)
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textPrimary)
        }
        .padding()
        .background(Color.thresh.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Questions Section

    private var questionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Questions", systemImage: "questionmark.circle.fill")
                .font(.headline)
                .foregroundStyle(Color.thresh.question)

            Text("Questions you're exploring")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)

            if questions.isEmpty {
                Text("No questions yet")
                    .font(.subheadline)
                    .foregroundStyle(Color.thresh.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.thresh.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(questions) { question in
                    HStack(alignment: .top, spacing: 8) {
                        Text(question.text)
                            .font(.subheadline)
                            .foregroundStyle(Color.thresh.textPrimary)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if question.source == .extractedFromReflection {
                            Text("↗")
                                .font(.caption)
                                .foregroundStyle(Color.thresh.synthesis)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.thresh.surface)
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
