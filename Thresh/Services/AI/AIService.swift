import Foundation

/// Represents extracted items from a reflection
struct ExtractionResult: Sendable {
    struct ExtractedStory: Identifiable, Sendable {
        let id = UUID()
        let title: String
        let content: String
    }

    struct ExtractedIdea: Identifiable, Sendable {
        let id = UUID()
        let title: String
        let details: String
        let category: String?
    }

    struct ExtractedQuestion: Identifiable, Sendable {
        let id = UUID()
        let text: String
        let context: String?
    }

    let stories: [ExtractedStory]
    let ideas: [ExtractedIdea]
    let questions: [ExtractedQuestion]

    var isEmpty: Bool {
        stories.isEmpty && ideas.isEmpty && questions.isEmpty
    }

    var totalCount: Int {
        stories.count + ideas.count + questions.count
    }
}

/// AIService provides AI-powered features for reflection analysis.
/// Currently provides connection detection between reflections.
actor AIService {
    /// Shared instance for app-wide access
    static let shared = AIService()

    private let apiKey = Secrets.anthropicAPIKey
    private let model = "claude-sonnet-4-20250514"
    private let apiURL = URL(string: "https://api.anthropic.com/v1/messages")!

    private init() {}

    // MARK: - Extraction from Reflection

    /// Extract stories, ideas, and questions from reflection text using Claude API
    func extractFromReflection(_ text: String) async throws -> ExtractionResult {
        // Skip short texts to avoid wasting tokens
        guard text.count >= 50 else {
            return ExtractionResult(stories: [], ideas: [], questions: [])
        }

        let prompt = """
        Analyze the following personal reflection and extract any embedded stories, ideas, or questions.

        A STORY is a narrative about something that happened - it has characters, events, or a sequence of actions.
        An IDEA is a concept, insight, plan, or actionable thought the person has.
        A QUESTION is something the person is wondering about or wants to explore further.

        Only extract items that are clearly present in the text. Don't invent things that aren't there.

        Respond in this exact JSON format (no markdown, just raw JSON):
        {
            "stories": [
                {"title": "Brief title", "content": "The story content"}
            ],
            "ideas": [
                {"title": "Brief title", "details": "The idea details", "category": "optional category or null"}
            ],
            "questions": [
                {"text": "The question", "context": "optional context or null"}
            ]
        }

        If nothing is found for a category, use an empty array.

        REFLECTION TEXT:
        \(text)
        """

        let requestBody: [String: Any] = [
            "model": model,
            "max_tokens": 1024,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            print("❌ Claude API error: HTTP \(statusCode)")
            if let errorText = String(data: data, encoding: .utf8) {
                print("❌ Error body: \(errorText)")
            }
            throw NSError(domain: "AIService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed"])
        }

        // Parse Claude's response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstContent = content.first,
              let textContent = firstContent["text"] as? String else {
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }

        // Parse the JSON from Claude's text response
        return try parseExtractionResponse(textContent)
    }

    private func parseExtractionResponse(_ text: String) throws -> ExtractionResult {
        // Clean up the text - remove any markdown code blocks if present
        var cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedText.hasPrefix("```json") {
            cleanedText = String(cleanedText.dropFirst(7))
        } else if cleanedText.hasPrefix("```") {
            cleanedText = String(cleanedText.dropFirst(3))
        }
        if cleanedText.hasSuffix("```") {
            cleanedText = String(cleanedText.dropLast(3))
        }
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let jsonData = cleanedText.data(using: .utf8),
              let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse extraction JSON"])
        }

        var stories: [ExtractionResult.ExtractedStory] = []
        var ideas: [ExtractionResult.ExtractedIdea] = []
        var questions: [ExtractionResult.ExtractedQuestion] = []

        // Parse stories
        if let storiesArray = json["stories"] as? [[String: Any]] {
            for storyDict in storiesArray {
                if let title = storyDict["title"] as? String,
                   let content = storyDict["content"] as? String {
                    stories.append(ExtractionResult.ExtractedStory(title: title, content: content))
                }
            }
        }

        // Parse ideas
        if let ideasArray = json["ideas"] as? [[String: Any]] {
            for ideaDict in ideasArray {
                if let title = ideaDict["title"] as? String,
                   let details = ideaDict["details"] as? String {
                    let category = ideaDict["category"] as? String
                    ideas.append(ExtractionResult.ExtractedIdea(title: title, details: details, category: category))
                }
            }
        }

        // Parse questions
        if let questionsArray = json["questions"] as? [[String: Any]] {
            for questionDict in questionsArray {
                if let text = questionDict["text"] as? String {
                    let context = questionDict["context"] as? String
                    questions.append(ExtractionResult.ExtractedQuestion(text: text, context: context))
                }
            }
        }

        return ExtractionResult(stories: stories, ideas: ideas, questions: questions)
    }

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
