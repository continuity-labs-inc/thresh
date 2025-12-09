import SwiftUI
import SwiftData

struct ReflectionDetailScreen: View {
    @Bindable var reflection: Reflection
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Edit mode state
    @State private var isEditing = false
    @State private var editedCaptureContent = ""
    @State private var editedReflectionContent = ""
    @State private var editedSynthesisContent = ""

    // Delete confirmation
    @State private var showDeleteConfirmation = false

    // Copy feedback
    @State private var showCopiedToast = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with type and tier
                HStack {
                    EntryTypeBadge(type: reflection.entryType)
                    Spacer()
                    TierBadge(tier: reflection.tier)
                }

                // Capture content
                VStack(alignment: .leading, spacing: 8) {
                    Label("Capture", systemImage: "camera.fill")
                        .font(.caption)
                        .foregroundStyle(Color.thresh.capture)

                    if isEditing {
                        TextField("Capture content", text: $editedCaptureContent, axis: .vertical)
                            .font(.body)
                            .foregroundStyle(Color.thresh.textPrimary)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.thresh.surface)
                            )
                    } else {
                        Text(reflection.captureContent)
                            .font(.body)
                            .foregroundStyle(Color.thresh.textPrimary)
                            .textSelection(.enabled)
                            .contextMenu {
                                Button(action: { copyText(reflection.captureContent) }) {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                            }
                    }
                }

                // Reflection content (if present or editing)
                if isEditing || (reflection.reflectionContent != nil && !reflection.reflectionContent!.isEmpty) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Reflection", systemImage: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(Color.thresh.reflect)

                        if isEditing {
                            TextField("Reflection content (optional)", text: $editedReflectionContent, axis: .vertical)
                                .font(.body)
                                .foregroundStyle(Color.thresh.textPrimary)
                                .textFieldStyle(.plain)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.thresh.surface)
                                )
                        } else if let reflectionContent = reflection.reflectionContent, !reflectionContent.isEmpty {
                            Text(reflectionContent)
                                .font(.body)
                                .foregroundStyle(Color.thresh.textPrimary)
                                .textSelection(.enabled)
                                .contextMenu {
                                    Button(action: { copyText(reflectionContent) }) {
                                        Label("Copy", systemImage: "doc.on.doc")
                                    }
                                }
                        }
                    }
                }

                // Synthesis content (if present or editing)
                if isEditing || (reflection.synthesisContent != nil && !reflection.synthesisContent!.isEmpty) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Synthesis", systemImage: "sparkles")
                            .font(.caption)
                            .foregroundStyle(Color.thresh.synthesis)

                        if isEditing {
                            TextField("Synthesis content (optional)", text: $editedSynthesisContent, axis: .vertical)
                                .font(.body)
                                .foregroundStyle(Color.thresh.textPrimary)
                                .textFieldStyle(.plain)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.thresh.surface)
                                )
                        } else if let synthesisContent = reflection.synthesisContent, !synthesisContent.isEmpty {
                            Text(synthesisContent)
                                .font(.body)
                                .foregroundStyle(Color.thresh.textPrimary)
                                .textSelection(.enabled)
                                .contextMenu {
                                    Button(action: { copyText(synthesisContent) }) {
                                        Label("Copy", systemImage: "doc.on.doc")
                                    }
                                }
                        }
                    }
                }

                // Edit mode buttons
                if isEditing {
                    HStack(spacing: 16) {
                        Button(action: cancelEdit) {
                            Text("Cancel")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.thresh.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.thresh.surface)
                                )
                        }

                        Button(action: saveEdit) {
                            Text("Save Changes")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.thresh.capture)
                                )
                        }
                    }
                    .padding(.top, 8)
                }

                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created \(reflection.createdAt.relativeFormattedFull)")
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)

                    if reflection.updatedAt != reflection.createdAt {
                        Text("Updated \(reflection.updatedAt.relativeFormattedFull)")
                            .font(.caption)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.thresh.background)
        .navigationTitle("Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isEditing {
                    EmptyView()
                } else {
                    HStack(spacing: 16) {
                        Button {
                            reflection.marinating.toggle()
                        } label: {
                            Image(systemName: reflection.marinating ? "flame.fill" : "flame")
                                .foregroundStyle(reflection.marinating ? .orange : Color.thresh.textSecondary)
                        }

                        Menu {
                            Button(action: startEditing) {
                                Label("Edit", systemImage: "pencil")
                            }

                            Button(action: copyAllText) {
                                Label("Copy All", systemImage: "doc.on.doc")
                            }

                            Button(action: { toggleArchive() }) {
                                Label(
                                    reflection.isArchived ? "Unarchive" : "Archive",
                                    systemImage: reflection.isArchived ? "arrow.uturn.backward" : "archivebox"
                                )
                            }

                            Button {
                                reflection.marinating.toggle()
                            } label: {
                                Label(
                                    reflection.marinating ? "Stop Marinating" : "Marinate This",
                                    systemImage: reflection.marinating ? "flame.fill" : "flame"
                                )
                            }

                            Divider()

                            Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
        .alert("Delete Reflection?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: deleteReflection)
        } message: {
            Text("This reflection will be moved to Recently Deleted for 30 days.")
        }
        .overlay(alignment: .bottom) {
            if showCopiedToast {
                Text("Copied to clipboard")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.8))
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 20)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showCopiedToast)
    }

    private func toggleArchive() {
        reflection.isArchived.toggle()
        reflection.updatedAt = Date()
    }

    private func startEditing() {
        editedCaptureContent = reflection.captureContent
        editedReflectionContent = reflection.reflectionContent ?? ""
        editedSynthesisContent = reflection.synthesisContent ?? ""
        isEditing = true
    }

    private func cancelEdit() {
        isEditing = false
        editedCaptureContent = ""
        editedReflectionContent = ""
        editedSynthesisContent = ""
    }

    private func saveEdit() {
        let trimmedCapture = editedCaptureContent.trimmingCharacters(in: .whitespacesAndNewlines)

        // Capture content is required
        guard !trimmedCapture.isEmpty else { return }

        reflection.captureContent = trimmedCapture

        let trimmedReflection = editedReflectionContent.trimmingCharacters(in: .whitespacesAndNewlines)
        reflection.reflectionContent = trimmedReflection.isEmpty ? nil : trimmedReflection

        let trimmedSynthesis = editedSynthesisContent.trimmingCharacters(in: .whitespacesAndNewlines)
        reflection.synthesisContent = trimmedSynthesis.isEmpty ? nil : trimmedSynthesis

        reflection.updatedAt = Date()

        do {
            try modelContext.save()
        } catch {
            // Handle save error silently
        }

        isEditing = false
    }

    private func deleteReflection() {
        // Soft delete - set deletedAt timestamp
        reflection.deletedAt = Date()
        reflection.updatedAt = Date()

        do {
            try modelContext.save()
        } catch {
            // Handle save error silently
        }

        dismiss()
    }

    private func copyText(_ text: String) {
        UIPasteboard.general.string = text
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCopiedToast = false
        }
    }

    private func copyAllText() {
        var allText = reflection.captureContent

        if let reflectionContent = reflection.reflectionContent, !reflectionContent.isEmpty {
            allText += "\n\n" + reflectionContent
        }

        if let synthesisContent = reflection.synthesisContent, !synthesisContent.isEmpty {
            allText += "\n\n" + synthesisContent
        }

        copyText(allText)
    }
}

// MARK: - Tier Badge
struct TierBadge: View {
    let tier: ReflectionTier

    var body: some View {
        Text(tier.rawValue.uppercased())
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch tier {
        case .core: return Color.thresh.tierCore
        case .active: return Color.thresh.tierActive
        case .archive: return Color.thresh.tierArchive
        case .daily: return Color.thresh.capture
        case .weekly: return Color.thresh.synthesis
        case .monthly: return Color.thresh.story
        case .yearly: return Color.thresh.question
        }
    }
}

#Preview {
    NavigationStack {
        ReflectionDetailScreen(
            reflection: Reflection(
                captureContent: "Today I noticed how the morning light changes everything.",
                reflectionContent: "This makes me think about how small details often go unnoticed.",
                synthesisContent: "Pattern: Finding beauty in everyday moments connects to my core value of mindfulness.",
                entryType: .synthesis,
                tier: .core
            )
        )
    }
    .modelContainer(for: Reflection.self, inMemory: true)
}
