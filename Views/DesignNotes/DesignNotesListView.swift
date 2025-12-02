//
//  DesignNotesListView.swift
//  VicariousMe
//
//  A list view showing all design notes, organized by category.
//  Accessible from Settings.
//

import SwiftUI

// MARK: - DesignNotesListView

/// Main list view for browsing all design notes
struct DesignNotesListView: View {
    @State private var selectedCategory: NoteCategory?
    @State private var searchText = ""

    var body: some View {
        List {
            // Category filter (optional)
            if selectedCategory == nil {
                categorySections
            } else {
                filteredCategorySection
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Design Notes")
        .searchable(text: $searchText, prompt: "Search notes")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                categoryMenu
            }
        }
    }

    // MARK: - Category Sections

    private var categorySections: some View {
        ForEach(NoteCategory.allCases) { category in
            let notes = filteredNotes(for: category)
            if !notes.isEmpty {
                Section {
                    ForEach(notes) { note in
                        NavigationLink(destination: DesignNoteDetailView(note: note)) {
                            noteRow(note)
                        }
                    }
                } header: {
                    categoryHeader(category)
                }
            }
        }
    }

    private var filteredCategorySection: some View {
        Group {
            if let category = selectedCategory {
                Section {
                    ForEach(filteredNotes(for: category)) { note in
                        NavigationLink(destination: DesignNoteDetailView(note: note)) {
                            noteRow(note)
                        }
                    }
                } header: {
                    categoryHeader(category)
                }
            }
        }
    }

    // MARK: - Note Row

    private func noteRow(_ note: DesignNote) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(Color.vm.text)

            Text(note.brief)
                .font(.caption)
                .foregroundStyle(Color.vm.textSecondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }

    // MARK: - Category Header

    private func categoryHeader(_ category: NoteCategory) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(category.displayName)
                .font(.headline)

            Text(category.description)
                .font(.caption)
                .foregroundStyle(Color.vm.textSecondary)
        }
    }

    // MARK: - Category Menu

    private var categoryMenu: some View {
        Menu {
            Button {
                selectedCategory = nil
            } label: {
                HStack {
                    Text("All Categories")
                    if selectedCategory == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }

            Divider()

            ForEach(NoteCategory.allCases) { category in
                Button {
                    selectedCategory = category
                } label: {
                    HStack {
                        Text(category.displayName)
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }

    // MARK: - Filtering

    private func filteredNotes(for category: NoteCategory) -> [DesignNote] {
        let categoryNotes = DesignNotesService.allNotes.filter { $0.category == category }

        if searchText.isEmpty {
            return categoryNotes
        }

        return categoryNotes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.brief.localizedCaseInsensitiveContains(searchText) ||
            note.expanded.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DesignNotesListView()
    }
}
