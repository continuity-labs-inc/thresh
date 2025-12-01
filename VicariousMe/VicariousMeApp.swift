import SwiftUI
import SwiftData

@main
struct VicariousMeApp: App {
    /// Shared model container for SwiftData
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Reflection.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    /// App-wide state for deep link handling
    @State private var showQuickCapture = false

    var body: some Scene {
        WindowGroup {
            ContentView(showQuickCapture: $showQuickCapture)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }

    /// Handle deep links from widgets and shortcuts
    private func handleDeepLink(_ url: URL) {
        // URL scheme: vicariousme://quickcapture
        if url.host == "quickcapture" {
            showQuickCapture = true
        }
    }
}

// MARK: - Content View (Root Navigation)

struct ContentView: View {
    @Binding var showQuickCapture: Bool

    var body: some View {
        HomeScreen()
            .sheet(isPresented: $showQuickCapture) {
                NavigationStack {
                    QuickCaptureScreen()
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    showQuickCapture = false
                                }
                            }
                        }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
    }
}
