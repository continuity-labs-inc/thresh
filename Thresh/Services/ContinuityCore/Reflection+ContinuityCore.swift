//
//  Reflection+ContinuityCore.swift
//  Thresh
//
//  ContinuityCore integration for Thresh reflections.
//  Produces ContinuityRecords for cross-app pattern visibility.
//

import Foundation

// MARK: - ThreshPayload

/// Payload structure for Thresh reflections in ContinuityCore.
/// Designed as a "middle layer" — structured enough for AYA to query,
/// textured enough for researchers to read.
struct ThreshPayload: Codable, Sendable {

    // MARK: - Structure (for querying)

    /// What kind of entry: pureCapture, groundedReflection, synthesis
    let entryType: String

    /// Temporal tier: daily, weekly, monthly, yearly, core, active, archive
    let tier: String

    /// Focus type if set: story, idea, question
    let focusType: String?

    /// How the user engaged: captureOnly, captureWithReflection, synthesisOnly
    let modeBalance: String

    // MARK: - Extracted (for pattern detection)

    /// Themes identified in this reflection
    let themes: [String]

    /// Tags applied by user
    let tags: [String]

    /// IDs of source reflections (for synthesis entries)
    let linkedReflectionIds: [String]

    // MARK: - Verbatim (for understanding)

    /// The core observation — Phase 1 content, preserved verbatim
    /// This is what the user noticed. The fly paper.
    let captureContent: String

    /// The meaning-making — Phase 2 content if present
    /// This is what they made of it.
    let reflectionContent: String?

    /// For synthesis entries, the synthesized insight
    let synthesisContent: String?

    /// A key excerpt — the sentence or phrase that carries the weight
    /// Extracted or selected as the "telling detail"
    let keyExcerpt: String?

    // MARK: - People Mentioned (future enhancement)

    /// People identified in the content
    /// Note: Extraction not yet implemented in Thresh v1.0
    /// This will be populated when entity extraction is added
    let peopleMentioned: [PersonMention]

    struct PersonMention: Codable, Sendable {
        let identifier: String
        let displayName: String
        let context: String?      // Brief phrase about how they appeared
        let valence: String?      // "grateful", "frustrated", "tender", etc.
    }

    // MARK: - Engagement (how the user processed)

    /// Is this reflection marinating? ("Hold for later" flag)
    let isMarinating: Bool

    /// Did the user complete Phase 2 reflection?
    let phase2Completed: Bool

    /// What prompted this reflection (once implemented)
    let promptCategory: String?   // "person", "place", "conversation", "object", "moment", "routine"

    /// Domain of the prompt (once implemented)
    let promptDomain: String?     // "interpersonal", "professional", "internal", "environmental"

    /// AI-assessed depth of observation (once implemented)
    let observationDepth: String? // "surface", "grounded", "rich"

    // MARK: - Temporal

    /// When the reflection was created
    let createdAt: Date

    /// When last updated
    let updatedAt: Date

    /// Sequential reflection number if assigned
    let reflectionNumber: Int?

    /// Number of revision layers (how many times revisited)
    let revisionCount: Int
}

// MARK: - Reflection Extension

extension Reflection {

    /// Creates a ContinuityRecord from this reflection
    func toContinuityRecord() -> ContinuityRecord {
        var entities: [EntityReference] = []

        // MARK: Extract entities using NLP
        let extracted = EntityExtractor.shared.extract(
            captureContent: captureContent,
            reflectionContent: reflectionContent,
            synthesisContent: synthesisContent
        )

        // MARK: People from NLP extraction
        for person in extracted.people {
            entities.append(EntityReference(
                type: .person,
                identifier: person.identifier,
                displayName: person.name
            ))
        }

        // MARK: Places from NLP extraction
        for place in extracted.places {
            entities.append(EntityReference(
                type: .place,
                identifier: place.identifier,
                displayName: place.name
            ))
        }

        // MARK: Concepts from NLP extraction (high salience only)
        for concept in extracted.concepts where concept.salience >= 0.1 {
            entities.append(EntityReference(
                type: .concept,
                identifier: concept.identifier,
                displayName: concept.name
            ))
        }

        // MARK: Concepts from themes (user-identified)
        for theme in themes {
            let identifier = theme
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "-")

            // Avoid duplicates from NLP extraction
            guard !entities.contains(where: { $0.type == .concept && $0.identifier == identifier }) else {
                continue
            }

            entities.append(EntityReference(
                type: .concept,
                identifier: identifier,
                displayName: theme
            ))
        }

        // MARK: Concepts from tags (if different from themes)
        for tag in tags where !themes.contains(tag) {
            let identifier = tag
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "-")

            // Avoid duplicates
            guard !entities.contains(where: { $0.type == .concept && $0.identifier == identifier }) else {
                continue
            }

