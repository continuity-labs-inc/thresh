import SwiftUI
import SwiftData

@main
struct VicariousMeApp: App {
    private let promptLibrary = PromptLibrary()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Reflection.self,
            Story.self,
            Idea.self,
            Question.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(promptLibrary)
        }
        .modelContainer(sharedModelContainer)
    }
}
