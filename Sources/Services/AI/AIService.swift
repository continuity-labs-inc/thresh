import Foundation

// MARK: - AI Service

/// AI Service for Vicarious Me
///
/// AI PHILOSOPHY (Critical):
/// - AI EXTRACTS from user's words—it never generates content
/// - AI SURFACES patterns—it doesn't interpret meaning
/// - AI PROVIDES FEEDBACK on capture quality—not judgment
///
/// Three AI capabilities:
/// 1. Question extraction (from daily captures)
/// 2. Connection detection (across entries)
/// 3. Capture quality assessment (observation feedback)
@Observable
final class AIService {

    // MARK: - Singleton

    static let shared = AIService()

    // MARK: - Properties

    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let model = "gpt-4o"

    /// Whether the service has a valid API key configured
    var isConfigured: Bool {
        !apiKey.isEmpty
    }

    // MARK: - Initialization

    private init() {
        apiKey = KeychainService.shared.get(KeychainService.Keys.openAIAPIKey) ?? ""
    }

    // MARK: - Question Extraction

    /// Extracts questions that seem to be implied or embedded in the text
    ///
    /// CRITICAL: This extracts questions the USER is asking (perhaps unconsciously),
    /// not questions the AI has. It does not interpret emotions or provide therapy.
    ///
    /// - Parameter text: The journal entry text to analyze
    /// - Returns: Array of extracted questions (1-3 questions, or empty if none found)
    func extractQuestions(from text: String) async -> [String] {
        let systemPrompt = """
        You are a narrative researcher. Extract 1-3 questions that seem to be \
        implied or embedded in the text below.

        CRITICAL RULES:
        - Extract questions the USER is asking (perhaps unconsciously), not questions YOU have
        - DO NOT interpret emotions or provide therapy
        - DO NOT give self-help or advice-seeking questions
        - Only extract questions grounded in narrative, observation, or curiosity
        - Return only the questions, one per line
        - If no questions are found, return empty

        The questions should be what the text seems to be wondering about, \
        not what you think the person should be asking.
        """

        let response = await callGPT(
            system: systemPrompt,
            user: text,
            temperature: 0.3,
            maxTokens: 300
        )

        guard let content = response else { return [] }

        return parseQuestions(from: content)
    }

    /// Parses questions from GPT response, cleaning up formatting
    private func parseQuestions(from content: String) -> [String] {
        return content
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { cleanQuestion($0) }
            .filter { !$0.isEmpty }
    }

