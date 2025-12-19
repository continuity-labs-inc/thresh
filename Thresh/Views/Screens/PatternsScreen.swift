import SwiftUI
import SwiftData

struct PatternsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]
    @Query(sort: \Question.createdAt, order: .reverse) private var questions: [Question]
    @State private var connections: [Connection] = []
    @AppStorage("hasSeenPatternsIntro") private var hasSeenPatternsIntro = false
    @State private var showPatternsIntroSheet = false
    @State private var isRegenerating = false
    @State private var lastGenerated: Date?
    @State private var subscriptionService = SubscriptionService.shared
    @State private var showPaywall = false

    private var marinatingReflections: [Reflection] {
        allReflections.filter { $0.marinating && !$0.isArchived }
    }

    /// Deduplicated connections - removes self-connections and duplicate pairs
    private var uniqueConnections: [Connection] {
        var seen: Set<String> = []
        return connections.filter { conn in
            // Create canonical key (sorted IDs to handle both directions)
            let ids = [conn.sourceReflectionId.uuidString, conn.targetReflectionId.uuidString].sorted()
            let key = ids.joined(separator: "-")

            // Skip self-connections
            guard conn.sourceReflectionId != conn.targetReflectionId else { return false }

            // Skip duplicates
            guard !seen.contains(key) else { return false }
            seen.insert(key)
            return true
        }
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
            let reflectionData = allReflections.map { ReflectionData(from: $0) }
            connections = await ConnectionService.shared.getConnections(for: reflectionData)
            lastGenerated = await ConnectionService.shared.lastGeneratedDate()
        }
        .onAppear {
            if !hasSeenPatternsIntro {
                showPatternsIntroSheet = true
            }
        }
        .sheet(isPresented: $showPatternsIntroSheet) {
            PatternsIntroSheet(
                isPresented: $showPatternsIntroSheet,
                onDismiss: {
                    hasSeenPatternsIntro = true
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
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

    private var isProUser: Bool {
        subscriptionService.currentTier == .pro
    }

    private var connectionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Connections", systemImage: "link")
                    .font(.headline)
                    .foregroundStyle(Color.thresh.synthesis)

                ProFeatureBadge()

                Spacer()

                if isProUser {
                    Button {
                        regenerateConnections()
                    } label: {
                        HStack(spacing: 4) {
                            if isRegenerating {
                                ProgressView()
                                    .scaleEffect(0.7)
                            } else {
                                Image(systemName: "arrow.clockwise")
                            }
                            Text("Refresh")
                        }
                        .font(.caption)
                        .foregroundStyle(Color.thresh.synthesis)
                    }
                    .disabled(isRegenerating)
                }
            }

            if isProUser {
                if let lastGen = lastGenerated {
                    Text("Last updated: \(lastGen.relativeFormatted)")
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textTertiary)
                } else {
                    Text("Patterns across your captures")
                        .font(.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                }

                if uniqueConnections.isEmpty {
                    Text("Connections will appear as you add more captures.")
                        .font(.subheadline)
                        .foregroundStyle(Color.thresh.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.thresh.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ForEach(uniqueConnections) { connection in
                        connectionCard(for: connection)
                    }
                }
            } else {
                // Locked state for non-Pro users
                Button {
                    showPaywall = true
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundStyle(Color.thresh.textSecondary)

                        Text("AI-powered connections reveal patterns across your reflections")
                            .font(.subheadline)
                            .foregroundStyle(Color.thresh.textSecondary)
                            .multilineTextAlignment(.center)

                        Text("Upgrade to Pro")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.thresh.synthesis)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.thresh.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallScreen()
        }
    }

    private func regenerateConnections() {
        isRegenerating = true
        let reflectionData = allReflections.map { ReflectionData(from: $0) }
        Task {
            connections = await ConnectionService.shared.regenerateConnections(for: reflectionData)
            lastGenerated = await ConnectionService.shared.lastGeneratedDate()
            isRegenerating = false
        }
    }

    private func connectionCard(for connection: Connection) -> some View {
        let sourceReflection = allReflections.first { $0.id == connection.sourceReflectionId }
        let targetReflection = allReflections.first { $0.id == connection.targetReflectionId }

        // Use stored numbers if available, fallback to looking them up
        let sourceNum = connection.sourceReflectionNumber > 0
            ? connection.sourceReflectionNumber
            : (sourceReflection?.reflectionNumber ?? 0)
        let targetNum = connection.targetReflectionNumber > 0
            ? connection.targetReflectionNumber
            : (targetReflection?.reflectionNumber ?? 0)

        return VStack(alignment: .leading, spacing: 12) {
            // Connection type header with reflection numbers
            HStack(spacing: 6) {
                Image(systemName: connection.connectionType.systemImage)
                    .font(.caption)
                Text(connection.connectionType.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                Text("#\(sourceNum) ↔ #\(targetNum)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.thresh.textSecondary)
            }
            .foregroundStyle(Color.thresh.synthesis)

            // Source reflection snippet
            if let source = sourceReflection {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Reflection #\(sourceNum):")
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
                    Text("Reflection #\(targetNum):")
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

// MARK: - Patterns Intro Sheet

struct PatternsIntroSheet: View {
    @Binding var isPresented: Bool
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(Color.thresh.synthesis)
                .padding(.top, 24)

            // Title
            Text("Patterns")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.thresh.textPrimary)

            // Body
            Text("This is where things accumulate. Reflections you're holding onto, questions that emerged from your writing, and connections we noticed across entries.\n\nNothing here requires action. It's a space for what's still forming.")
                .font(.body)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()

            // Buttons
            VStack(spacing: 12) {
                Button {
                    onDismiss()
                    isPresented = false
                } label: {
                    Text("Got it")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.thresh.synthesis)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    onDismiss()
                    isPresented = false
                } label: {
                    Text("Don't show again")
                        .font(.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.thresh.background)
    }
}

#Preview {
    NavigationStack {
        PatternsScreen()
            .modelContainer(for: [Reflection.self, Question.self], inMemory: true)
    }
}

#Preview("Patterns Intro") {
    PatternsIntroSheet(isPresented: .constant(true), onDismiss: {})
}
