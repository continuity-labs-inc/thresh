//
//  EntityExtractor.swift
//  Thresh
//
//  Extracts entities (people, concepts, places) from reflection content.
//  Uses on-device NaturalLanguage framework with optional AI enhancement.
//

import Foundation
import NaturalLanguage

// MARK: - Extracted Entities

/// Container for all entities extracted from text
struct ExtractedEntities: Codable, Sendable {
    let people: [ExtractedPerson]
    let concepts: [ExtractedConcept]
    let places: [ExtractedPlace]
    let questions: [String]
    let commitments: [String]
    let keyExcerpt: String?

    static let empty = ExtractedEntities(
        people: [],
        concepts: [],
        places: [],
        questions: [],
        commitments: [],
        keyExcerpt: nil
    )
}

/// A person mentioned in the text
struct ExtractedPerson: Codable, Sendable, Hashable {
    let name: String
    let identifier: String
    let context: String?       // The phrase/sentence where they appeared
    let valence: String?       // Emotional tone: "grateful", "frustrated", "tender", etc.
    let relationship: String?  // Inferred: "family", "friend", "colleague", "other"
}

/// A concept or theme extracted from text
struct ExtractedConcept: Codable, Sendable, Hashable {
    let name: String
    let identifier: String
    let salience: Double       // 0.0 to 1.0, how central to the text
}

/// A place mentioned in the text
struct ExtractedPlace: Codable, Sendable, Hashable {
    let name: String
    let identifier: String
    let context: String?
}

// MARK: - Entity Extractor

/// Service for extracting entities from reflection content
final class EntityExtractor {

    static let shared = EntityExtractor()

    private let tagger: NLTagger
    private let sentenceTokenizer: NLTokenizer

