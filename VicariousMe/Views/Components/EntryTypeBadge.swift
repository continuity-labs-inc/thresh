import SwiftUI

struct EntryTypeBadge: View {
    let type: EntryType

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundStyle(color)
    }

    private var icon: String {
        switch type {
        case .pureCapture: return "camera.fill"
        case .groundedReflection: return "arrow.right"
        case .synthesis: return "sparkles"
        }
    }

    private var label: String {
        switch type {
        case .pureCapture: return "CAPTURE"
        case .groundedReflection: return "GROUNDED"
        case .synthesis: return "SYNTHESIS"
        }
    }

    private var color: Color {
        switch type {
        case .pureCapture: return Color.vm.capture
        case .groundedReflection: return .primary
        case .synthesis: return Color.vm.synthesis
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        EntryTypeBadge(type: .pureCapture)
        EntryTypeBadge(type: .groundedReflection)
        EntryTypeBadge(type: .synthesis)
    }
    .padding()
}
