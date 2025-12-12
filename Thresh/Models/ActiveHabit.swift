import Foundation
import SwiftData

@Model
final class ActiveHabit {
    var id: UUID
    var intention: String
    var startedAt: Date
    var checkIns: [Date]
    var expiresAt: Date
    var isDefault: Bool
    var order: Int

    init(
        id: UUID = UUID(),
        intention: String,
        isDefault: Bool = false,
        order: Int = 0
    ) {
        self.id = id
        self.intention = intention
        self.startedAt = Date()
        self.checkIns = []
        self.expiresAt = Calendar.current.date(byAdding: .day, value: 39, to: Date()) ?? Date()
        self.isDefault = isDefault
        self.order = order
    }

    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: expiresAt).day ?? 0
    }

    var isExpired: Bool {
        Date() >= expiresAt
    }

    var checkInCountThisWeek: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return checkIns.filter { $0 >= weekAgo }.count
    }

    func checkIn() {
        checkIns.append(Date())
    }

    var hasCheckedInToday: Bool {
        guard let lastCheckIn = checkIns.last else { return false }
        return Calendar.current.isDateInToday(lastCheckIn)
    }
}
