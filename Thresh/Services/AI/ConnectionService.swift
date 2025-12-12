import Foundation

/// Service for detecting meaningful connections between reflections using Claude API.
/// Connections are cached in UserDefaults and regenerated on demand.
actor ConnectionService {
    static let shared = ConnectionService()

    private let apiKey = Secrets.anthropicAPIKey
    private let model = "claude-sonnet-4-20250514"
    private let apiURL = URL(string: "https://api.anthropic.com/v1/messages")!

    private let cacheKey = "cachedConnections"
    private let lastGeneratedKey = "connectionsLastGenerated"

    private init() {}

    // MARK: - Public API

    /// Get cached connections or generate new ones if none exist
    func getConnections(for reflections: [Reflection]) async -> [Connection] {
        // Try to load from cache first
        if let cached = loadCachedConnections(), !cached.isEmpty {
            return cached
        }

        // Generate new connections
        return await regenerateConnections(for: reflections)
    }

    /// Force regeneration of connections (called from Patterns screen)
    func regenerateConnections(for reflections: [Reflection]) async -> [Connection] {
        guard reflections.count >= 2 else { return [] }

        // Filter to non-deleted reflections
        let activeReflections = reflections.filter { $0.deletedAt == nil }
        guard activeReflections.count >= 2 else { return [] }

        // Build the reflection summaries for the prompt
        let reflectionSummaries = activeReflections
            .sorted { $0.createdAt < $1.createdAt }
            .map { reflection -> String in
                let number = reflection.reflectionNumber
                let date = formatDate(reflection.createdAt)
                let preview = String(reflection.captureContent.prefix(200))
                return "Reflection #\(number) (\(date)):\n\(preview)"
            }
            .joined(separator: "\n\n---\n\n")

        // Call Claude API
        do {
            let connections = try await detectConnectionsWithClaude(
                summaries: reflectionSummaries,
                reflections: activeReflections
            )

            // Cache the results
            cacheConnections(connections)

            return connections
        } catch {
            print("❌ Connection detection failed: \(error)")
            return []
        }
    }

    /// Check when connections were last generated
    func lastGeneratedDate() -> Date? {
        UserDefaults.standard.object(forKey: lastGeneratedKey) as? Date
    }

    /// Clear cached connections (useful for testing)
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
        UserDefaults.standard.removeObject(forKey: lastGeneratedKey)
    }

    // MARK: - Claude API

    private func detectConnectionsWithClaude(
        summaries: String,
        reflections: [Reflection]
    ) async throws -> [Connection] {
        let prompt = """
        You are analyzing personal reflections to find meaningful connections between them.

        Look for these types of connections:
        - THEMATIC: Shared themes, topics, or subjects
        - EVOLUTION: An idea or feeling that developed over time
        - CAUSAL: One reflection led to or influenced another
        - CONTRASTING: Different perspectives on similar topics
        - PATTERN: Recurring behaviors, thoughts, or situations
        - QUESTION_ANSWER: A question raised in one that's addressed in another

        IMPORTANT GUIDELINES:
        1. Only identify connections that are genuinely meaningful
        2. Each connection needs a clear, specific reason (not just "both mention X")
        3. Maximum 5 connections to keep quality high
        4. Reference reflections by their number (e.g., "#3 and #7")

        Return ONLY valid JSON, no markdown:
        {
            "connections": [
                {
                    "sourceNumber": 3,
                    "targetNumber": 7,
                    "type": "thematic",
                    "description": "Both explore the tension between work ambition and personal time"
                }
            ]
        }

        Valid types: thematic, evolution, causal, contrasting, pattern, question_answer

        REFLECTIONS:
        \(summaries)
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
            throw NSError(domain: "ConnectionService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed"])
        }

        // Parse Claude's response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstContent = content.first,
              let textContent = firstContent["text"] as? String else {
            throw NSError(domain: "ConnectionService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }

        return try parseConnectionsResponse(textContent, reflections: reflections)
    }

    private func parseConnectionsResponse(_ text: String, reflections: [Reflection]) throws -> [Connection] {
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
              let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
              let connectionsArray = json["connections"] as? [[String: Any]] else {
            throw NSError(domain: "ConnectionService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse connections JSON"])
        }

        // Build a lookup by reflection number
        var reflectionByNumber: [Int: Reflection] = [:]
        for reflection in reflections {
            reflectionByNumber[reflection.reflectionNumber] = reflection
        }

        var connections: [Connection] = []

        for connDict in connectionsArray {
            guard let sourceNumber = connDict["sourceNumber"] as? Int,
                  let targetNumber = connDict["targetNumber"] as? Int,
                  let typeString = connDict["type"] as? String,
                  let description = connDict["description"] as? String,
                  let sourceReflection = reflectionByNumber[sourceNumber],
                  let targetReflection = reflectionByNumber[targetNumber] else {
                continue
            }

            let connectionType = parseConnectionType(typeString)

            let connection = Connection(
                sourceReflectionId: sourceReflection.id,
                targetReflectionId: targetReflection.id,
                sourceReflectionNumber: sourceNumber,
                targetReflectionNumber: targetNumber,
                connectionType: connectionType,
                description: description,
                confidence: 0.8, // Claude-generated connections have good confidence
                isUserCreated: false
            )
            connections.append(connection)
        }

        return connections
    }

    private func parseConnectionType(_ typeString: String) -> ConnectionType {
        switch typeString.lowercased() {
        case "thematic": return .thematic
        case "evolution": return .evolution
        case "causal": return .causal
        case "contrasting": return .contrasting
        case "pattern": return .pattern
        case "question_answer", "questionanswer": return .questionAnswer
        case "temporal": return .temporal
        default: return .thematic
        }
    }

    // MARK: - Caching

    private func loadCachedConnections() -> [Connection]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
            return nil
        }

        do {
            let cached = try JSONDecoder().decode([CachedConnection].self, from: data)
            return cached.map { $0.toConnection() }
        } catch {
            print("⚠️ Failed to load cached connections: \(error)")
            return nil
        }
    }

    private func cacheConnections(_ connections: [Connection]) {
        let cached = connections.map { CachedConnection(from: $0) }

        do {
            let data = try JSONEncoder().encode(cached)
            UserDefaults.standard.set(data, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: lastGeneratedKey)
        } catch {
            print("⚠️ Failed to cache connections: \(error)")
        }
    }

    // MARK: - Helpers

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Codable wrapper for caching

private struct CachedConnection: Codable {
    let id: String
    let sourceReflectionId: String
    let targetReflectionId: String
    let sourceReflectionNumber: Int
    let targetReflectionNumber: Int
    let connectionType: String
    let description: String
    let confidence: Double
    let isUserCreated: Bool
    let createdAt: Date

    init(from connection: Connection) {
        self.id = connection.id.uuidString
        self.sourceReflectionId = connection.sourceReflectionId.uuidString
        self.targetReflectionId = connection.targetReflectionId.uuidString
        self.sourceReflectionNumber = connection.sourceReflectionNumber
        self.targetReflectionNumber = connection.targetReflectionNumber
        self.connectionType = connection.connectionType.rawValue
        self.description = connection.description
        self.confidence = connection.confidence
        self.isUserCreated = connection.isUserCreated
        self.createdAt = connection.createdAt
    }

    func toConnection() -> Connection {
        Connection(
            id: UUID(uuidString: id) ?? UUID(),
            sourceReflectionId: UUID(uuidString: sourceReflectionId) ?? UUID(),
            targetReflectionId: UUID(uuidString: targetReflectionId) ?? UUID(),
            sourceReflectionNumber: sourceReflectionNumber,
            targetReflectionNumber: targetReflectionNumber,
            connectionType: ConnectionType(rawValue: connectionType) ?? .thematic,
            description: description,
            confidence: confidence,
            isUserCreated: isUserCreated,
            createdAt: createdAt
        )
    }
}
