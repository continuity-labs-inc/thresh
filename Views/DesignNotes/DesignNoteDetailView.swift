//
//  DesignNoteDetailView.swift
//  VicariousMe
//
//  Full detail view for a single design note.
//  Shows the complete explanation with nice formatting.
//

import SwiftUI

// MARK: - DesignNoteDetailView

/// Full-screen detail view for a design note
struct DesignNoteDetailView: View {
    let note: DesignNote

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with category badge
                header

                // Brief section
                briefSection

                // Divider
                Divider()
                    .padding(.vertical, 8)

                // Full explanation
                expandedSection

                // Metadata footer
                metadataFooter
            }
            .padding()
        }
        .background(Color.vm.surfaceSecondary)
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Image(systemName: "book.closed.fill")
                .font(.title2)
                .foregroundStyle(Color.vm.noteAccent)

            categoryBadge

            Spacer()
        }
    }

    private var categoryBadge: some View {
        Text(note.category.displayName)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.vm.noteAccent.opacity(0.15))
            )
            .foregroundStyle(Color.vm.noteAccent)
    }

    // MARK: - Brief Section

    private var briefSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("In Brief")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.vm.textSecondary)

            Text(note.brief)
                .font(.body)
                .foregroundStyle(Color.vm.text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vm.surface)
        )
    }

    // MARK: - Expanded Section

    private var expandedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("The Full Story")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.vm.textSecondary)

            // Parse and display the expanded text with formatting
            formattedExpandedText
        }
    }

    private var formattedExpandedText: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(paragraphs, id: \.self) { paragraph in
                if paragraph.hasPrefix("•") {
                    bulletPoint(paragraph)
                } else if paragraph.contains(":") && paragraph.first?.isNumber == true {
                    numberedPoint(paragraph)
                } else {
                    Text(paragraph)
                        .font(.body)
                        .foregroundStyle(Color.vm.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var paragraphs: [String] {
        note.expanded
            .components(separatedBy: "\n\n")
            .flatMap { block in
                // Split blocks that contain bullet points
                if block.contains("\n•") {
                    return block.components(separatedBy: "\n").filter { !$0.isEmpty }
                }
                return [block]
            }
            .filter { !$0.isEmpty }
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.vm.noteAccent)
                .frame(width: 6, height: 6)
                .offset(y: 7)

            Text(text.dropFirst(2)) // Remove "• "
                .font(.body)
                .foregroundStyle(Color.vm.text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.leading, 4)
    }

    private func numberedPoint(_ text: String) -> some View {
        let parts = text.split(separator: ".", maxSplits: 1)
        return HStack(alignment: .top, spacing: 8) {
            Text(String(parts[0]) + ".")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(Color.vm.noteAccent)
                .frame(width: 20, alignment: .trailing)

            if parts.count > 1 {
                Text(String(parts[1]).trimmingCharacters(in: .whitespaces))
                    .font(.body)
                    .foregroundStyle(Color.vm.text)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Metadata Footer

    private var metadataFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
                .padding(.top, 16)

            HStack(spacing: 16) {
                Label(note.category.displayName, systemImage: "folder")
                Label(note.trigger.displayName, systemImage: "bell")
            }
            .font(.caption)
            .foregroundStyle(Color.vm.textTertiary)
        }
    }
}

// MARK: - Related Notes Section (Optional Enhancement)

struct RelatedNotesSection: View {
    let currentNote: DesignNote
    let relatedNotes: [DesignNote]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Related Notes")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.vm.textSecondary)

            ForEach(relatedNotes.filter { $0.id != currentNote.id }.prefix(3)) { note in
                NavigationLink(destination: DesignNoteDetailView(note: note)) {
                    HStack {
                        Text(note.title)
                            .font(.subheadline)
                            .foregroundStyle(Color.vm.text)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textTertiary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.vm.surface)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DesignNoteDetailView(note: DesignNotesService.allNotes.first!)
    }
}

#Preview("AI Philosophy Note") {
    NavigationStack {
        DesignNoteDetailView(note: DesignNotesService.allNotes[1])
    }
}
