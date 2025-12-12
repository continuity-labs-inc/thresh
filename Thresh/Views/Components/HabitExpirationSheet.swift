import SwiftUI
import SwiftData

struct HabitExpirationSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    let habit: ActiveHabit
    let onDismiss: () -> Void

    @State private var newIntention: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Explanation
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your intention has completed its cycle")
                        .font(.headline)
                        .foregroundStyle(Color.thresh.textPrimary)

                    Text("'\(habit.intention)' has been with you for 39 days. What would you like to do?")
                        .font(.subheadline)
                        .foregroundColor(Color.thresh.textSecondary)
                }

                // Options
                VStack(spacing: 12) {
                    // Renew
                    Button(action: renewHabit) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(Color.thresh.capture)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Renew")
                                    .font(.headline)
                                    .foregroundStyle(Color.thresh.textPrimary)
                                Text("Keep the same intention for another 39 days")
                                    .font(.caption)
                                    .foregroundColor(Color.thresh.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.thresh.textTertiary)
                        }
                        .padding()
                        .background(Color.thresh.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    // Edit
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundColor(Color.thresh.synthesis)
                            Text("Edit")
                                .font(.headline)
                                .foregroundStyle(Color.thresh.textPrimary)
                        }

                        TextField("New intention...", text: $newIntention)
                            .textFieldStyle(.roundedBorder)

                        Button(action: editHabit) {
                            Text("Save New Intention")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(newIntention.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                              ? Color.thresh.surfaceSecondary
                                              : Color.thresh.synthesis)
                                )
                        }
                        .disabled(newIntention.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding()
                    .background(Color.thresh.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Complete
                    Button(action: completeHabit) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Complete")
                                    .font(.headline)
                                    .foregroundStyle(Color.thresh.textPrimary)
                                Text("Remove this intention and start fresh")
                                    .font(.caption)
                                    .foregroundColor(Color.thresh.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.thresh.textTertiary)
                        }
                        .padding()
                        .background(Color.thresh.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Intention Complete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Later") {
                        isPresented = false
                        onDismiss()
                    }
                }
            }
        }
    }

    private func renewHabit() {
        habit.startedAt = Date()
        habit.expiresAt = Calendar.current.date(byAdding: .day, value: 39, to: Date()) ?? Date()
        do {
            try modelContext.save()
        } catch {}
        isPresented = false
        onDismiss()
    }

    private func editHabit() {
        let trimmed = newIntention.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        habit.intention = trimmed
        habit.startedAt = Date()
        habit.expiresAt = Calendar.current.date(byAdding: .day, value: 39, to: Date()) ?? Date()
        habit.isDefault = false
        do {
            try modelContext.save()
        } catch {}
        isPresented = false
        onDismiss()
    }

    private func completeHabit() {
        modelContext.delete(habit)

        // Create new default habit
        let defaultHabit = ActiveHabit(
            intention: "Reflect 3 times this week",
            isDefault: true,
            order: 0
        )
        modelContext.insert(defaultHabit)

        do {
            try modelContext.save()
        } catch {}
        isPresented = false
        onDismiss()
    }
}

#Preview {
    HabitExpirationSheet(
        isPresented: .constant(true),
        habit: ActiveHabit(intention: "Move my body 3x/week"),
        onDismiss: {}
    )
    .modelContainer(for: ActiveHabit.self, inMemory: true)
}
