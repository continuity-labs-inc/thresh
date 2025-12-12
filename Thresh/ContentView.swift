import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt) private var allReflections: [Reflection]
    @State private var appState = AppState()
    @State private var designNotesService: DesignNotesService?

    var body: some View {
        Group {
            if let service = designNotesService {
                if appState.hasCompletedOnboarding {
                    HomeScreen()
                        .environment(service)
                        .environment(appState)
                } else {
                    OnboardingScreen()
                        .environment(appState)
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if designNotesService == nil {
                designNotesService = DesignNotesService(modelContext: modelContext)
            }
            seedDefaultHabitIfNeeded()
            migrateReflectionNumbers()
        }
    }

    private func seedDefaultHabitIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: "hasSeededDefaultHabit") else { return }

        let defaultHabit = ActiveHabit(
            intention: "Reflect 3 times this week",
            isDefault: true,
            order: 0
        )
        modelContext.insert(defaultHabit)

        do {
            try modelContext.save()
            UserDefaults.standard.set(true, forKey: "hasSeededDefaultHabit")
        } catch {
            // Silently fail - will try again next launch
        }
    }

    private func migrateReflectionNumbers() {
        // Migrate existing reflections to have sequential numbers
        let unnumberedReflections = allReflections
            .filter { $0.reflectionNumber == 0 }
            .sorted { $0.createdAt < $1.createdAt }

        guard !unnumberedReflections.isEmpty else { return }

        for (index, reflection) in unnumberedReflections.enumerated() {
            reflection.reflectionNumber = index + 1
        }

        do {
            try modelContext.save()
        } catch {
            // Silently fail
        }
    }
}
