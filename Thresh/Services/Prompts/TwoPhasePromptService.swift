import Foundation

@MainActor
@Observable
final class TwoPhasePromptService {
    static let shared = TwoPhasePromptService()

    private init() {}

    /// Select a Phase 1 prompt, weighted by time since last use
    func selectPhase1Prompt(
        userProgress: UserProgress,
        stage: Int
    ) -> (category: PromptCategory, prompt: String) {

        let category = selectCategory(lastUsed: userProgress.categoryLastUsed)
        let prompts = category.phase1Prompts
        let prompt = prompts.randomElement() ?? prompts[0]

        // Stage 1: Add example scaffolding
        if stage == 1 {
            return (category, prompt + "\n\nExample: \"My mom called and said 'I just wanted to hear your voice.' She always pauses before saying goodbye, like she's waiting for something.\"")
        }

        return (category, prompt)
    }

    /// Get Phase 2 prompt based on category and stage
    func getPhase2Prompt(
        category: PromptCategory,
        keyElement: String?,
        stage: Int
    ) -> String {

        switch stage {
        case 1:
            // Scaffolded, references their writing
            if let element = keyElement {
                return "You described \(element). \(category.phase2Prompt)"
            }
            return category.phase2Prompt
        case 2:
            return category.phase2Prompt
        case 3:
            return "What's the question here?"
        default:
            return "" // Stage 4: optional/none
        }
    }

    /// Select category weighted by time since last use
    private func selectCategory(lastUsed: [String: Date]) -> PromptCategory {
        let now = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!

        // Find categories not used in 7+ days
        var neglectedCategories: [PromptCategory] = []
        var recentCategories: [PromptCategory] = []

        for category in PromptCategory.allCases {
            if let lastDate = lastUsed[category.rawValue] {
                if lastDate < sevenDaysAgo {
                    neglectedCategories.append(category)
                } else {
                    recentCategories.append(category)
                }
            } else {
                // Never used = neglected
                neglectedCategories.append(category)
            }
        }

        // 70% chance to pick neglected category if any exist
        if !neglectedCategories.isEmpty && Double.random(in: 0...1) < 0.7 {
            return neglectedCategories.randomElement()!
        }

        // Otherwise random from all
        return PromptCategory.allCases.randomElement()!
    }
}
