//
//  DesignNotesService.swift
//  Thresh
//
//  Service for managing Design Notes - contextual explanations of WHY features
//  work the way they do. Notes appear at key moments, are dismissable, and
//  collected in Settings.
//

import Foundation
import SwiftData
import Observation

// MARK: - DesignNotesService

@Observable
final class DesignNotesService {

    // MARK: - Properties

    private let modelContext: ModelContext
    private var noteStatuses: [String: DesignNoteStatus] = [:]

    // MARK: - All Design Notes

    /// Complete collection of all design notes
    /// IMPORTANT: The "two_modes" note about observation being harder than interpretation
    /// should appear first and most prominently during onboarding.
    static let allNotes: [DesignNote] = [

        // ═══════════════════════════════════════════════════════════════════
        // FOUNDATION - Most Important First
        // ═══════════════════════════════════════════════════════════════════

        DesignNote(
            id: "two_modes",
            title: "Why Two Modes?",
            brief: "Reflection has two distinct activities: capturing what happened, and interpreting what it means. Most apps blur these together. We separate them because they're different skills—and observation is actually the harder one.",
            expanded: """
Think of a photographer. They do two things:
1. Take the photo: Capture the scene as it is
2. Develop the photo: Bring out meaning, adjust, interpret

Here's the surprising thing: taking a good photo is harder than developing it. Anyone can add a filter. Seeing clearly in the first place? That takes discipline.

The same is true for reflection. Interpretation is easy—we do it automatically, constantly, often without noticing. The moment something happens, we're already deciding what it means.

Observation is hard. Staying with what happened—the sensory details, the exact words, the sequence of events—without sliding into meaning requires real work.

Thresh trains both:
• Capture Mode: Recording what happened—sensory, specific, judgment-free
• Synthesis Mode: Finding what it means—interpretive, connective, questioning

Daily entries emphasize capture—the harder skill. Weekly and monthly reviews emphasize synthesis. Over time, you'll move between modes deliberately.
""",
            category: .foundation,
            trigger: .onboarding
        ),

        DesignNote(
            id: "ai_philosophy",
            title: "How AI Works Here",
            brief: "AI in Thresh extracts and surfaces—it never writes for you. When you see AI-generated questions or connections, these are drawn from your words, not invented. The reflection is yours; AI just helps you see what's already there.",
            expanded: """
Many apps use AI to generate content for users. We take a different approach.

AI here does three things:
1. Extracts questions that seem embedded in what you wrote
2. Surfaces connections between entries you might not remember
3. Provides feedback on your capture quality (not judgment—observation)

What AI never does:
• Write or rewrite your reflections
• Generate interpretations of your experience
• Tell you what your entries "mean"

Why? Because the cognitive work of reflection—the struggle to find words, the act of noticing, the process of making meaning—is where the benefit lives. If AI does that work, you lose the benefit.

Your reflections are yours. AI is a mirror, not an author.
""",
            category: .foundation,
            trigger: .firstQuestionExtraction
        ),

        DesignNote(
            id: "capture_first",
            title: "Why Capture First?",
            brief: "We ask you to describe before you interpret because meaning can change. The details you capture today might reveal different patterns next month. If you interpret too quickly, you lock in one meaning and lose others.",
            expanded: """
Here's a common experience: You write about something that happened, immediately decide what it "means," and move on. Three weeks later, you realize your interpretation was wrong—but you can't remember the actual details anymore. You only remember your interpretation.

This is why we ask you to capture first.

A good capture preserves the raw material:
• What you actually saw and heard
• What people actually said (verbatim if possible)
• The physical details of the scene
• The sequence of events

This raw material can be interpreted and reinterpreted over time. Your weekly synthesis might see one pattern. Your monthly review might see another. A year from now, you might see something entirely different.

If you skip straight to interpretation, you lose this flexibility. The capture is gone, replaced by your first (possibly wrong) meaning.
""",
            category: .foundation,
            trigger: .firstDailyEntry
        ),

        // ═══════════════════════════════════════════════════════════════════
        // DAILY PRACTICE
        // ═══════════════════════════════════════════════════════════════════

        DesignNote(
            id: "captures_complete",
            title: "Captures Are Complete",
            brief: "You saved a capture without interpretation. That's not incomplete—it's a deliberate choice. Some moments need to sit before meaning emerges. You can always add interpretation later, but you can't recover details you didn't capture.",
            expanded: """
There's a cultural bias toward "processing" experiences immediately. Something happens; you should understand it; you should learn the lesson.

But premature interpretation can be a trap:
• You lock in one meaning before others can emerge
• You lose the details in favor of the conclusion
• You miss what the moment might reveal later

Pure captures honor the reality that meaning takes time. Some things need to marinate. Some patterns only become visible when you have more data points.

When you save a capture without interpretation, you're saying: "I noticed this. I don't know what it means yet. I'm preserving it for future understanding."

That's not laziness or incompleteness. That's wisdom about how insight actually works.

The capture is the seed. The interpretation can grow later.
""",
            category: .dailyPractice,
            trigger: .firstPureCapture
        ),

        DesignNote(
            id: "time_since",
            title: "Why Show Time-Since?",
            brief: "The time since your last reflection isn't a guilt trip—it's useful data. Gaps reveal patterns: What makes you skip days? What brings you back? The gap itself becomes something worth reflecting on.",
            expanded: """
Many apps use streaks and guilt to drive engagement. We don't believe that works for reflection.

Instead, we show time-since as neutral information:
• "It's been 3 days since your last entry"
• No judgment, no lost streaks, no penalties

Why show it at all? Because the gap is data:
• What was happening during the gap?
• Why did you stop? Why did you return?
• Are there patterns to when you skip?

Often the gap itself becomes the most interesting thing to reflect on. "I haven't written in a week because..." can lead to important insights about your relationship with reflection, with self-awareness, with taking time for yourself.

We trust you to make meaning from the data. We just provide it.
""",
            category: .dailyPractice,
            trigger: .firstTimeSinceIndicator
        ),

        DesignNote(
            id: "capture_quality",
            title: "About Capture Quality",
            brief: "The capture quality indicator helps you develop observation skills. It's not grading your reflection—it's showing how sensory and specific your capture is. Think of it as feedback on a skill you're building, not judgment on your experience.",
            expanded: """
The quality indicator measures specific, learnable qualities:
• Sensory detail: Does it include what you saw, heard, felt?
• Specificity: Are there concrete details, not just abstractions?
• Observation vs. interpretation: Is it describing or judging?

This isn't about writing "well." It's about developing the skill of observation.

A "low quality" capture might be: "Had a frustrating meeting."
A "higher quality" capture might be: "In the 10am meeting, when Sarah interrupted me mid-sentence for the third time, I noticed my jaw tightening. The fluorescent light was buzzing. I kept clicking my pen."

The second isn't better writing—it's better observation. It preserves the raw material that can be interpreted later.

Over time, you'll naturally start capturing more sensory, specific details. The indicator just makes your progress visible.
""",
            category: .dailyPractice,
            trigger: .captureQualityFeedback
        ),

        // ═══════════════════════════════════════════════════════════════════
        // SYNTHESIS
        // ═══════════════════════════════════════════════════════════════════

        DesignNote(
            id: "synthesis_timing",
            title: "Why Weekly Synthesis?",
            brief: "Weekly synthesis isn't arbitrary—it's the sweet spot between too soon and too late. Daily would be premature (patterns need data points). Monthly would lose detail. Weekly gives you enough distance to see patterns while keeping the details fresh.",
            expanded: """
The timing of synthesis matters:

Too soon (daily):
• Not enough data points to see patterns
• You end up over-interpreting single events
• Meaning gets locked in before it can evolve

Too late (monthly):
• Details fade from memory
• You can no longer fact-check your interpretations
• Synthesis becomes more about memory than observation

Weekly hits the balance:
• Usually 3-7 entries to work with
• Details are still fresh enough to revisit
• Patterns have had time to emerge

During weekly synthesis, you look at your captures with fresh eyes. Something that seemed important on Tuesday might look different by Sunday. Connections emerge that weren't visible in the moment.

The weekly rhythm also creates a sustainable practice. Daily synthesis would be exhausting. Weekly gives you a natural checkpoint.
""",
            category: .synthesis,
            trigger: .firstSynthesisOffer
        ),

        DesignNote(
            id: "questions_extracted",
            title: "Where Questions Come From",
            brief: "The questions you see here aren't random prompts—they're extracted from what you wrote. We noticed places where you seemed to be asking something, even if you didn't phrase it as a question. These are your questions, surfaced back to you.",
            expanded: """
When you write, you often embed questions without realizing it:
• "I wonder if..." becomes a question
• "I'm not sure why..." becomes a question
• "The strange thing is..." often hides a question
• Contradictions and tensions suggest questions

We use AI to identify these implicit questions and surface them explicitly. This serves two purposes:

1. Awareness: You might not realize you're asking something until you see it reflected back

2. Continuity: Questions can persist across entries, creating threads of inquiry that develop over time

The questions aren't prompts we made up. They're your questions, found in your words. We're just making them visible so you can decide whether to pursue them.

Some questions resolve quickly. Others persist for months. Both are valuable.
""",
            category: .synthesis,
            trigger: .firstQuestionExtraction
        ),

        // ═══════════════════════════════════════════════════════════════════
        // PATTERNS
        // ═══════════════════════════════════════════════════════════════════

        DesignNote(
            id: "connections_surfaced",
            title: "How Connections Work",
            brief: "When we surface a connection between entries, it's because there's a real link—similar language, related themes, or shared context. We don't manufacture connections. We help you see links that exist but that you might not remember.",
            expanded: """
Human memory is associative but limited. You might remember that you felt a certain way before, but not when or what triggered it.

Thresh's connection surfacing helps by:
• Finding entries with similar emotional tones
• Linking entries that mention the same people or places
• Identifying recurring patterns you might not notice

We're careful about this. A connection should feel like "Oh, right, I forgot about that" not "That's a stretch."

When you see a connection surfaced:
• It's based on your actual words, not inferred meaning
• It's offered as data, not interpretation
• You decide if it's meaningful

The goal is to extend your memory across time, helping you see your own patterns that might otherwise remain invisible.
""",
            category: .patterns,
            trigger: .firstConnectionSurface
        ),

        // ═══════════════════════════════════════════════════════════════════
        // PERSPECTIVE
        // ═══════════════════════════════════════════════════════════════════

        DesignNote(
            id: "weekly_reflection",
            title: "The Weekly View",
            brief: "Looking at a week of entries together reveals things you can't see day by day. Energy patterns, recurring frustrations, slow-building joys. The weekly view isn't just a summary—it's a different perspective that makes different patterns visible.",
            expanded: """
Daily entries are close-up shots. Weekly view is stepping back to see the composition.

What becomes visible at the weekly level:
• Energy patterns: When were you engaged vs. depleted?
• Emotional arcs: How did your mood change across the week?
• Recurring themes: What kept coming up?
• Gaps and absences: What didn't you write about?

This perspective shift is powerful because some patterns only exist at the weekly level. A single stressful day looks like an event. Five stressful days in a row reveals a pattern.

Weekly reflection isn't re-reading your entries. It's asking: What does the shape of this week tell me? What was I spending my attention on? What was I avoiding?

The weekly synthesis prompt guides this process, but the insight comes from you stepping into a different temporal position.
""",
            category: .perspective,
            trigger: .firstWeeklyReflection
        ),

        // ═══════════════════════════════════════════════════════════════════
        // PRACTICE
        // ═══════════════════════════════════════════════════════════════════

        DesignNote(
            id: "return_after_gap",
            title: "Welcome Back",
            brief: "Gaps happen. Life gets busy, habits slip, priorities shift. What matters isn't the unbroken streak—it's the return. The fact that you're here now means you're still practicing, still developing this skill. The gap is just data.",
            expanded: """
You've been away for a while, and you came back. That's the practice working.

Common worries about gaps:
• "I broke my streak" → There is no streak. Just practice.
• "I lost momentum" → Momentum rebuilds quickly.
• "I should catch up" → You don't need to. Start from now.

The gap itself is worth noticing:
• What pulled you away?
• What brought you back?
• What (if anything) did you miss about reflecting?

Many people find that gaps reveal something important about their relationship to reflection. Sometimes the gap is avoidance. Sometimes it's just life. Sometimes it's a signal that something in the practice needs adjusting.

Whatever the reason, you're here now. That's what matters. Start fresh.
""",
            category: .practice,
            trigger: .returnAfterGap
        ),

        DesignNote(
            id: "interpretation_drift",
            title: "Noticing Interpretation Drift",
            brief: "Your recent entries have been heavy on interpretation and light on capture. That's natural—we all drift toward meaning-making. This is a gentle nudge to swing back toward observation. What did you actually see and hear?",
            expanded: """
Interpretation drift is when your entries become mostly analysis:
• "I think this means..."
• "The reason is probably..."
• "I've decided that..."

This isn't wrong, but it's incomplete. When you skip capture and go straight to interpretation, you lose the raw material that makes reflection valuable.

Why we notice this for you:
• It's hard to see in yourself
• It happens gradually
• The pattern is invisible from inside it

When you see this note, try:
• Describe before you explain
• Include sensory details
• Quote actual words if you can
• Resist the urge to know what it means

You can always interpret later. You can't recover the details you didn't capture.

Think of it as recalibrating—swinging the pendulum back toward observation before it swings too far into interpretation.
""",
            category: .practice,
            trigger: .interpretationDriftDetected
        )
    ]

