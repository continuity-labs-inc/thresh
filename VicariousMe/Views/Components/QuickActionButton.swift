import SwiftUI

struct QuickActionButton<Destination: View>: View {
    let title: String
    let icon: String
    let color: Color
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: color.opacity(0.6), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    NavigationStack {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickActionButton(
                title: "New Reflection",
                icon: "camera.fill",
                color: Color.vm.capture,
                destination: Text("Destination")
            )
            QuickActionButton(
                title: "New Story",
                icon: "book.fill",
                color: Color.vm.story,
                destination: Text("Destination")
            )
        }
        .padding()
    }
}
