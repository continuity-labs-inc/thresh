import Foundation

/// Service for AI-powered features like question extraction
actor AIService {
    // MARK: - Singleton

    static let shared = AIService()

    private init() {}

    // MARK: - Question Extraction

    /// Extract potential questions from reflection content
    /// - Parameter content: The capture text to analyze
    /// - Returns: Array of extracted question strings
    func extractQuestions(from content: String) async -> [String] {
        // Simulate network delay for AI processing
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        // For now, use heuristic extraction
        // In production, this would call an AI API
        return extractQuestionsHeuristically(from: content)
    }

    // MARK: - Theme Extraction

    /// Extract themes from reflection content
    /// - Parameter content: The text to analyze
    /// - Returns: Array of theme strings
    func extractThemes(from content: String) async -> [String] {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        // Placeholder implementation
        return extractThemesHeuristically(from: content)
    }

    // MARK: - Private Methods

    private func extractQuestionsHeuristically(from content: String) -> [String] {
        var questions: [String] = []

        // Split into sentences
        let sentences = content.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        for sentence in sentences {
            // Look for question indicators
            if sentence.contains("?") {
                questions.append(sentence + "?")
                continue
            }

            // Look for implicit questions (phrases that suggest curiosity)
            let questionIndicators = [
                "wonder", "curious", "why", "how come", "what if",
                "not sure", "uncertain", "puzzled", "confused",
                "trying to understand", "makes me think"
            ]

            let lowercased = sentence.lowercased()
            for indicator in questionIndicators {
                if lowercased.contains(indicator) {
                    // Transform observation into question
                    let questionized = transformToQuestion(sentence)
                    if !questionized.isEmpty {
                        questions.append(questionized)
                    }
                    break
                }
            }
        }

        // Limit to 3 most relevant questions
        return Array(questions.prefix(3))
    }

    private func transformToQuestion(_ sentence: String) -> String {
        let lowercased = sentence.lowercased()

        if lowercased.contains("wonder") {
            // "I wonder why X" -> "Why X?"
            if let range = lowercased.range(of: "wonder") {
                let afterWonder = String(sentence[range.upperBound...])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                if !afterWonder.isEmpty {
                    return afterWonder.prefix(1).uppercased() +
                           afterWonder.dropFirst() + "?"
                }
            }
        }

        if lowercased.contains("not sure") || lowercased.contains("uncertain") {
            // "I'm not sure why X" -> "Why X?"
            return "What is really going on here?"
        }

        if lowercased.contains("curious") {
            return "What am I curious about in this moment?"
        }

        // Default: turn statement into reflection question
        return "What does this tell me about myself?"
    }

    private func extractThemesHeuristically(from content: String) -> [String] {
        var themes: [String] = []
        let lowercased = content.lowercased()

        // Theme keyword mapping
        let themeKeywords: [String: [String]] = [
            "growth": ["learn", "grow", "develop", "progress", "improve"],
            "relationships": ["friend", "family", "partner", "colleague", "connection"],
            "work": ["job", "work", "career", "project", "task", "meeting"],
            "health": ["body", "exercise", "sleep", "energy", "tired", "sick"],
            "emotions": ["feel", "felt", "happy", "sad", "angry", "anxious", "joy"],
            "creativity": ["create", "make", "design", "write", "art", "music"],
            "nature": ["outside", "nature", "walk", "garden", "trees", "sky"],
            "mindfulness": ["present", "aware", "notice", "observe", "breath"]
        ]

        for (theme, keywords) in themeKeywords {
            for keyword in keywords {
                if lowercased.contains(keyword) {
                    themes.append(theme)
                    break
                }
            }
        }

        return Array(Set(themes)) // Remove duplicates
    }
}
