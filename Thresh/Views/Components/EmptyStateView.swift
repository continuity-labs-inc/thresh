import SwiftUI

struct EmptyStateView: View {
    let tab: HomeScreen.ContentTab

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(color)

            Text(title)
                .font(.headline)
                .foregroundStyle(Color.thresh.textPrimary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity)
    }

    private var icon: String {
        switch tab {
        case .reflections: return "camera"
        case .stories: return "book"
        case .ideas: return "lightbulb"
        case .questions: return "questionmark.circle"
        }
    }

    private var color: Color {
        switch tab {
        case .reflections: return Color.thresh.capture
        case .stories: return Color.thresh.story
        case .ideas: return Color.thresh.idea
        case .questions: return Color.thresh.question
        }
    }

    private var title: String {
        switch tab {
        case .reflections: return "No Reflections Yet"
        case .stories: return "No Stories Yet"
        case .ideas: return "No Ideas Yet"
        case .questions: return "No Questions Yet"
        }
    }

    private var subtitle: String {
        switch tab {
        case .reflections: return "Capture your first moment to begin your reflection journey"
        case .stories: return "Write your first story to preserve meaningful experiences"
        case .ideas: return "Jot down your first idea to start building your collection"
        case .questions: return "Ask your first question to explore deeper insights"
        }
    }
}

#Preview {
    VStack {
        EmptyStateView(tab: .reflections)
        EmptyStateView(tab: .ideas)
    }
    .background(Color.thresh.background)
}
