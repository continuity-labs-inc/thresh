import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
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
        }
    }
}
