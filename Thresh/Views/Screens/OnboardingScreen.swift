import SwiftUI

// MARK: - Onboarding Container

struct OnboardingScreen: View {
    @Environment(AppState.self) private var appState
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            WelcomePage()
                .tag(0)
            TwoModesPage()
                .tag(1)
            ObservationIsHardPage()
                .tag(2)
            AIPhilosophyPage()
                .tag(3)
            GetStartedPage(onComplete: completeOnboarding)
                .tag(4)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private func completeOnboarding() {
        appState.hasCompletedOnboarding = true
    }
}

// MARK: - Page 1: Welcome

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "eyes")
                .font(.system(size: 60))
                .foregroundStyle(Color.thresh.capture)

            Text("Thresh")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("See your life clearly.\nUnderstand it deeply.")
                .font(.title3)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page 2: Two Modes (CRITICAL)

struct TwoModesPage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Two Modes")
                .font(.title)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                // Capture Mode
                HStack(spacing: 16) {
                    Image(systemName: "camera.fill")
                        .font(.title)
                        .foregroundStyle(Color.thresh.capture)
                        .frame(width: 50)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Capture")
                            .font(.headline)
                            .foregroundStyle(Color.thresh.capture)
                        Text("Record what happened")
                            .font(.subheadline)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.thresh.capture.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Arrow
                Image(systemName: "arrow.down")
                    .font(.title2)
                    .foregroundStyle(Color.thresh.textSecondary)

                // Synthesis Mode
                HStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.title)
                        .foregroundStyle(Color.thresh.synthesis)
                        .frame(width: 50)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Synthesis")
                            .font(.headline)
                            .foregroundStyle(Color.thresh.synthesis)
                        Text("Find what it means")
                            .font(.subheadline)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.thresh.synthesis.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)

            Text("Most apps blur these together.\nWe keep them separate.")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page 3: Observation Is Hard (THE INSIGHT)

struct ObservationIsHardPage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Here's the surprising thing")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 20) {
                // Interpretation is easy
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.thresh.synthesis)
                        Text("Interpretation is easy")
                            .fontWeight(.semibold)
                    }
                    Text("We do it automatically. The moment something happens, we're already deciding what it means.")
                        .font(.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                        .multilineTextAlignment(.center)
                }

                // Divider
                Rectangle()
                    .fill(Color.secondary.opacity(0.6))
                    .frame(height: 1)
                    .padding(.horizontal, 40)

                // Observation is hard
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .foregroundStyle(Color.thresh.capture)
                        Text("Observation is hard")
                            .fontWeight(.semibold)
                    }
                    Text("Staying with what happened—the details, the words, the sequence—without sliding into meaning? That takes discipline.")
                        .font(.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)

            // The point
            Text("Thresh trains observation first.\nIt's the harder skill—and the foundation.")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.thresh.capture)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.thresh.capture.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 24)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page 4: AI Philosophy

struct AIPhilosophyPage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .font(.system(size: 50))
                .foregroundStyle(Color.thresh.textSecondary)

            Text("AI extracts.\nIt never writes.")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 12) {
                AIFeatureRow(icon: "text.magnifyingglass", text: "Surfaces questions from your words")
                AIFeatureRow(icon: "link", text: "Finds connections you might miss")
                AIFeatureRow(icon: "eye", text: "Gives feedback on observation quality")
            }
            .padding(.horizontal, 32)

            Text("The reflection is yours.\nAI is a mirror, not an author.")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
    }
}

struct AIFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(Color.thresh.synthesis)
            Text(text)
                .font(.subheadline)
        }
    }
}

// MARK: - Page 5: Get Started

struct GetStartedPage: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.thresh.capture)

            Text("Ready to begin")
                .font(.title)
                .fontWeight(.bold)

            Text("Start with a capture.\nMeaning can come later.")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: onComplete) {
                Text("Start Capturing")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.thresh.capture)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Onboarding Flow") {
    OnboardingScreen()
        .environment(AppState())
}

#Preview("Welcome Page") {
    WelcomePage()
}

#Preview("Two Modes Page") {
    TwoModesPage()
}

#Preview("Observation Is Hard Page") {
    ObservationIsHardPage()
}

#Preview("AI Philosophy Page") {
    AIPhilosophyPage()
}

#Preview("Get Started Page") {
    GetStartedPage(onComplete: {})
}
