import SwiftUI

// MARK: - Onboarding Container

struct OnboardingScreen: View {
    @Environment(AppState.self) private var appState
    @Environment(\.typography) private var typography
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
    @Environment(\.typography) private var typography

    var body: some View {
        VStack(spacing: typography.isIPad ? 32 : 24) {
            Spacer()

            Image(systemName: "eyes")
                .font(.system(size: typography.isIPad ? 80 : 60))
                .foregroundStyle(Color.thresh.capture)

            Text("Thresh")
                .font(typography.largeTitle)
                .fontWeight(.bold)

            Text("See your life clearly.\nUnderstand it deeply.")
                .font(typography.title3)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, typography.horizontalPadding)
    }
}

// MARK: - Page 2: Two Modes (CRITICAL)

struct TwoModesPage: View {
    @Environment(\.typography) private var typography

    var body: some View {
        VStack(spacing: typography.isIPad ? 32 : 24) {
            Spacer()

            Text("Two Modes")
                .font(typography.title)
                .fontWeight(.bold)

            VStack(spacing: typography.isIPad ? 20 : 16) {
                // Capture Mode
                HStack(spacing: typography.isIPad ? 20 : 16) {
                    Image(systemName: "camera.fill")
                        .font(typography.title)
                        .foregroundStyle(Color.thresh.capture)
                        .frame(width: typography.isIPad ? 60 : 50)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Capture")
                            .font(typography.headline)
                            .foregroundStyle(Color.thresh.capture)
                        Text("Record what happened")
                            .font(typography.subheadline)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                    Spacer()
                }
                .padding(typography.isIPad ? 20 : 16)
                .background(Color.thresh.capture.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Arrow
                Image(systemName: "arrow.down")
                    .font(typography.title2)
                    .foregroundStyle(Color.thresh.textSecondary)

                // Synthesis Mode
                HStack(spacing: typography.isIPad ? 20 : 16) {
                    Image(systemName: "sparkles")
                        .font(typography.title)
                        .foregroundStyle(Color.thresh.synthesis)
                        .frame(width: typography.isIPad ? 60 : 50)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Synthesis")
                            .font(typography.headline)
                            .foregroundStyle(Color.thresh.synthesis)
                        Text("Find what it means")
                            .font(typography.subheadline)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                    Spacer()
                }
                .padding(typography.isIPad ? 20 : 16)
                .background(Color.thresh.synthesis.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(maxWidth: typography.isIPad ? 500 : .infinity)
            .padding(.horizontal, typography.isIPad ? 40 : 32)

            Text("Most apps blur these together.\nWe keep them separate.")
                .font(typography.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page 3: Observation Is Hard (THE INSIGHT)

struct ObservationIsHardPage: View {
    @Environment(\.typography) private var typography

    var body: some View {
        VStack(spacing: typography.isIPad ? 32 : 24) {
            Spacer()

            Text("Here's the surprising thing")
                .font(typography.title2)
                .fontWeight(.bold)

            VStack(spacing: typography.isIPad ? 28 : 20) {
                // Interpretation is easy
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.thresh.synthesis)
                        Text("Interpretation is easy")
                            .font(typography.body)
                            .fontWeight(.semibold)
                    }
                    Text("We do it automatically. The moment something happens, we're already deciding what it means.")
                        .font(typography.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                        .multilineTextAlignment(.center)
                }

                // Divider
                Rectangle()
                    .fill(Color.secondary.opacity(0.6))
                    .frame(height: 1)
                    .frame(maxWidth: typography.isIPad ? 400 : .infinity)
                    .padding(.horizontal, 40)

                // Observation is hard
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .foregroundStyle(Color.thresh.capture)
                        Text("Observation is hard")
                            .font(typography.body)
                            .fontWeight(.semibold)
                    }
                    Text("Staying with what happened—the details, the words, the sequence—without sliding into meaning? That takes discipline.")
                        .font(typography.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: typography.isIPad ? 600 : .infinity)
            .padding(.horizontal, typography.isIPad ? 40 : 24)

            // The point
            Text("Thresh trains observation first.\nIt's the harder skill—and the foundation.")
                .font(typography.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.thresh.capture)
                .multilineTextAlignment(.center)
                .padding(typography.isIPad ? 20 : 16)
                .background(Color.thresh.capture.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: typography.isIPad ? 500 : .infinity)
                .padding(.horizontal, typography.isIPad ? 40 : 24)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page 4: AI Philosophy

struct AIPhilosophyPage: View {
    @Environment(\.typography) private var typography

    var body: some View {
        VStack(spacing: typography.isIPad ? 32 : 24) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .font(.system(size: typography.isIPad ? 70 : 50))
                .foregroundStyle(Color.thresh.textSecondary)

            Text("AI extracts.\nIt never writes.")
                .font(typography.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: typography.isIPad ? 16 : 12) {
                AIFeatureRow(icon: "text.magnifyingglass", text: "Surfaces questions from your words")
                AIFeatureRow(icon: "link", text: "Finds connections you might miss")
                AIFeatureRow(icon: "eye", text: "Gives feedback on observation quality")
            }
            .frame(maxWidth: typography.isIPad ? 450 : .infinity, alignment: .leading)
            .padding(.horizontal, typography.isIPad ? 40 : 32)

            Text("The reflection is yours.\nAI is a mirror, not an author.")
                .font(typography.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
    }
}

struct AIFeatureRow: View {
    @Environment(\.typography) private var typography
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: typography.isIPad ? 16 : 12) {
            Image(systemName: icon)
                .frame(width: typography.isIPad ? 28 : 24)
                .foregroundStyle(Color.thresh.synthesis)
            Text(text)
                .font(typography.subheadline)
        }
    }
}

// MARK: - Page 5: Get Started

struct GetStartedPage: View {
    @Environment(\.typography) private var typography
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: typography.isIPad ? 40 : 32) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: typography.isIPad ? 80 : 60))
                .foregroundStyle(Color.thresh.capture)

            Text("Ready to begin")
                .font(typography.title)
                .fontWeight(.bold)

            Text("Start with a capture.\nMeaning can come later.")
                .font(typography.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: onComplete) {
                Text("Start Capturing")
                    .font(typography.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: typography.isIPad ? 400 : .infinity)
                    .padding(typography.isIPad ? 18 : 16)
                    .background(Color.thresh.capture)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, typography.isIPad ? 40 : 32)

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
