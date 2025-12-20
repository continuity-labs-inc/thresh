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
}