    // MARK: - Initialization

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadNoteStatuses()
    }

    // MARK: - Private Methods

    private func loadNoteStatuses() {
        let descriptor = FetchDescriptor<DesignNoteStatus>()
        do {
            let statuses = try modelContext.fetch(descriptor)
            noteStatuses = Dictionary(uniqueKeysWithValues: statuses.map { ($0.noteId, $0) })
        } catch {
            print("Error loading note statuses: \(error)")
        }
    }

    private func getOrCreateStatus(for noteId: String) -> DesignNoteStatus {
        if let existing = noteStatuses[noteId] {
            return existing
        }

        let newStatus = DesignNoteStatus(noteId: noteId)
        modelContext.insert(newStatus)
        noteStatuses[noteId] = newStatus

        do {
            try modelContext.save()
        } catch {
            print("Error saving note status: \(error)")
        }

        return newStatus
    }

    // MARK: - Public Methods

    /// Check if a note should be shown (hasn't been seen yet)
    func shouldShow(noteId: String) -> Bool {
        guard let status = noteStatuses[noteId] else {
            return true // Never seen, should show
        }
        return !status.seen
    }

    /// Mark a note as seen/dismissed
    func markSeen(noteId: String) {
        let status = getOrCreateStatus(for: noteId)
        status.markSeen()

        do {
            try modelContext.save()
        } catch {
            print("Error marking note as seen: \(error)")
        }
    }

    /// Record that a note was shown to the user
    func recordShown(noteId: String) {
        let status = getOrCreateStatus(for: noteId)
        status.recordShown()

        do {
            try modelContext.save()
        } catch {
            print("Error recording note shown: \(error)")
        }
    }

    /// Get the design note for a specific trigger
    func getNoteFor(trigger: NoteTrigger) -> DesignNote? {
        return Self.allNotes.first { $0.trigger == trigger }
    }

    /// Get the design note that should be shown for a trigger (if not already seen)
    func getNoteToShowFor(trigger: NoteTrigger) -> DesignNote? {
        guard let note = getNoteFor(trigger: trigger),
              shouldShow(noteId: note.id) else {
            return nil
        }
        return note
    }

    /// Get all design notes, optionally filtered by category
    func getAllNotes(category: NoteCategory? = nil) -> [DesignNote] {
        if let category = category {
            return Self.allNotes.filter { $0.category == category }
        }
        return Self.allNotes
    }

    /// Get notes grouped by category
    func getNotesGroupedByCategory() -> [(category: NoteCategory, notes: [DesignNote])] {
        return NoteCategory.allCases.compactMap { category in
            let notes = Self.allNotes.filter { $0.category == category }
            return notes.isEmpty ? nil : (category, notes)
        }
    }

    /// Check if a note has been seen
    func hasBeenSeen(noteId: String) -> Bool {
        return noteStatuses[noteId]?.seen ?? false
    }

    /// Get count of unseen notes
    func unseenNotesCount() -> Int {
        return Self.allNotes.filter { !hasBeenSeen(noteId: $0.id) }.count
    }

    /// Reset all notes to unseen (for testing or user request)
    func resetAllNotes() {
        for status in noteStatuses.values {
            modelContext.delete(status)
        }
        noteStatuses.removeAll()

        do {
            try modelContext.save()
        } catch {
            print("Error resetting notes: \(error)")
        }
    }
}
//
//  DesignNote.swift
//  Thresh
//
//  Design Notes are brief, contextual explanations of WHY features work the way they do.
//  They appear at key moments, are dismissable, and collected in Settings.
//

