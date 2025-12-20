//
//  ContinuityCore.swift
//  Thresh
//
//  Shared data structures for cross-app pattern visibility.
//  This is the foundation layer that enables AYA to query across
//  Continuity Labs apps (Thresh, Pops, Clearwater, etc.)
//

import Foundation

// MARK: - Entity Reference

/// A reference to an entity that appears in a record.
/// Entities are the "nouns" that connect experiences across apps.
struct EntityReference: Codable, Sendable, Identifiable, Hashable {

    /// The type of entity being referenced
    let type: EntityType

    /// A stable identifier for the entity (e.g., "john-doe", "work-stress", UUID string)
    let identifier: String

    /// Human-readable name for display
    let displayName: String

    var id: String { "\(type.rawValue):\(identifier)" }

    enum EntityType: String, Codable, Sendable {
        case person      // A person mentioned or involved
        case concept     // A theme, topic, or abstract concept
        case card        // Reference to another ContinuityRecord (for synthesis, links)
        case place       // A location
        case project     // A work project or personal project
        case routine     // A recurring activity or habit
    }
}

// MARK: - Continuity Record

/// A single record in the ContinuityCore system.
/// This is the atomic unit that flows between apps.
struct ContinuityRecord: Codable, Sendable, Identifiable {

    /// Unique identifier for this record
    let id: UUID

    /// When the record was created
    let createdAt: Date

    /// Which app created this record (e.g., "thresh", "pops", "clearwater")
    let sourceApp: String

    /// Entities referenced in this record
    let entities: [EntityReference]

    /// App-specific payload data (JSON encoded)
    /// Each app defines its own payload structure
    let payload: Data

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        sourceApp: String,
        entities: [EntityReference],
        payload: Data
    ) {
        self.id = id
        self.createdAt = createdAt
        self.sourceApp = sourceApp
        self.entities = entities
        self.payload = payload
    }
}

// MARK: - Continuity Record Store

/// Manages persistence and querying of ContinuityRecords.
/// Currently stores locally; future versions will sync via CloudKit.
final class ContinuityRecordStore: @unchecked Sendable {

    static let shared = ContinuityRecordStore()

    private let fileManager = FileManager.default
    private let queue = DispatchQueue(label: "com.continuitylabs.continuitycore", attributes: .concurrent)

    private var storeURL: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let continuityDir = appSupport.appendingPathComponent("ContinuityCore", isDirectory: true)

        // Ensure directory exists
        if !fileManager.fileExists(atPath: continuityDir.path) {
            try? fileManager.createDirectory(at: continuityDir, withIntermediateDirectories: true)
        }

        return continuityDir.appendingPathComponent("records.json")
    }

    private init() {}

    // MARK: - Save

    /// Saves a single record
    func save(_ record: ContinuityRecord) throws {
        try save([record])
    }

    /// Saves multiple records (merges with existing)
    func save(_ records: [ContinuityRecord]) throws {
        try queue.sync(flags: .barrier) {
            var existing = (try? loadAll()) ?? []

            // Merge: update existing records, add new ones
            for record in records {
                if let index = existing.firstIndex(where: { $0.id == record.id }) {
                    existing[index] = record
                } else {
                    existing.append(record)
                }
            }

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted

            let data = try encoder.encode(existing)
            try data.write(to: storeURL, options: .atomic)
        }
    }

    // MARK: - Fetch

    /// Loads all records
    func loadAll() throws -> [ContinuityRecord] {
        guard fileManager.fileExists(atPath: storeURL.path) else {
            return []
        }

        let data = try Data(contentsOf: storeURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([ContinuityRecord].self, from: data)
    }

    /// Fetches records from a specific app
    func fetch(from sourceApp: String) throws -> [ContinuityRecord] {
        try loadAll().filter { $0.sourceApp == sourceApp }
    }

    /// Fetches records involving a specific entity identifier
    func fetch(involving entityIdentifier: String) throws -> [ContinuityRecord] {
        try loadAll().filter { record in
            record.entities.contains { $0.identifier == entityIdentifier }
        }
    }

    /// Fetches records involving a specific entity type
    func fetch(entityType: EntityReference.EntityType) throws -> [ContinuityRecord] {
        try loadAll().filter { record in
            record.entities.contains { $0.type == entityType }
        }
    }

    /// Fetches records created within a date range
    func fetch(from startDate: Date, to endDate: Date) throws -> [ContinuityRecord] {
        try loadAll().filter { $0.createdAt >= startDate && $0.createdAt <= endDate }
    }

    // MARK: - Delete

    /// Deletes a record by ID
    func delete(id: UUID) throws {
        try queue.sync(flags: .barrier) {
            var existing = (try? loadAll()) ?? []
            existing.removeAll { $0.id == id }

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted

            let data = try encoder.encode(existing)
            try data.write(to: storeURL, options: .atomic)
        }
    }

    /// Deletes all records from a specific app
    func deleteAll(from sourceApp: String) throws {
        try queue.sync(flags: .barrier) {
            var existing = (try? loadAll()) ?? []
            existing.removeAll { $0.sourceApp == sourceApp }

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted

            let data = try encoder.encode(existing)
            try data.write(to: storeURL, options: .atomic)
        }
    }

    // MARK: - Stats

    /// Returns count of records by source app
    func recordCounts() throws -> [String: Int] {
        let records = try loadAll()
        var counts: [String: Int] = [:]
        for record in records {
            counts[record.sourceApp, default: 0] += 1
        }
        return counts
    }

    /// Returns all unique entity identifiers across all records
    func allEntityIdentifiers() throws -> Set<String> {
        let records = try loadAll()
        var identifiers: Set<String> = []
        for record in records {
            for entity in record.entities {
                identifiers.insert(entity.identifier)
            }
        }
        return identifiers
    }
}
