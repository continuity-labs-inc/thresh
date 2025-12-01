import SwiftUI
import SwiftData

@main
struct VicariousMeApp: App {
    @State private var appState = AppState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // SwiftData models will be added here
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .modelContainer(sharedModelContainer)
        }
    }
}

struct ContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        TabView(selection: $state.currentMode) {
            CaptureView()
                .tabItem {
                    Label("Capture", systemImage: "pencil.line")
                }
                .tag(ReflectionMode.capture)

            SynthesisView()
                .tabItem {
                    Label("Synthesis", systemImage: "sparkles")
                }
                .tag(ReflectionMode.synthesis)
        }
        .tint(appState.currentMode == .capture ? Color.vm.capture : Color.vm.synthesis)
    }
}

struct OnboardingView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundStyle(Color.vm.synthesis)

            Text("Welcome to Vicarious Me")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your personal reflection companion")
                .font(.title3)
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                withAnimation {
                    appState.hasCompletedOnboarding = true
                }
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.vm.capture)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .background(Color.vm.background)
    }
}

struct CaptureView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Capture your thoughts")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.vm.background)
            .navigationTitle("Capture")
        }
    }
}

struct SynthesisView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Review and synthesize")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.vm.background)
            .navigationTitle("Synthesis")
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
