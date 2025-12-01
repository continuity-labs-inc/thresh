import Foundation

/// A design note explaining app philosophy or guiding user understanding
struct DesignNote: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let trigger: NoteTrigger

    /// Creates a design note
    init(id: String, title: String, content: String, trigger: NoteTrigger) {
        self.id = id
        self.title = title
        self.content = content
        self.trigger = trigger
    }
}

// MARK: - Predefined Design Notes

extension DesignNote {
    static let allNotes: [DesignNote] = [
        DesignNote(
            id: "first_daily",
            title: "Welcome to Reflection",
            content: """
            This app is designed around a simple insight: we often jump to conclusions before \
            really seeing what happened.

            That's why we start with Capture Mode. Before asking "what does it mean?", \
            we first ask "what did you notice?"

            Take your time. The meaning will emerge.
            """,
            trigger: .firstDailyEntry
        ),
        DesignNote(
            id: "first_pure_capture",
            title: "The Power of Pure Capture",
            content: """
            You just saved a pure capture—an observation without interpretation.

            This is valuable. Sometimes the most important thing is to record what happened \
            without rushing to make sense of it.

            You can always return to add meaning later, or let patterns reveal themselves \
            over time through your weekly reviews.
            """,
            trigger: .firstPureCapture
        ),
        DesignNote(
            id: "first_synthesis",
            title: "Grounded Meaning",
            content: """
            When you add synthesis to a capture, you're creating what we call a \
            "grounded reflection"—meaning that's anchored in specific observation.

            This is different from abstract interpretation. Your insights are rooted \
            in something concrete you witnessed.
            """,
            trigger: .firstSynthesis
        ),
        DesignNote(
            id: "mode_switch",
            title: "Switching Modes",
            content: """
            Notice the shift from 📷 Capture Mode to 🔮 Synthesis Mode.

            These are different mental states. Capture is about being present \
            and recording. Synthesis is about stepping back and finding meaning.

            The separation helps ensure your interpretations are grounded in \
            what actually happened.
            """,
            trigger: .modeSwitch
        ),
        DesignNote(
            id: "weekly_review",
            title: "Patterns Emerge",
            content: """
            You have enough daily reflections to do a weekly review.

            This is where the magic happens—themes and patterns that weren't \
            visible in individual moments become clear when you see them together.
            """,
            trigger: .weeklyReviewAvailable
        ),
        DesignNote(
            id: "theme_emergence",
            title: "A Theme is Emerging",
            content: """
            We've noticed a recurring theme in your reflections.

            Themes aren't assigned by us—they emerge from your observations. \
            Pay attention to what keeps showing up. There's wisdom in repetition.
            """,
            trigger: .themeEmergence
        )
    ]
}
