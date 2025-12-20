import SwiftUI

struct CollapsedCaptureCard: View {
    let content: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("YOUR CAPTURE")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.thresh.textTertiary)

                Spacer()

                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.thresh.textTertiary)
                }
            }

            Text(content)
                .font(.system(size: 14))
                .foregroundColor(Color.thresh.textSecondary)
                .lineLimit(isExpanded ? nil : 2)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.thresh.surface)
        )
    }
}

#Preview {
    CollapsedCaptureCard(
        content: "My mom called and said 'I just wanted to hear your voice.' She always pauses before saying goodbye, like she's waiting for something. I noticed the slight tremor in her voice when she asked about work."
    )
    .padding()
    .background(Color.thresh.background)
}
