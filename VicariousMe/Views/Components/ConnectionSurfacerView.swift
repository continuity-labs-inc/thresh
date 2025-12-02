import SwiftUI

/// Displays AI-detected connections between reflections.
/// Presented as a sheet to help users see patterns.
struct ConnectionSurfacerView: View {
    @Environment(\.dismiss) private var dismiss
    let connections: [Connection]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header explanation
                    VStack(spacing: 8) {
                        Image(systemName: "link.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.vm.synthesis)

                        Text("Detected Connections")
                            .font(.headline)

                        Text("These patterns emerged from your captures. Consider them as starting points for synthesis, not conclusions.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()

                    Divider()

                    // Connection list
                    if connections.isEmpty {
                        emptyState
                    } else {
                        ForEach(connections) { connection in
                            ConnectionCard(connection: connection)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Connections")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "puzzlepiece")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("No connections detected yet")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("As you add more captures, patterns will emerge.")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
}

/// A card displaying a single connection
struct ConnectionCard: View {
    let connection: Connection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Connection type badge
            HStack(spacing: 6) {
                Image(systemName: connection.connectionType.systemImage)
                    .font(.caption)

                Text(connection.connectionType.displayName)
                    .font(.caption)
                    .fontWeight(.medium)

                Spacer()

                // Confidence indicator
                ConfidenceIndicator(confidence: connection.confidence)
            }
            .foregroundStyle(Color.vm.synthesis)

            // Description
            Text(connection.description)
                .font(.subheadline)
                .foregroundStyle(.primary)

            // Type description
            Text(connection.connectionType.description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.vm.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

/// Visual indicator of AI confidence level
struct ConfidenceIndicator: View {
    let confidence: Double

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(index < confidenceLevel ? Color.vm.synthesis : Color.vm.synthesis.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }

    private var confidenceLevel: Int {
        if confidence >= 0.8 { return 3 }
        if confidence >= 0.5 { return 2 }
        return 1
    }
}

#Preview {
    ConnectionSurfacerView(connections: [
        Connection(
            sourceReflectionId: UUID(),
            targetReflectionId: UUID(),
            connectionType: .thematic,
            description: "Shared themes: growth, learning, challenge",
            confidence: 0.8
        ),
        Connection(
            sourceReflectionId: UUID(),
            targetReflectionId: UUID(),
            connectionType: .evolution,
            description: "This idea seems to have evolved over 3 days",
            confidence: 0.6
        )
    ])
}