import Foundation

// MARK: - DesignNote Model

/// A design note that explains the philosophy behind a feature
struct DesignNote: Identifiable, Hashable {
    let id: String
    let title: String
    let brief: String      // 2-4 sentences, always visible
    let expanded: String   // Full explanation
    let category: NoteCategory
    let trigger: NoteTrigger

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DesignNote, rhs: DesignNote) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - NoteCategory

/// Categories for organizing design notes
enum NoteCategory: String, CaseIterable, Identifiable {
    case foundation
    case dailyPractice
    case synthesis
    case patterns
    case perspective
    case practice

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .foundation: return "Foundation"
        case .dailyPractice: return "Daily Practice"
        case .synthesis: return "Synthesis"
        case .patterns: return "Patterns"
        case .perspective: return "Perspective"
        case .practice: return "Practice"
        }
    }

    var description: String {
        switch self {
        case .foundation:
            return "Core philosophy and principles"
        case .dailyPractice:
            return "The daily reflection workflow"
        case .synthesis:
            return "How meaning emerges over time"
        case .patterns:
            return "Recognizing themes and connections"
        case .perspective:
            return "Temporal views and time-based insights"
        case .practice:
            return "Building the reflection habit"
        }
    }
}

// MARK: - NoteTrigger

/// Triggers that determine when a design note should be shown
enum NoteTrigger: String, CaseIterable, Identifiable {
    case onboarding
    case firstDailyEntry
    case firstPureCapture
    case firstSynthesisOffer
    case firstWeeklyReflection
    case firstTimeSinceIndicator
    case firstQuestionExtraction
    case firstConnectionSurface
    case returnAfterGap
    case interpretationDriftDetected
    case captureQualityFeedback
    case modeSwitch
    case themeEmergence
    case weeklyReviewAvailable

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .onboarding: return "Onboarding"
        case .firstDailyEntry: return "First Daily Entry"
        case .firstPureCapture: return "First Pure Capture"
        case .firstSynthesisOffer: return "First Synthesis Offer"
        case .firstWeeklyReflection: return "First Weekly Reflection"
        case .firstTimeSinceIndicator: return "First Time-Since Indicator"
        case .firstQuestionExtraction: return "First Question Extraction"
        case .firstConnectionSurface: return "First Connection Surface"
        case .returnAfterGap: return "Return After Gap"
        case .interpretationDriftDetected: return "Interpretation Drift Detected"
        case .captureQualityFeedback: return "Capture Quality Feedback"
        case .modeSwitch: return "Mode Switch"
        case .themeEmergence: return "Theme Emergence"
        case .weeklyReviewAvailable: return "Weekly Review Available"
        }
    }
}
//
//  DesignNoteStatus.swift
//  Thresh
//
//  SwiftData model for tracking which design notes have been seen by the user.
//

import Foundation
import SwiftData

/// Tracks the seen/dismissed status of a design note
@Model
final class DesignNoteStatus {
    /// The unique identifier of the design note
    @Attribute(.unique) var noteId: String

    /// Whether the user has seen/dismissed this note
    var seen: Bool

    /// When the note was first shown to the user
    var firstShownAt: Date?

    /// When the user dismissed the note
    var dismissedAt: Date?

    /// How many times the note has been shown
    var showCount: Int

    init(noteId: String, seen: Bool = false) {
        self.noteId = noteId
        self.seen = seen
        self.firstShownAt = nil
        self.dismissedAt = nil
        self.showCount = 0
    }

    /// Mark the note as seen/dismissed
    func markSeen() {
        if !seen {
            seen = true
            dismissedAt = Date()
        }
    }

    /// Record that the note was shown
    func recordShown() {
        if firstShownAt == nil {
            firstShownAt = Date()
        }
        showCount += 1
    }
}
