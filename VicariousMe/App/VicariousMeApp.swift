import SwiftUI

@main
struct VicariousMeApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                ContentView()
                    .environment(appState)
            } else {
                OnboardingScreen()
                    .environment(appState)
            }
        }
    }
}

// MARK: - Placeholder Content View

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "eyes")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.vm.capture)

                Text("Vicarious Me")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Main app content coming soon")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
