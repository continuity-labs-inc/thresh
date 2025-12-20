import Foundation

struct CaptureAnalysis: Codable, Sendable {
    let category: String
    let domain: String
    let concreteElements: ConcreteElements
    let observationDepth: String
    let suggestedPhase2Focus: String
    let keyElement: String?
    let suggestedPhase2Prompt: String?

    struct ConcreteElements: Codable, Sendable {
        let people: Bool
        let place: Bool
        let dialogue: Bool
        let sensory: Bool
        let time: Bool
    }
}

extension AIService {

    /// Analyze Phase 1 content to determine category, domain, and observation depth
    func analyzeCapture(_ content: String) async throws -> CaptureAnalysis {
        let prompt = """
        Analyze this reflection capture and return JSON only.

        Capture:
        \(content)

        Return this exact JSON structure:
        {
          "category": "person|place|conversation|object|moment|routine",
          "domain": "interpersonal|professional|internal|environmental",
          "concreteElements": {
            "people": true/false,
            "place": true/false,
            "dialogue": true/false,
            "sensory": true/false,
            "time": true/false
          },
          "observationDepth": "surface|grounded|rich",
          "suggestedPhase2Focus": "brief suggestion for what to explore",
          "keyElement": "the main subject/object/person mentioned, or null",
          "suggestedPhase2Prompt": "A specific reflection question for this capture"
        }

        Definitions:
        - surface: mostly summary, few concrete details
        - grounded: some specific details present
        - rich: vivid sensory/dialogue/physical details

        For suggestedPhase2Prompt:
        Generate a specific Phase 2 reflection question that directly references what they wrote.
        The question should ask them to examine:
        - WHY they noticed what they noticed, OR
        - What they left out of their description, OR
        - What assumption is embedded in how they described it, OR
        - What the other person/object might say about this moment

        Examples of good Phase 2 prompts:
        - "You described her pause before saying goodbye. What do you think she's waiting for?"
        - "You mentioned the light was dim. What were you looking for in that darkness?"
        - "You said he 'always' does this. When did you first notice that pattern?"

        Keep the question to 1-2 sentences, conversational, and directly tied to their specific details.

        Return ONLY valid JSON, no other text.
        """

        // Use existing Claude API infrastructure
        let response = try await callClaude(prompt: prompt, maxTokens: 300)

        // Parse JSON response
        guard let data = response.data(using: .utf8),
              let analysis = try? JSONDecoder().decode(CaptureAnalysis.self, from: data) else {
            // Return safe default if parsing fails
            return CaptureAnalysis(
                category: "moment",
                domain: "internal",
                concreteElements: .init(people: false, place: false, dialogue: false, sensory: false, time: false),
                observationDepth: "surface",
                suggestedPhase2Focus: "What details did you leave out?",
                keyElement: nil,
                suggestedPhase2Prompt: nil
            )
        }

        return analysis
    }

    /// Helper method to call Claude API and return text response
    func callClaude(prompt: String, maxTokens: Int) async throws -> String {
        let apiURL = URL(string: "https://api.anthropic.com/v1/messages")!

        let requestBody: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": maxTokens,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Secrets.anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NSError(domain: "AIService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed with status \(statusCode)"])
        }

        // Parse Claude's response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstContent = content.first,
              let textContent = firstContent["text"] as? String else {
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }

        // Clean up markdown code blocks if present
        var cleanedText = textContent.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedText.hasPrefix("```json") {
            cleanedText = String(cleanedText.dropFirst(7))
        } else if cleanedText.hasPrefix("```") {
            cleanedText = String(cleanedText.dropFirst(3))
        }
        if cleanedText.hasSuffix("```") {
            cleanedText = String(cleanedText.dropLast(3))
        }
        return cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Generate a fresh, evocative Phase 1 prompt for a given category.
    /// Uses cached prompts when available to reduce API calls.
    func generatePhase1Prompt(category: PromptCategory?) async -> String {
        let cache = PromptCacheService.shared

        // Check cache first - if we have enough variety, use cached prompt
        if let cachedPrompt = cache.getCachedPrompt(for: category) {
            print("📚 Using cached prompt for \(category?.displayName ?? "Open")")
            return cachedPrompt
        }

        // Generate new prompt via AI
        let generatedPrompt = await generatePhase1PromptFromAI(category: category)

        // Cache the new prompt for future use
        cache.savePrompt(generatedPrompt, for: category)

        return generatedPrompt
    }

    /// Internal method that calls Claude to generate a prompt
    private func generatePhase1PromptFromAI(category: PromptCategory?) async -> String {
        let categoryName = category?.displayName ?? "Open"
        let categoryExamples: String

        switch category {
        case .person:
            categoryExamples = """
            - "Think of someone you saw today but didn't speak to. What were they doing with their hands?"
            - "Who surprised you today? Describe how they entered the room."
            - "Picture someone's face from today. What expression were they holding?"
            """
        case .place:
            categoryExamples = """
            - "Where did you feel most awake today? Describe the light."
            - "What room did you linger in? What sounds were there?"
            - "Describe a doorway you passed through. What changed on the other side?"
            """
        case .conversation:
            categoryExamples = """
            - "What phrase did someone say that you're still turning over? Quote it exactly."
            - "When did silence fall in a conversation today? What filled it?"
            - "What did someone say that you didn't expect? Write their words."
            """
        case .object:
            categoryExamples = """
            - "What did you pick up today without thinking? Describe its weight."
            - "What object has been in the same spot for too long? Look at it now."
            - "Describe something you touched repeatedly today. What does it feel like?"
            """
        case .moment:
            categoryExamples = """
            - "When did time slow down today, even for a second?"
            - "What moment had a before and after? Describe the hinge."
            - "When did you hold your breath today? What were you waiting for?"
            """
        case .routine:
            categoryExamples = """
            - "What's one thing you did on autopilot? Walk through it in slow motion."
            - "Describe your morning as if you were watching yourself from above."
            - "What habit have you stopped seeing? Describe it like a ritual."
            """
        case nil:
            categoryExamples = """
            - "What moment from today is still with you? Describe what happened."
            - "What did you notice today that you almost didn't? Describe it."
            - "What's still unfinished from today? Describe where you left it."
            """
        }

        let prompt = """
        Generate a single reflection prompt for the category: \(categoryName).

        The prompt should invite concrete, sensory observation—not feelings or interpretations.
        It should feel fresh and specific, not generic.
        It should be 1-2 sentences, conversational, and directly inviting action.

        Examples of good \(categoryName) prompts:
        \(categoryExamples)

        Generate a NEW prompt in this style. Be creative and specific.
        Return only the prompt text, nothing else. No quotes around it.
        """

        do {
            let response = try await callClaude(prompt: prompt, maxTokens: 100)
            let cleanedResponse = response
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))

            // Validate we got a reasonable response
            if cleanedResponse.count > 10 && cleanedResponse.count < 300 {
                return cleanedResponse
            }
        } catch {
            print("⚠️ AI prompt generation failed: \(error)")
        }

        // Fallback to static prompt
        return category?.phase1Prompts.randomElement() ?? "What moment from today is still with you? Describe what happened."
    }
}
