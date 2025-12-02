import SwiftUI
import SwiftData

/// The Weekly Reflection Screen implements the synthesis flow for weekly reviews.
/// Users can review captures from the past 7 days, add revision layers,
/// and create a synthesis that connects their experiences.
///
/// Mode: SYNTHESIS throughout (indicated by crystal ball emoji in design docs)
///
/// Key design principles:
/// - Interpretation is appropriate here—with temporal distance
/// - Grounding check: User should be able to point to captures supporting their synthesis
/// - Summary vs. Synthesis distinction: Generate new insight, don't just collect old ones
struct WeeklyReflectionScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var reflections: [Reflection]

    @State private var selectedReflections: Set<UUID> = []
    @State private var revisionLayers: [UUID: String] = [:]
    @State private var synthesisText = ""
    @State private var showConnectionSurfacer = false
    @State private var detectedConnections: [Connection] = []
    @State private var currentStep: SynthesisStep = .review

    /// The PromptLibrary for getting synthesis prompts
    private let promptLibrary = PromptLibrary.shared

    /// Daily reflections from the past 7 days, sorted chronologically
    var dailyReflections: [Reflection] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return reflections.filter {
            $0.tier == .daily && $0.createdAt >= weekAgo
        }.sorted { $0.createdAt < $1.createdAt }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Mode indicator - Always synthesis for weekly reflection
                ModeIndicator(mode: .synthesis)

                // Progress indicator
                StepIndicator(currentStep: currentStep)

                switch currentStep {
                case .review:
                    reviewView
                case .revise:
                    reviseView
                case .synthesize:
                    synthesizeView
                }
            }
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("Weekly Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showConnectionSurfacer) {
            ConnectionSurfacerView(connections: detectedConnections)
        }
        .onAppear {
            loadConnections()
            // Auto-select all reflections by default
            selectedReflections = Set(dailyReflections.map { $0.id })
        }
    }

    // MARK: - Review Step

    /// The review step where users see and select their captures from the week
    private var reviewView: some View {
        VStack(spacing: 20) {
            Text("Your captures from this week")
                .font(.headline)

            if dailyReflections.isEmpty {
                emptyWeekView
            } else {
                // List of captures with selection
                ForEach(dailyReflections) { reflection in
                    CaptureSelectionRow(
                        reflection: reflection,
                        isSelected: selectedReflections.contains(reflection.id),
                        onToggle: { toggleSelection(reflection.id) }
                    )
                }

                // Connection surfacer button
                if !detectedConnections.isEmpty {
                    Button(action: { showConnectionSurfacer = true }) {
                        HStack {
                            Image(systemName: "link")
                            Text("See \(detectedConnections.count) detected connections")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.vm.synthesis)
                    }
                    .padding(.top, 8)
                }

                // Selection summary
                if !selectedReflections.isEmpty {
                    Text("\(selectedReflections.count) of \(dailyReflections.count) captures selected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Continue button
                Button(action: { currentStep = .revise }) {
                    Text("Continue to Revision")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedReflections.isEmpty ? Color.gray : Color.vm.synthesis)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(selectedReflections.isEmpty)
                .padding(.top, 8)
            }
        }
    }

    // MARK: - Revise Step

    /// The revise step where users can add revision layers to captures
    private var reviseView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Add revision layers")
                    .font(.headline)
                Text("What do you see now that you didn't see then?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Revision layer explanation
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.vm.synthesis)
                    Text("Revision layers preserve your original capture while adding new perspective with distance.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color.vm.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            ForEach(dailyReflections.filter { selectedReflections.contains($0.id) }) { reflection in
                RevisionLayerCard(
                    reflection: reflection,
                    revisionText: Binding(
                        get: { revisionLayers[reflection.id] ?? "" },
                        set: { revisionLayers[reflection.id] = $0 }
                    )
                )
            }

            // Skip/Continue options
            HStack(spacing: 12) {
                Button(action: { currentStep = .synthesize }) {
                    Text("Skip Revision")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.vm.surface)
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: { currentStep = .synthesize }) {
                    Text("Continue to Synthesis")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.vm.synthesis)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    // MARK: - Synthesize Step

    /// The synthesize step where users create their weekly synthesis
    private var synthesizeView: some View {
        VStack(spacing: 20) {
            // Synthesis prompt
            PromptView(
                prompt: promptLibrary.getAggregationPrompt(tier: .weekly),
                mode: .synthesis
            )

            // Synthesis guidance
            VStack(alignment: .leading, spacing: 12) {
                Text("Before you write, consider:")
                    .font(.subheadline)
                    .fontWeight(.medium)

                SynthesisGuideItem(
                    icon: "link",
                    text: "What thread runs through these moments?"
                )
                SynthesisGuideItem(
                    icon: "questionmark.circle",
                    text: "What question is this week asking you?"
                )
                SynthesisGuideItem(
                    icon: "sparkles",
                    text: "What do you understand now that you didn't before?"
                )
            }
            .padding()
            .background(Color.vm.synthesis.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Summary vs Synthesis reminder
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(Color.vm.question)
                    Text("Remember: Synthesis, not Summary")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                Text("A summary collects what happened. A synthesis generates new understanding from what happened.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.vm.question.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Synthesis input
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Your synthesis")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("Don't summarize—generate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                TextEditor(text: $synthesisText)
                    .frame(minHeight: 200)
                    .padding(8)
                    .background(Color.vm.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.vm.synthesis.opacity(0.3), lineWidth: 1)
                    )

                // Character/word count
                HStack {
                    Spacer()
                    let wordCount = synthesisText.split(separator: " ").count
                    Text("\(wordCount) words")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            // Grounding check reminder
            if !synthesisText.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(Color.vm.idea)
                        Text("Grounding check")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    Text("Can you point to specific captures that support this synthesis?")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.vm.idea.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            // Save button
            Button(action: saveWeeklySynthesis) {
                Text("Save Weekly Reflection")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(synthesisText.isEmpty ? Color.gray : Color.vm.synthesis)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(synthesisText.isEmpty)
        }
    }

    // MARK: - Supporting Views

    /// View shown when there are no captures from the past week
    private var emptyWeekView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No captures this week")
                .font(.headline)

            Text("Weekly synthesis works best with daily captures to draw from. Start capturing your moments to build material for reflection.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            NavigationLink(destination: NewReflectionScreen()) {
                Text("Create a Capture")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.vm.capture)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }

    // MARK: - Actions

    /// Toggle selection of a reflection
    private func toggleSelection(_ id: UUID) {
        if selectedReflections.contains(id) {
            selectedReflections.remove(id)
        } else {
            selectedReflections.insert(id)
        }
    }

    /// Load AI-detected connections between reflections
    private func loadConnections() {
        let reflectionsToAnalyze = dailyReflections
        Task {
            detectedConnections = await AIService.shared.detectConnections(in: reflectionsToAnalyze)
        }
    }

    /// Save the weekly synthesis and any revision layers
    private func saveWeeklySynthesis() {
        // Save revision layers first
        for (reflectionId, layerText) in revisionLayers where !layerText.isEmpty {
            if let reflection = dailyReflections.first(where: { $0.id == reflectionId }) {
                let layer = RevisionLayer(
                    content: layerText,
                    revisionType: .reframing
                )
                reflection.revisionLayers.append(layer)
                reflection.updatedAt = Date()
            }
        }

        // Create weekly synthesis
        let synthesis = Reflection(
            captureContent: "", // No capture for synthesis entries
            synthesisContent: synthesisText,
            entryType: .synthesis,
            tier: .weekly,
            focusType: nil, // No focus type for synthesis entries
            modeBalance: .synthesisOnly,
            themes: [], // Could be extracted by AI in future
            marinating: false
        )

        // Link to source reflections
        synthesis.linkedReflections = dailyReflections.filter { selectedReflections.contains($0.id) }

        modelContext.insert(synthesis)
        dismiss()
    }
}

// MARK: - Capture Selection Row

/// A row displaying a capture with selection toggle
struct CaptureSelectionRow: View {
    let reflection: Reflection
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.vm.synthesis : .secondary)

                VStack(alignment: .leading, spacing: 4) {
                    // Date and focus type
                    HStack {
                        Text(reflection.createdAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let focusType = reflection.focusType {
                            Label(focusType.displayName, systemImage: focusType.systemImage)
                                .font(.caption2)
                                .foregroundStyle(focusTypeColor(focusType))
                        }
                    }

                    // Capture content preview
                    Text(reflection.captureContent)
                        .font(.subheadline)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)

                    // Show existing revision layers count
                    if !reflection.revisionLayers.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "layers.fill")
                                .font(.caption2)
                            Text("\(reflection.revisionLayers.count) revision layer(s)")
                                .font(.caption2)
                        }
                        .foregroundStyle(Color.vm.synthesis)
                    }
                }

                Spacer()
            }
            .padding()
            .background(isSelected ? Color.vm.synthesis.opacity(0.1) : Color.vm.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.vm.synthesis.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func focusTypeColor(_ type: FocusType) -> Color {
        switch type {
        case .story: return Color.vm.story
        case .idea: return Color.vm.idea
        case .question: return Color.vm.question
        }
    }
}

