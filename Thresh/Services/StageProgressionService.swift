import Foundation
import SwiftData

@MainActor
@Observable
final class StageProgressionService {
    static let shared = StageProgressionService()

    private init() {}

    /// Update progress after a capture is saved
    func recordCapture(
        userProgress: UserProgress,
        reflection: Reflection,
        modelContext: ModelContext
    ) {
        userProgress.captureCount += 1
        userProgress.totalWordCount += reflection.captureContent.split(separator: " ").count

        if reflection.phase2Completed {
            userProgress.phase2CompletionCount += 1
        }

        // Update category last used
        if let category = reflection.promptCategory {
            userProgress.categoryLastUsed[category] = Date()
        }

        // Update domain distribution
        if let domain = reflection.promptDomain {
            userProgress.domainDistribution[domain, default: 0] += 1
        }

        // Check for linguistic signals
        let content = reflection.captureContent + (reflection.reflectionContent ?? "")
        userProgress.causalLanguageHits += countCausalLanguage(in: content)
        userProgress.perspectiveMarkerHits += countPerspectiveMarkers(in: content)

        // Check for stage advancement
        checkStageAdvancement(userProgress: userProgress)

        userProgress.updatedAt = Date()

        try? modelContext.save()
    }

    private func countCausalLanguage(in text: String) -> Int {
        let markers = ["because", "since", "as a result", "led to", "caused", "therefore", "so that"]
        let lowercased = text.lowercased()
        return markers.reduce(0) { count, marker in
            count + (lowercased.contains(marker) ? 1 : 0)
        }
    }

    private func countPerspectiveMarkers(in text: String) -> Int {
        let markers = ["might have", "could have", "probably thought", "from their", "from his", "from her", "would see it as", "might think"]
        let lowercased = text.lowercased()
        return markers.reduce(0) { count, marker in
            count + (lowercased.contains(marker) ? 1 : 0)
        }
    }

    private func checkStageAdvancement(userProgress: UserProgress) {
        let stage = userProgress.currentStage

        switch stage {
        case 1:
            // Stage 1 → 2: 5+ captures, 50+ avg words, 60%+ Phase 2 completion
            let avgWords = userProgress.captureCount > 0
                ? userProgress.totalWordCount / userProgress.captureCount
                : 0
            let phase2Rate = userProgress.captureCount > 0
                ? Double(userProgress.phase2CompletionCount) / Double(userProgress.captureCount)
                : 0

            if userProgress.captureCount >= 5 && avgWords >= 50 && phase2Rate >= 0.6 {
                advanceStage(userProgress: userProgress, to: 2)
            }

        case 2:
            // Stage 2 → 3: 15+ captures, 75+ avg words, causal language in 50%+
            let avgWords = userProgress.totalWordCount / max(userProgress.captureCount, 1)
            let causalRate = Double(userProgress.causalLanguageHits) / Double(max(userProgress.captureCount, 1))

            if userProgress.captureCount >= 15 && avgWords >= 75 && causalRate >= 0.5 {
                advanceStage(userProgress: userProgress, to: 3)
            }

        case 3:
            // Stage 3 → 4: 30+ captures, 100+ avg words, perspective markers in 40%+
            let avgWords = userProgress.totalWordCount / max(userProgress.captureCount, 1)
            let perspectiveRate = Double(userProgress.perspectiveMarkerHits) / Double(max(userProgress.captureCount, 1))

            if userProgress.captureCount >= 30 && avgWords >= 100 && perspectiveRate >= 0.4 {
                advanceStage(userProgress: userProgress, to: 4)
            }

        default:
            break
        }
    }

    private func advanceStage(userProgress: UserProgress, to newStage: Int) {
        userProgress.currentStage = newStage
        userProgress.stageAdvancedAt[newStage] = Date()
        // TODO: Trigger tooltip notification about stage advancement
    }
}
