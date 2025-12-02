import Foundation
import SwiftUI

/// Service for managing design notes that explain app philosophy
@Observable
final class DesignNotesService {
    // MARK: - Properties

    /// IDs of notes that have been seen
    private var seenNoteIds: Set<String>

    /// UserDefaults key for persistence
    private let seenNotesKey = "DesignNotesService.seenNoteIds"

    // MARK: - Initialization

    init() {
        if let savedIds = UserDefaults.standard.stringArray(forKey: seenNotesKey) {
            self.seenNoteIds = Set(savedIds)
        } else {
            self.seenNoteIds = []
        }
    }

    // MARK: - Public Methods

    /// Get a design note for a specific trigger
    func getNoteFor(trigger: NoteTrigger) -> DesignNote? {
        DesignNote.allNotes.first { $0.trigger == trigger }
    }

    /// Check if a note should be shown (hasn't been seen yet)
    func shouldShow(noteId: String) -> Bool {
        !seenNoteIds.contains(noteId)
    }

    /// Mark a note as seen
    func markSeen(noteId: String) {
        seenNoteIds.insert(noteId)
        saveSeenNotes()
    }

    /// Reset all seen notes (for testing or user preference)
    func resetAllNotes() {
        seenNoteIds.removeAll()
        saveSeenNotes()
    }

    /// Get all unseen notes
    func getUnseenNotes() -> [DesignNote] {
        DesignNote.allNotes.filter { !seenNoteIds.contains($0.id) }
    }

    // MARK: - Private Methods

    private func saveSeenNotes() {
        UserDefaults.standard.set(Array(seenNoteIds), forKey: seenNotesKey)
    }
}
