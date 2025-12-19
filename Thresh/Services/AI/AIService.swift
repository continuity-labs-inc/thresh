import Foundation
import NaturalLanguage

/// Represents the analysis of a reflection for observational specificity
struct ObservationAnalysis: Sendable {
    let isObservational: Bool
    let followUpQuestions: [String]
    let detectedTopics: [String]
}

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
        // Skip short texts to avoid wasting tokens (lowered to 20 chars)
        guard text.count >= 20 else {
            print("⚠️ AIService: Text too short (\(text.count) chars), skipping extraction")
            return ExtractionResult(stories: [], ideas: [], questions: [])
        }

        print("🤖 AIService.extractFromReflection: Starting extraction for \(text.count) chars")
        print("🔑 AIService: Using API key: \(String(apiKey.prefix(15)))...")

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

        print("📡 AIService: Calling Claude API at \(apiURL)...")
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ AIService: No HTTP response received")
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No HTTP response"])
        }

        print("📡 AIService: Claude API response status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            print("❌ AIService: Claude API error: HTTP \(httpResponse.statusCode)")
            if let errorText = String(data: data, encoding: .utf8) {
                print("❌ AIService: Error body: \(errorText)")
            }
            throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed with status \(httpResponse.statusCode)"])
        }

        // Parse Claude's response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstContent = content.first,
              let textContent = firstContent["text"] as? String else {
            print("❌ AIService: Failed to parse Claude response JSON")
            if let responseText = String(data: data, encoding: .utf8) {
                print("❌ AIService: Raw response: \(responseText.prefix(500))")
            }
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }

        print("✅ AIService: Claude response received, parsing extraction...")

        // Parse the JSON from Claude's text response
        let result = try parseExtractionResponse(textContent)
        print("✅ AIService: Extracted \(result.stories.count) stories, \(result.ideas.count) ideas, \(result.questions.count) questions")
        return result
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

    // MARK: - Observation Analysis

    /// Analyze a reflection for observational specificity
    /// Returns whether it's observational or interpretive/venting, with follow-up questions if needed
    func analyzeForObservationGaps(_ content: String) async throws -> ObservationAnalysis {
        // Skip short texts
        guard content.count >= 50 else {
            return ObservationAnalysis(isObservational: true, followUpQuestions: [], detectedTopics: [])
        }

        let prompt = """
        You are analyzing a personal reflection for observational specificity.

        Venting/interpretation includes: judgments ("unhealthy", "obsessive", "terrible"), emotions without context ("disappointing", "frustrating"), vague descriptions ("behaves poorly", "was mean"), generalizations ("always", "never").

        Observation includes: specific quotes, concrete actions, timestamps, sensory details, who/what/where/when, specific moments, what someone actually said or did.

        Given this reflection, return:
        1. isObservational: true if mostly concrete observations, false if mostly interpretation/venting
        2. followUpQuestions: If not observational, provide 2-3 questions asking for missing concrete details (what did they say? what specifically happened? what did you see/hear?)
        3. detectedTopics: key themes/people/topics mentioned (2-4 words)

        Return ONLY valid JSON, no markdown:
        {"isObservational": true/false, "followUpQuestions": ["question1", "question2"], "detectedTopics": ["topic1", "topic2"]}

        REFLECTION TEXT:
        \(content)
        """

        let requestBody: [String: Any] = [
            "model": model,
            "max_tokens": 512,
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
            throw NSError(domain: "AIService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed"])
        }

        // Parse Claude's response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstContent = content.first,
              let textContent = firstContent["text"] as? String else {
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }

        return try parseObservationResponse(textContent)
    }

    private func parseObservationResponse(_ text: String) throws -> ObservationAnalysis {
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
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse observation JSON"])
        }

        let isObservational = json["isObservational"] as? Bool ?? true
        let followUpQuestions = json["followUpQuestions"] as? [String] ?? []
        let detectedTopics = json["detectedTopics"] as? [String] ?? []

        return ObservationAnalysis(
            isObservational: isObservational,
            followUpQuestions: followUpQuestions,
            detectedTopics: detectedTopics
        )
    }

    /// Detect connections between a set of reflections.
    /// Uses a hybrid approach: keyword matching for obvious connections,
    /// plus on-device NLP embeddings for semantic similarity.
    func detectConnections(in reflections: [Reflection]) async -> [Connection] {
        guard reflections.count >= 2 else { return [] }

        var connections: [Connection] = []

        // Track which pairs have been connected by keywords
        var connectedPairs: Set<String> = []

        // First pass: keyword-based detection (fast)
        for i in 0..<reflections.count {
            for j in (i + 1)..<reflections.count {
                let source = reflections[i]
                let target = reflections[j]
                let pairKey = "\(source.id)-\(target.id)"

                // Check for thematic connections (shared words)
                if let thematicConnection = detectThematicConnection(source: source, target: target) {
                    connections.append(thematicConnection)
                    connectedPairs.insert(pairKey)
                }

                // Check for question-answer patterns
                if let qaConnection = detectQuestionAnswerConnection(source: source, target: target) {
                    connections.append(qaConnection)
                    connectedPairs.insert(pairKey)
                }

                // Check for evolution patterns (similar topics with progression)
                if let evolutionConnection = detectEvolutionConnection(source: source, target: target) {
                    connections.append(evolutionConnection)
                    connectedPairs.insert(pairKey)
                }
            }
        }

        // Second pass: semantic similarity using NLP embeddings
        // Only for recent reflections (last 90 days) to optimize performance
        let recentCutoff = Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date()
        let recentReflections = reflections.filter { $0.createdAt > recentCutoff }

        guard recentReflections.count >= 2 else { return connections }

        // Cache embeddings to avoid recomputing
        var embeddingCache: [UUID: [Double]?] = [:]
        for reflection in recentReflections {
            embeddingCache[reflection.id] = computeEmbedding(for: reflection.captureContent)
        }

        // Check pairs that weren't already connected by keywords
        let semanticThreshold = 0.65

        for i in 0..<recentReflections.count {
            for j in (i + 1)..<recentReflections.count {
                let r1 = recentReflections[i]
                let r2 = recentReflections[j]
                let pairKey = "\(r1.id)-\(r2.id)"
                let reversePairKey = "\(r2.id)-\(r1.id)"

                // Skip if already connected by keywords
                if connectedPairs.contains(pairKey) || connectedPairs.contains(reversePairKey) {
                    continue
                }

                // Compute semantic similarity
                guard let emb1 = embeddingCache[r1.id] ?? nil,
                      let emb2 = embeddingCache[r2.id] ?? nil else {
                    continue
                }

                let similarity = cosineSimilarity(emb1, emb2)

                if similarity >= semanticThreshold {
                    let connection = Connection(
                        id: UUID(),
                        sourceReflectionId: r1.id,
                        targetReflectionId: r2.id,
                        connectionType: .thematic,
                        description: "These reflections share similar themes",
                        confidence: similarity,
                        isUserCreated: false
                    )
                    connections.append(connection)
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

        // Use NLP to extract better theme descriptions
        let combinedText = source.captureContent + " " + target.captureContent
        let themes = extractMeaningfulThemes(from: combinedText)

        // Build description from meaningful themes, falling back to shared words
        let description: String
        if themes.isEmpty {
            let sharedList = Array(sharedWords.prefix(3)).joined(separator: ", ")
            description = "Shared themes: \(sharedList)"
        } else {
            let themeList = themes.prefix(3).joined(separator: ", ")
            description = "Both touch on: \(themeList)"
        }

        return Connection(
            sourceReflectionId: source.id,
            targetReflectionId: target.id,
            connectionType: .thematic,
            description: description,
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
        // Common words to ignore - expanded list for better theme extraction
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
            "going", "make", "made", "know", "think", "feel", "really", "like",
            "one", "two", "three", "don", "doesn", "didn", "won", "wouldn",
            "thing", "things", "something", "anything", "nothing", "everything",
            "way", "ways", "lot", "lots", "bit", "much", "many", "now", "today",
            "yesterday", "tomorrow", "time", "times", "day", "days", "week", "month",
            "year", "still", "also", "even", "though", "although", "however",
            "yet", "already", "always", "never", "sometimes", "often", "usually",
            "back", "around", "through", "away", "over", "first", "last", "next",
            "new", "old", "good", "bad", "great", "little", "big", "small",
            "long", "short", "own", "well", "right", "left", "came", "come",
            "take", "took", "give", "gave", "put", "say", "said", "tell", "told",
            "see", "saw", "seen", "look", "looked", "want", "wanted", "let",
            "seem", "seemed", "seems", "ask", "asked", "try", "tried", "call",
            "called", "keep", "kept", "start", "started", "end", "ended"
        ]

        let words = text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 3 && !stopWords.contains($0) }

        return Set(words)
    }

    /// Extracts meaningful themes from text using NLP analysis
    /// Returns nouns, verbs, and adjectives that represent key concepts
    private func extractMeaningfulThemes(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType])
        tagger.string = text

        var themes: [String] = []
        let stopWords: Set<String> = [
            "have", "been", "would", "could", "should", "very", "really",
            "just", "like", "thing", "things", "some", "that", "this",
            "what", "when", "where", "which", "while", "don", "doesn",
            "didn", "won", "wouldn", "support", "one", "two", "three"
        ]

        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .lexicalClass
        ) { tag, range in
            guard let tag = tag else { return true }
            let word = String(text[range]).lowercased()

            // Only keep nouns, verbs, adjectives that are meaningful
            if (tag == .noun || tag == .verb || tag == .adjective) &&
                word.count > 3 && !stopWords.contains(word) {
                themes.append(word)
            }
            return true
        }

        // Also extract named entities (people, places, organizations)
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType
        ) { tag, range in
            if tag == .personalName || tag == .placeName || tag == .organizationName {
                let name = String(text[range])
                if name.count > 2 {
                    themes.append(name.lowercased())
                }
            }
            return true
        }

        // Return unique themes, limited to top 5
        return Array(Set(themes)).prefix(5).map { $0 }
    }

    // MARK: - Semantic Similarity (NLP)

    /// Computes a sentence embedding by averaging word embeddings.
    /// Returns nil if embedding fails (e.g., non-English text, embedding unavailable).
    private func computeEmbedding(for text: String) -> [Double]? {
        // Get the English word embedding model
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else {
            return nil
        }

        // Tokenize the text into words
        let tokenizer = NLTokenizer(unit: .word)
        let lowercasedText = text.lowercased()
        tokenizer.string = lowercasedText

        var vectors: [[Double]] = []

        tokenizer.enumerateTokens(in: lowercasedText.startIndex..<lowercasedText.endIndex) { range, _ in
            let word = String(lowercasedText[range])

            // Get the embedding vector for this word (dimension is typically 512)
            if let vector = embedding.vector(for: word) {
                vectors.append(vector)
            }
            return true // continue enumeration
        }

        // If no words had embeddings, return nil
        guard !vectors.isEmpty else { return nil }

        // Average all word vectors to get a sentence vector
        let dimension = vectors[0].count
        var averaged = [Double](repeating: 0.0, count: dimension)

        for vector in vectors {
            for i in 0..<dimension {
                averaged[i] += vector[i]
            }
        }

        for i in 0..<dimension {
            averaged[i] /= Double(vectors.count)
        }

        return averaged
    }

    /// Computes cosine similarity between two vectors. Returns value between -1 and 1.
    /// Higher values indicate more similar texts.
    private func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count == b.count, !a.isEmpty else { return 0.0 }

        var dotProduct = 0.0
        var magnitudeA = 0.0
        var magnitudeB = 0.0

        for i in 0..<a.count {
            dotProduct += a[i] * b[i]
            magnitudeA += a[i] * a[i]
            magnitudeB += b[i] * b[i]
        }

        let magnitude = sqrt(magnitudeA) * sqrt(magnitudeB)
        guard magnitude > 0 else { return 0.0 }

        return dotProduct / magnitude
    }
}
