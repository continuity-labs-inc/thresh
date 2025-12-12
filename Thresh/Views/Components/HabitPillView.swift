import SwiftUI
import SwiftData

struct HabitPillView: View {
    @Bindable var habit: ActiveHabit

    var body: some View {
        HStack {
            Image(systemName: "flame")
                .foregroundColor(.orange)

            Text(habit.intention)
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textPrimary)
                .lineLimit(1)

            Spacer()

            Button(action: {
                if !habit.hasCheckedInToday {
                    habit.checkIn()
                }
            }) {
                Image(systemName: habit.hasCheckedInToday ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.hasCheckedInToday ? .green : .gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.thresh.cardBackground)
        .cornerRadius(20)
    }
}

#Preview {
    VStack(spacing: 20) {
        HabitPillView(habit: ActiveHabit(intention: "Reflect 3 times this week", isDefault: true))
        HabitPillView(habit: ActiveHabit(intention: "Move my body 3x/week"))
    }
    .padding()
    .modelContainer(for: ActiveHabit.self, inMemory: true)
}
