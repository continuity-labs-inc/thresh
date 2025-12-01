import Foundation

/// AIService provides AI-powered features for reflection analysis.
/// Currently provides connection detection between reflections.
actor AIService {
    /// Shared instance for app-wide access
    static let shared = AIService()

    private init() {}

    /// Detect connections between a set of reflections.
    /// This is a simplified local implementation that looks for keyword overlap.
    /// In production, this could use on-device ML or a backend API.
    func detectConnections(in reflections: [Reflection]) async -> [Connection] {
        guard reflections.count >= 2 else { return [] }

        var connections: [Connection] = []

        // Compare each pair of reflections
        for i in 0..<reflections.count {
            for j in (i + 1)..<reflections.count {
                let source = reflections[i]
                let target = reflections[j]

                // Check for thematic connections (shared words)
                if let thematicConnection = detectThematicConnection(source: source, target: target) {
                    connections.append(thematicConnection)
                }

                // Check for question-answer patterns
                if let qaConnection = detectQuestionAnswerConnection(source: source, target: target) {
                    connections.append(qaConnection)
                }

                // Check for evolution patterns (similar topics with progression)
                if let evolutionConnection = detectEvolutionConnection(source: source, target: target) {
                    connections.append(evolutionConnection)
                }
            }
        }

        return connections
    }

    // MARK: - Private Detection Methods

    private func detectThematicConnection(source: Reflection, target: Reflection) -> Connection? {
        let sourceWords = extractKeywords(from: source.captureContent)
        let targetWords = extractKeywords(from: target.captureContent)

        let sharedWords = sourceWords.intersection(targetWords)

        // Require at least 2 shared meaningful words
        guard sharedWords.count >= 2 else { return nil }

        let confidence = min(Double(sharedWords.count) / 5.0, 1.0)
        let sharedList = Array(sharedWords.prefix(3)).joined(separator: ", ")

        return Connection(
            sourceReflectionId: source.id,
            targetReflectionId: target.id,
            connectionType: .thematic,
            description: "Shared themes: \(sharedList)",
            confidence: confidence
        )
    }

    private func detectQuestionAnswerConnection(source: Reflection, target: Reflection) -> Connection? {
        // Check if one is a question and the other might be an answer
        let sourceIsQuestion = source.focusType == .question ||
                               source.captureContent.contains("?")
        let targetIsQuestion = target.focusType == .question ||
                               target.captureContent.contains("?")

        // One should be a question, the other not
        guard sourceIsQuestion != targetIsQuestion else { return nil }

        // Check for keyword overlap suggesting relevance
        let sourceWords = extractKeywords(from: source.captureContent)
        let targetWords = extractKeywords(from: target.captureContent)
        let sharedWords = sourceWords.intersection(targetWords)

        guard sharedWords.count >= 1 else { return nil }

        // The later one should be the non-question (potential answer)
        let question = sourceIsQuestion ? source : target
        let potentialAnswer = sourceIsQuestion ? target : source

        // Answer should come after question
        guard potentialAnswer.createdAt > question.createdAt else { return nil }

        return Connection(
            sourceReflectionId: question.id,
            targetReflectionId: potentialAnswer.id,
            connectionType: .questionAnswer,
            description: "This might address your earlier question",
            confidence: 0.6
        )
    }

    private func detectEvolutionConnection(source: Reflection, target: Reflection) -> Connection? {
        // Look for similar content with temporal distance
        let sourceWords = extractKeywords(from: source.captureContent)
        let targetWords = extractKeywords(from: target.captureContent)

        let sharedWords = sourceWords.intersection(targetWords)
        let totalUniqueWords = sourceWords.union(targetWords).count

        // Need some overlap but not too much (that would be repetition, not evolution)
        let overlapRatio = Double(sharedWords.count) / Double(max(totalUniqueWords, 1))

        guard overlapRatio >= 0.2 && overlapRatio <= 0.6 else { return nil }

        // Need at least a day apart
        let daysBetween = Calendar.current.dateComponents(
            [.day],
            from: min(source.createdAt, target.createdAt),
            to: max(source.createdAt, target.createdAt)
        ).day ?? 0

        guard daysBetween >= 1 else { return nil }

        return Connection(
            sourceReflectionId: source.createdAt < target.createdAt ? source.id : target.id,
            targetReflectionId: source.createdAt < target.createdAt ? target.id : source.id,
            connectionType: .evolution,
            description: "This idea seems to have evolved over \(daysBetween) days",
            confidence: 0.5 + overlapRatio
        )
    }

    private func extractKeywords(from text: String) -> Set<String> {
        // Common words to ignore
        let stopWords: Set<String> = [
            "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for",
            "of", "with", "by", "from", "is", "are", "was", "were", "be", "been",
            "being", "have", "has", "had", "do", "does", "did", "will", "would",
            "could", "should", "may", "might", "must", "shall", "can", "need",
            "it", "its", "this", "that", "these", "those", "i", "me", "my",
            "we", "our", "you", "your", "he", "she", "they", "them", "their",
            "what", "which", "who", "when", "where", "why", "how", "all", "each",
            "every", "both", "few", "more", "most", "other", "some", "such", "no",
            "not", "only", "same", "so", "than", "too", "very", "just", "about",
            "into", "through", "during", "before", "after", "above", "below",
            "between", "under", "again", "further", "then", "once", "here",
            "there", "any", "if", "because", "as", "until", "while", "out",
            "up", "down", "off", "over", "am", "been", "get", "got", "go",
            "going", "make", "made", "know", "think", "feel", "really", "like"
        ]

        let words = text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 2 && !stopWords.contains($0) }

        return Set(words)
    }
}