    /// Cleans a single question by removing common prefixes and formatting
    private func cleanQuestion(_ question: String) -> String {
        var cleaned = question

        // Remove numbered prefixes (1., 2., etc.)
        if let range = cleaned.range(of: #"^\d+[\.\)]\s*"#, options: .regularExpression) {
            cleaned = String(cleaned[range.upperBound...])
        }

        // Remove bullet points
        if cleaned.hasPrefix("-") || cleaned.hasPrefix("•") || cleaned.hasPrefix("*") {
            cleaned = String(cleaned.dropFirst()).trimmingCharacters(in: .whitespaces)
        }

        // Remove quotes if present
        if cleaned.hasPrefix("\"") && cleaned.hasSuffix("\"") {
            cleaned = String(cleaned.dropFirst().dropLast())
        }

        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Connection Detection

    /// Detects potential connections between journal entries
    ///
    /// CRITICAL: This surfaces POSSIBLE connections, not interpretations of meaning.
    /// The user decides if connections are meaningful.
    ///
    /// - Parameter reflections: Array of reflections to analyze (minimum 2 required)
    /// - Returns: Array of detected connections
    func detectConnections(in reflections: [Reflection]) async -> [Connection] {
        guard reflections.count >= 2 else { return [] }

        let entrySummaries = reflections.map { reflection in
            "[\(reflection.id.uuidString.prefix(8))]: \(reflection.captureContent.prefix(200))"
        }.joined(separator: "\n\n")

        let systemPrompt = """
        You are analyzing a set of journal entries for potential connections.

        CRITICAL: You are surfacing POSSIBLE connections, not interpreting meaning.
        The user decides if connections are meaningful.

        Look for:
        - Recurring themes or concerns
        - Same people, places, or situations
        - Contrasts or tensions between entries
        - Patterns the user might not notice

        Return JSON array of connections:
        [
          {
            "entry_ids": ["id1", "id2"],
            "connection_type": "theme|person|place|contrast|pattern",
            "description": "Brief description of the possible connection"
          }
        ]

        Return empty array [] if no meaningful connections found.
        Do not force connections that aren't there.
        """

        let response = await callGPT(
            system: systemPrompt,
            user: entrySummaries,
            temperature: 0.3,
            maxTokens: 500
        )

        return parseConnections(from: response)
    }

    /// Parses connections from GPT response
    private func parseConnections(from response: String?) -> [Connection] {
        guard let content = response,
              let data = extractJSON(from: content)?.data(using: .utf8),
              let dtos = try? JSONDecoder().decode([ConnectionDTO].self, from: data)
        else { return [] }

        return dtos.compactMap { dto -> Connection? in
            guard dto.entry_ids.count >= 2 else { return nil }
            return Connection(
                entryIds: dto.entry_ids,
                type: ConnectionType(rawValue: dto.connection_type) ?? .theme,
                description: dto.description
            )
        }
    }

    // MARK: - Capture Quality Assessment

    /// Assesses the observational quality of a journal entry
    ///
    /// Values:
    /// - Specificity: Concrete details vs. generalizations
    /// - Sensory detail: What was seen, heard, smelled, felt
    /// - Verbatim quotes: Actual words people said
    /// - Behavioral observation: What people DID (not what they felt)
    ///
    /// - Parameter text: The journal entry text to assess
    /// - Returns: Assessment of capture quality with suggestions
    func assessCaptureQuality(_ text: String) async -> CaptureQuality {
        let systemPrompt = """
        Assess this journal entry for OBSERVATIONAL quality (not interpretation quality).

        We value:
        - Specificity: Concrete details vs. generalizations
        - Sensory detail: What was seen, heard, smelled, felt
        - Verbatim quotes: Actual words people said
        - Behavioral observation: What people DID (not what they felt)

        Return JSON:
        {
          "specificity": "emerging|developing|strong",
          "sensory_detail": "emerging|developing|strong",
          "verbatim_presence": true|false,
          "behavioral_vs_emotional": 0.0-1.0,
          "suggestions": ["suggestion1", "suggestion2"]
        }

        Suggestions should be gentle prompts like:
        - "What did you actually see?"
        - "Can you recall any exact words?"
        - "Where exactly were you?"

        NOT judgments like "Your writing lacks detail."
        """

        let response = await callGPT(
            system: systemPrompt,
            user: text,
            temperature: 0.2,
            maxTokens: 300
        )

        return parseCaptureQuality(from: response)
    }

    /// Parses capture quality from GPT response
    private func parseCaptureQuality(from response: String?) -> CaptureQuality {
        guard let content = response,
              let jsonString = extractJSON(from: content),
              let data = jsonString.data(using: .utf8),
              let dto = try? JSONDecoder().decode(CaptureQualityDTO.self, from: data)
        else {
            return .default
        }

        return CaptureQuality(
            specificity: QualityLevel(rawValue: dto.specificity) ?? .emerging,
            sensoryDetail: QualityLevel(rawValue: dto.sensory_detail) ?? .emerging,
            verbatimPresence: dto.verbatim_presence,
            behavioralVsEmotional: dto.behavioral_vs_emotional,
            suggestions: dto.suggestions
        )
    }

    // MARK: - Interpretation Drift Detection

    /// Detects if user consistently skips to interpretation without capture
    ///
    /// This is a local heuristic check, not an AI call.
    ///
    /// - Parameter reflections: Recent reflections to analyze
    /// - Returns: True if interpretation drift is detected
    func detectInterpretationDrift(in reflections: [Reflection]) -> Bool {
        let recentReflections = Array(reflections.suffix(5))
        guard recentReflections.count >= 3 else { return false }

        let interpretationMarkers = [
            "I realized",
            "I think",
            "this means",
            "I learned",
            "I feel like",
            "I believe",
            "it seems like",
            "I understand now"
        ]

        let sensoryMarkers = [
            "saw",
            "heard",
            "felt",
            "said",
            "looked",
            "sounded",
            "smelled",
            "touched",
            "noticed",
            "watched"
        ]

        let pureInterpretationCount = recentReflections.filter { reflection in
            let lowercaseContent = reflection.captureContent.lowercased()

            // Check for interpretation markers
            let hasInterpretationMarkers = interpretationMarkers.contains { marker in
                lowercaseContent.contains(marker.lowercased())
            }

            // Check for sensory detail
            let hasSensoryDetail = sensoryMarkers.contains { marker in
                lowercaseContent.contains(marker)
            }

            return hasInterpretationMarkers && !hasSensoryDetail
        }.count

        return pureInterpretationCount >= 3
    }

    /// Generates a gentle nudge message when interpretation drift is detected
    func interpretationDriftNudge() -> String {
        let nudges = [
            "Your recent entries seem to jump to insights. What did you actually observe?",
            "Try capturing what you saw and heard before interpreting what it means.",
            "Great insights! Can you ground them in specific observations?",
            "What exactly did you see or hear that led to these thoughts?"
        ]
        return nudges.randomElement() ?? nudges[0]
    }

    // MARK: - API Call

    /// Makes a call to the GPT API
    private func callGPT(
        system: String,
        user: String,
        temperature: Double,
        maxTokens: Int
    ) async -> String? {
        guard !apiKey.isEmpty else {
            print("AIService: API key not configured")
            return nil
        }

        guard let url = URL(string: baseURL) else {
            print("AIService: Invalid URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        let body: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": system],
                ["role": "user", "content": user]
            ],
            "temperature": temperature,
            "max_tokens": maxTokens
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("AIService: Failed to serialize request body: \(error)")
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                print("AIService: HTTP error \(httpResponse.statusCode)")
                if let errorBody = String(data: data, encoding: .utf8) {
                    print("AIService: Error body: \(errorBody)")
                }
                return nil
            }

            let gptResponse = try JSONDecoder().decode(GPTResponse.self, from: data)
            return gptResponse.choices.first?.message.content
        } catch {
            print("AIService Error: \(error)")
            return nil
        }
    }

    // MARK: - Helpers

    /// Extracts JSON from a response that might have markdown code blocks
    private func extractJSON(from content: String) -> String? {
        // Try to extract from markdown code blocks
        if let jsonMatch = content.range(of: #"```(?:json)?\s*([\s\S]*?)```"#, options: .regularExpression) {
            var extracted = String(content[jsonMatch])
            // Remove the code block markers
            extracted = extracted.replacingOccurrences(of: "```json", with: "")
            extracted = extracted.replacingOccurrences(of: "```", with: "")
            return extracted.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Try to find raw JSON (array or object)
        if let arrayStart = content.firstIndex(of: "["),
           let arrayEnd = content.lastIndex(of: "]") {
            return String(content[arrayStart...arrayEnd])
        }

        if let objectStart = content.firstIndex(of: "{"),
           let objectEnd = content.lastIndex(of: "}") {
            return String(content[objectStart...objectEnd])
        }

        // Return as-is if no JSON markers found
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - API Key Management

extension AIService {
    /// Updates the API key (requires service restart to take effect)
    /// For immediate effect, use the returned new instance
    static func configure(withAPIKey apiKey: String) -> Bool {
        return KeychainService.shared.set(apiKey, for: KeychainService.Keys.openAIAPIKey)
    }

    /// Removes the stored API key
    static func removeAPIKey() -> Bool {
        return KeychainService.shared.delete(KeychainService.Keys.openAIAPIKey)
    }

    /// Checks if an API key is stored
    static var hasStoredAPIKey: Bool {
        KeychainService.shared.exists(KeychainService.Keys.openAIAPIKey)
    }
}