    private init() {
        tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass, .lemma])
        sentenceTokenizer = NLTokenizer(unit: .sentence)
    }

    // MARK: - Main Extraction

    /// Extract all entities from reflection content
    /// - Parameters:
    ///   - captureContent: Phase 1 content (what happened)
    ///   - reflectionContent: Phase 2 content (why it matters), optional
    ///   - synthesisContent: Synthesis content, optional
    /// - Returns: Extracted entities
    func extract(
        captureContent: String,
        reflectionContent: String? = nil,
        synthesisContent: String? = nil
    ) -> ExtractedEntities {

        // Combine all content for extraction
        var allContent = captureContent
        if let reflection = reflectionContent, !reflection.isEmpty {
            allContent += "\n\n" + reflection
        }
        if let synthesis = synthesisContent, !synthesis.isEmpty {
            allContent += "\n\n" + synthesis
        }

        // Extract each entity type
        let people = extractPeople(from: allContent)
        let concepts = extractConcepts(from: allContent)
        let places = extractPlaces(from: allContent)
        let questions = extractQuestions(from: allContent)
        let commitments = extractCommitments(from: allContent)
        let keyExcerpt = extractKeyExcerpt(from: captureContent, reflection: reflectionContent)

        return ExtractedEntities(
            people: people,
            concepts: concepts,
            places: places,
            questions: questions,
            commitments: commitments,
            keyExcerpt: keyExcerpt
        )
    }

    // MARK: - People Extraction

    /// Extract people mentioned in text using NER + pattern matching
    private func extractPeople(from text: String) -> [ExtractedPerson] {
        var people: [ExtractedPerson] = []
        var seenNames = Set<String>()

        tagger.string = text

        // Use NaturalLanguage framework for named entity recognition
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType,
            options: [.omitPunctuation, .omitWhitespace, .joinNames]
        ) { tag, tokenRange in

            if tag == .personalName {
                let name = String(text[tokenRange])
                let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

                // Skip if already seen or too short
                guard !seenNames.contains(normalizedName.lowercased()),
                      normalizedName.count >= 2 else {
                    return true
                }

                seenNames.insert(normalizedName.lowercased())

                // Get surrounding context
                let context = extractSentenceContext(for: tokenRange, in: text)

                // Infer valence from context
                let valence = inferValence(from: context)

                // Infer relationship type
                let relationship = inferRelationship(from: context, name: normalizedName)

                let person = ExtractedPerson(
                    name: normalizedName,
                    identifier: normalizedName.lowercased().replacingOccurrences(of: " ", with: "-"),
                    context: context,
                    valence: valence,
                    relationship: relationship
                )

                people.append(person)
            }

            return true
        }

        // Also check for relationship patterns that NER might miss
        people.append(contentsOf: extractRelationshipPatterns(from: text, excluding: seenNames))

        return people
    }

    /// Extract people from relationship patterns like "my mom", "my friend Sarah"
    private func extractRelationshipPatterns(from text: String, excluding seen: Set<String>) -> [ExtractedPerson] {
        var people: [ExtractedPerson] = []

        let patterns: [(pattern: String, relationship: String)] = [
            // Family
            ("my (mom|mother|mama)", "family"),
            ("my (dad|father|papa)", "family"),
            ("my (brother|sister|sibling)", "family"),
            ("my (son|daughter|child|kid)", "family"),
            ("my (wife|husband|spouse|partner)", "family"),
            ("my (grandmother|grandfather|grandma|grandpa|grandparent)", "family"),
            ("my (aunt|uncle|cousin)", "family"),

            // Friends and colleagues
            ("my friend ([A-Z][a-z]+)", "friend"),
            ("my (friend|buddy|pal)", "friend"),
            ("my (boss|manager|supervisor)", "colleague"),
            ("my (coworker|colleague|teammate)", "colleague"),
            ("my (therapist|counselor|coach)", "professional"),
            ("my (doctor|physician)", "professional"),
        ]

        for (pattern, relationship) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(text.startIndex..., in: text)
                let matches = regex.matches(in: text, options: [], range: range)

                for match in matches {
                    if let matchRange = Range(match.range, in: text) {
                        let matchedText = String(text[matchRange])
                        let normalizedName = matchedText.trimmingCharacters(in: .whitespacesAndNewlines)

                        guard !seen.contains(normalizedName.lowercased()) else { continue }

                        // Try to get a proper name from capture group
                        var displayName = normalizedName
                        if match.numberOfRanges > 1,
                           let captureRange = Range(match.range(at: 1), in: text) {
                            let captured = String(text[captureRange])
                            // Check if it's a proper name (capitalized) or just a role
                            if captured.first?.isUppercase == true && captured.count > 2 {
                                displayName = captured
                            }
                        }

                        let context = extractSentenceContext(for: matchRange, in: text)
                        let valence = inferValence(from: context)

                        let person = ExtractedPerson(
                            name: displayName,
                            identifier: displayName.lowercased().replacingOccurrences(of: " ", with: "-"),
                            context: context,
                            valence: valence,
                            relationship: relationship
                        )

                        people.append(person)
                    }
                }
            }
        }

        return people
    }

    // MARK: - Concepts Extraction

    /// Extract key concepts/themes from text
    private func extractConcepts(from text: String) -> [ExtractedConcept] {
        var conceptCounts: [String: Int] = [:]
        var concepts: [ExtractedConcept] = []

        tagger.string = text

        // Extract nouns and noun phrases that might be concepts
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .lexicalClass,
            options: [.omitPunctuation, .omitWhitespace]
        ) { tag, tokenRange in

            if tag == .noun || tag == .verb {
                // Get lemma (base form) for better matching
                let lemma = tagger.tag(at: tokenRange.lowerBound, unit: .word, scheme: .lemma).0?.rawValue
                let word = lemma ?? String(text[tokenRange]).lowercased()

                // Skip very short words and common words
                guard word.count >= 4,
                      !Self.stopWords.contains(word) else {
                    return true
                }

                conceptCounts[word, default: 0] += 1
            }

            return true
        }

        // Also look for known concept patterns
        let abstractConcepts = extractAbstractConcepts(from: text)
        for concept in abstractConcepts {
            conceptCounts[concept, default: 0] += 2 // Boost abstract concepts
        }

        // Convert to ExtractedConcept with salience scores
        let totalMentions = conceptCounts.values.reduce(0, +)
        guard totalMentions > 0 else { return [] }

        for (concept, count) in conceptCounts.sorted(by: { $0.value > $1.value }).prefix(10) {
            let salience = Double(count) / Double(totalMentions)

            // Only include if mentioned more than once or is an abstract concept
            guard count > 1 || abstractConcepts.contains(concept) else { continue }

            concepts.append(ExtractedConcept(
                name: concept.capitalized,
                identifier: concept.lowercased().replacingOccurrences(of: " ", with: "-"),
                salience: min(salience * 2, 1.0) // Scale up but cap at 1.0
            ))
        }

        return concepts
    }

    /// Look for abstract concepts related to growth, relationships, emotions
    private func extractAbstractConcepts(from text: String) -> Set<String> {
        var found = Set<String>()
        let lowercased = text.lowercased()

        for concept in Self.meaningfulConcepts {
            if lowercased.contains(concept) {
                found.insert(concept)
            }
        }

        return found
    }

    // MARK: - Places Extraction

    /// Extract places mentioned in text
    private func extractPlaces(from text: String) -> [ExtractedPlace] {
        var places: [ExtractedPlace] = []
        var seenPlaces = Set<String>()

        tagger.string = text

        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType,
            options: [.omitPunctuation, .omitWhitespace, .joinNames]
        ) { tag, tokenRange in

            if tag == .placeName {
                let name = String(text[tokenRange])
                let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !seenPlaces.contains(normalizedName.lowercased()),
                      normalizedName.count >= 2 else {
                    return true
                }

                seenPlaces.insert(normalizedName.lowercased())

                let context = extractSentenceContext(for: tokenRange, in: text)

                places.append(ExtractedPlace(
                    name: normalizedName,
                    identifier: normalizedName.lowercased().replacingOccurrences(of: " ", with: "-"),
                    context: context
                ))
            }

            return true
        }

        return places
    }

    // MARK: - Questions Extraction

    /// Extract questions the user is asking themselves
    private func extractQuestions(from text: String) -> [String] {
        var questions: [String] = []

        sentenceTokenizer.string = text
        sentenceTokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            let sentence = String(text[tokenRange]).trimmingCharacters(in: .whitespacesAndNewlines)

            // Direct questions
            if sentence.hasSuffix("?") {
                questions.append(sentence)
            }
            // Indirect questions
            else if sentence.lowercased().hasPrefix("i wonder") ||
                    sentence.lowercased().hasPrefix("i'm wondering") ||
                    sentence.lowercased().hasPrefix("i ask myself") ||
                    sentence.lowercased().contains("the question is") {
                questions.append(sentence)
            }

            return true
        }

        return questions
    }

    // MARK: - Commitments Extraction

    /// Extract commitments or intentions
    private func extractCommitments(from text: String) -> [String] {
        var commitments: [String] = []

        sentenceTokenizer.string = text
        sentenceTokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            let sentence = String(text[tokenRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            let lowercased = sentence.lowercased()

            // Commitment patterns
            let commitmentPatterns = [
                "i want to",
                "i need to",
                "i'm going to",
                "i will",
                "i commit to",
                "i promise",
                "i intend to",
                "my goal is",
                "i'm committed to",
                "i plan to",
                "i should",
                "i must"
            ]

            for pattern in commitmentPatterns {
                if lowercased.contains(pattern) {
                    commitments.append(sentence)
                    break
                }
            }

            return true
        }

        return commitments
    }

    // MARK: - Key Excerpt Extraction

    /// Extract the most meaningful sentence from the content
    private func extractKeyExcerpt(from capture: String, reflection: String?) -> String? {
        // Prefer reflection content if available (the "why" is often more meaningful)
        let primaryText = (reflection?.isEmpty == false) ? reflection! : capture

        var bestSentence: String?
        var bestScore: Double = 0

        sentenceTokenizer.string = primaryText
        sentenceTokenizer.enumerateTokens(in: primaryText.startIndex..<primaryText.endIndex) { tokenRange, _ in
            let sentence = String(primaryText[tokenRange]).trimmingCharacters(in: .whitespacesAndNewlines)

            // Skip very short or very long sentences
            guard sentence.count >= 30 && sentence.count <= 300 else {
                return true
            }

            let score = scoreSentence(sentence)
            if score > bestScore {
                bestScore = score
                bestSentence = sentence
            }

            return true
        }

        return bestSentence
    }

    /// Score a sentence for meaningfulness
    private func scoreSentence(_ sentence: String) -> Double {
        var score: Double = 0
        let lowercased = sentence.lowercased()

        // Contains meaningful concepts
        for concept in Self.meaningfulConcepts {
            if lowercased.contains(concept) {
                score += 2
            }
        }

        // First person reflection
        if lowercased.contains("i realize") || lowercased.contains("i noticed") ||
           lowercased.contains("i feel") || lowercased.contains("i think") {
            score += 3
        }

        // Insight markers
        if lowercased.contains("because") || lowercased.contains("which means") ||
           lowercased.contains("i understand") || lowercased.contains("now i see") {
            score += 4
        }

        // Question (curiosity)
        if sentence.hasSuffix("?") {
            score += 2
        }

        // Contains a person
        tagger.string = sentence
        tagger.enumerateTags(in: sentence.startIndex..<sentence.endIndex, unit: .word, scheme: .nameType, options: []) { tag, _ in
            if tag == .personalName {
                score += 2
            }
            return true
        }

        // Moderate length is good
        if sentence.count >= 50 && sentence.count <= 150 {
            score += 1
        }

        return score
    }

    // MARK: - Context Helpers

    /// Get the sentence containing a token range
    private func extractSentenceContext(for tokenRange: Range<String.Index>, in text: String) -> String? {
        sentenceTokenizer.string = text

        var containingSentence: String?

        sentenceTokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { sentenceRange, _ in
            if sentenceRange.overlaps(tokenRange) {
                containingSentence = String(text[sentenceRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                return false // Stop enumeration
            }
            return true
        }

        // Truncate if too long
        if let sentence = containingSentence, sentence.count > 200 {
            return String(sentence.prefix(197)) + "..."
        }

        return containingSentence
    }

    /// Infer emotional valence from context
    private func inferValence(from context: String?) -> String? {
        guard let context = context?.lowercased() else { return nil }

        let valencePatterns: [(keywords: [String], valence: String)] = [
            (["grateful", "thankful", "appreciate", "blessed", "lucky"], "grateful"),
            (["frustrated", "annoyed", "irritated", "angry", "upset"], "frustrated"),
            (["tender", "soft", "gentle", "warm", "loving"], "tender"),
            (["worried", "anxious", "concerned", "nervous", "afraid"], "worried"),
            (["sad", "grief", "loss", "miss", "mourning"], "grieving"),
            (["proud", "accomplished", "achieved", "success"], "proud"),
            (["confused", "uncertain", "unsure", "unclear"], "uncertain"),
            (["hopeful", "optimistic", "excited", "looking forward"], "hopeful"),
            (["guilty", "regret", "sorry", "ashamed"], "remorseful"),
            (["peaceful", "calm", "serene", "content"], "peaceful")
        ]

        for (keywords, valence) in valencePatterns {
            for keyword in keywords {
                if context.contains(keyword) {
                    return valence
                }
            }
        }

        return nil
    }

    /// Infer relationship type from context
    private func inferRelationship(from context: String?, name: String) -> String? {
        guard let context = context?.lowercased() else { return nil }

        let relationshipPatterns: [(keywords: [String], relationship: String)] = [
            (["mom", "dad", "mother", "father", "parent", "brother", "sister", "son", "daughter", "family", "wife", "husband", "spouse"], "family"),
            (["friend", "buddy", "pal"], "friend"),
            (["boss", "manager", "coworker", "colleague", "team", "work", "office"], "colleague"),
            (["therapist", "counselor", "coach", "mentor"], "professional"),
            (["neighbor", "community"], "community")
        ]

        for (keywords, relationship) in relationshipPatterns {
            for keyword in keywords {
                if context.contains(keyword) {
                    return relationship
                }
            }
        }

        return nil
    }

    // MARK: - Word Lists

    /// Common words to skip in concept extraction
    private static let stopWords: Set<String> = [
        "this", "that", "these", "those", "there", "here",
        "what", "which", "where", "when", "while",
        "have", "having", "been", "being", "would", "could", "should",
        "about", "after", "before", "between", "into", "through",
        "just", "only", "very", "really", "actually", "probably",
        "thing", "things", "something", "anything", "everything",
        "time", "times", "today", "yesterday", "tomorrow",
        "make", "made", "making", "take", "took", "taking",
        "come", "came", "coming", "going", "went", "gone",
        "know", "knew", "think", "thought", "feel", "felt",
        "want", "need", "like", "seem", "look", "find",
        "give", "gave", "tell", "told", "said", "saying",
        "people", "person", "someone", "anyone", "everyone",
        "much", "many", "more", "most", "some", "other",
        "first", "last", "next", "same", "different",
        "good", "well", "better", "best", "back"
    ]

    /// Abstract concepts related to growth and relationships
    private static let meaningfulConcepts: Set<String> = [
        // Growth and development
        "patience", "growth", "learning", "understanding", "wisdom",
        "change", "progress", "development", "transformation", "becoming",

        // Relationships
        "trust", "connection", "intimacy", "vulnerability", "boundaries",
        "communication", "listening", "presence", "attention", "care",

        // Emotions and inner life
        "grief", "loss", "healing", "acceptance", "forgiveness",
        "gratitude", "joy", "peace", "contentment", "fulfillment",
        "anxiety", "fear", "courage", "hope", "faith",

        // Values and meaning
        "purpose", "meaning", "values", "integrity", "authenticity",
        "service", "contribution", "legacy", "calling", "vocation",

        // Challenges
        "struggle", "challenge", "obstacle", "difficulty", "conflict",
        "tension", "balance", "priorities", "decisions", "choices",

        // Self-knowledge
        "identity", "self", "awareness", "reflection", "insight",
        "pattern", "habit", "tendency", "strength", "weakness"
    ]
}