// MARK: - Revision Layer Card

/// A card for adding a revision layer to a capture
struct RevisionLayerCard: View {
    let reflection: Reflection
    @Binding var revisionText: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Original capture
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(reflection.createdAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let focusType = reflection.focusType {
                        Image(systemName: focusType.systemImage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(reflection.captureContent)
                    .font(.subheadline)
                    .lineLimit(isExpanded ? nil : 3)
            }

            // Existing revision layers
            if !reflection.revisionLayers.isEmpty {
                ForEach(reflection.revisionLayers) { layer in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.turn.down.right")
                                .font(.caption2)
                            Text("Added \(layer.addedAt.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption2)
                        }
                        .foregroundStyle(Color.vm.synthesis)

                        Text(layer.content)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.leading, 12)
                }
            }

            // Revision input
            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    Text("What do you see now?")
                        .font(.caption)
                        .foregroundStyle(Color.vm.synthesis)

                    TextField("Add revision layer...", text: $revisionText, axis: .vertical)
                        .lineLimit(3...6)
                        .padding(8)
                        .background(Color.vm.synthesis.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            // Toggle button
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Image(systemName: isExpanded ? "minus.circle" : "plus.circle")
                    Text(isExpanded ? "Collapse" : "Add revision layer")
                }
                .font(.caption)
                .foregroundStyle(Color.vm.synthesis)
            }
        }
        .padding()
        .background(Color.vm.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Previews

#Preview("Review Step") {
    NavigationStack {
        WeeklyReflectionScreen()
    }
    .modelContainer(for: Reflection.self, inMemory: true)
}

#Preview("Empty Week") {
    NavigationStack {
        WeeklyReflectionScreen()
    }
    .modelContainer(for: Reflection.self, inMemory: true)
}