            entities.append(EntityReference(
                type: .concept,
                identifier: identifier,
                displayName: tag
            ))
        }

        // MARK: Card references for synthesis entries
        for linkedReflection in linkedReflections {
            entities.append(EntityReference(
                type: .card,
                identifier: linkedReflection.id.uuidString,
                displayName: "Reflection \(linkedReflection.reflectionNumber ?? 0)"
            ))
        }

        // MARK: Build payload
        let peopleMentioned = extracted.people.map { person in
            ThreshPayload.PersonMention(
                identifier: person.identifier,
                displayName: person.name,
                context: person.context,
                valence: person.valence
            )
        }

        let payload = ThreshPayload(
            entryType: entryType.rawValue,
            tier: tier.rawValue,
            focusType: focusType?.rawValue,
            modeBalance: modeBalance.rawValue,
            themes: themes,
            tags: tags,
            linkedReflectionIds: linkedReflections.map { $0.id.uuidString },
            captureContent: captureContent,
            reflectionContent: reflectionContent,
            synthesisContent: synthesisContent,
            keyExcerpt: extracted.keyExcerpt ?? extractKeyExcerpt(),
            peopleMentioned: peopleMentioned,
            isMarinating: marinating,
            phase2Completed: reflectionContent != nil && !reflectionContent!.isEmpty,
            promptCategory: nil, // Future: promptCategory
            promptDomain: nil,   // Future: promptDomain
            observationDepth: nil, // Future: observationDepth
            createdAt: createdAt,
            updatedAt: updatedAt,
            reflectionNumber: reflectionNumber,
            revisionCount: revisionLayers.count
        )

        // MARK: Encode payload
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let payloadData = (try? encoder.encode(payload)) ?? Data()

        return ContinuityRecord(
            id: id,
            createdAt: createdAt,
            sourceApp: "thresh",
            entities: entities,
            payload: payloadData
        )
    }

    /// Saves this reflection to ContinuityCore
    func saveToContinuityStore() {
        let record = toContinuityRecord()
        do {
            try ContinuityRecordStore.shared.save(record)
            #if DEBUG
            print("[ContinuityCore] Saved reflection \(reflectionNumber ?? 0): \(themes.joined(separator: ", "))")
            #endif
        } catch {
            print("[ContinuityCore] Failed to save reflection: \(error.localizedDescription)")
        }
    }

    // MARK: - Private Helpers

    /// Extracts a key excerpt based on entry type
    private func extractKeyExcerpt() -> String? {
        switch entryType {
        case .pureCapture:
            // For pure captures, take the first substantive sentence
            return firstSubstantiveSentence(from: captureContent)

        case .groundedReflection:
            // For grounded reflections, prefer the reflection content (the "why")
            if let reflection = reflectionContent, !reflection.isEmpty {
                return firstSubstantiveSentence(from: reflection)
            }
            return firstSubstantiveSentence(from: captureContent)

        case .synthesis:
            // For synthesis, take from synthesis content
            if let synthesis = synthesisContent, !synthesis.isEmpty {
                return firstSubstantiveSentence(from: synthesis)
            }
            return nil
        }
    }

    /// Returns the first sentence that's at least 20 characters
    private func firstSubstantiveSentence(from text: String) -> String? {
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.count >= 20 }

        guard let first = sentences.first else {
            // If no sentence is long enough, return truncated content
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count > 150 {
                return String(trimmed.prefix(147)) + "..."
            }
            return trimmed.isEmpty ? nil : trimmed
        }

        // Cap at 200 characters
        if first.count > 200 {
            return String(first.prefix(197)) + "..."
        }
        return first
    }
}

// MARK: - Batch Operations

extension Array where Element == Reflection {

    /// Saves all reflections to ContinuityCore
    func saveToContinuityStore() {
        let records = self.map { $0.toContinuityRecord() }
        do {
            try ContinuityRecordStore.shared.save(records)
            #if DEBUG
            print("[ContinuityCore] Saved \(records.count) reflections")
            #endif
        } catch {
            print("[ContinuityCore] Failed to save batch: \(error.localizedDescription)")
        }
    }
}

// MARK: - Query Helpers

extension ContinuityRecordStore {

    /// Fetches all Thresh reflections
    func fetchThreshRecords() throws -> [ContinuityRecord] {
        try fetch(from: "thresh")
    }

    /// Fetches Thresh reflections involving a specific theme
    func fetchThreshRecords(theme: String) throws -> [ContinuityRecord] {
        let identifier = theme
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "-")

        return try fetch(involving: identifier).filter { $0.sourceApp == "thresh" }
    }

    /// Decodes a ThreshPayload from a ContinuityRecord
    func decodeThreshPayload(from record: ContinuityRecord) -> ThreshPayload? {
        guard record.sourceApp == "thresh" else { return nil }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(ThreshPayload.self, from: record.payload)
    }
}
