import Foundation
import UserNotifications

/// NotificationService manages local notifications for Thresh.
/// Uses a non-punishing tone that encourages reflection without pressure.
@MainActor
final class NotificationService {
    static let shared = NotificationService()

    // MARK: - Notification Identifiers

    static let dailyPromptId = "daily-prompt"
    static let weeklySynthesisId = "weekly-synthesis"
    static let inactivityReminderId = "inactivity-reminder"
    static func marinatingId(for reflectionId: UUID) -> String {
        "marinating-\(reflectionId.uuidString)"
    }

    // MARK: - Notification Content

    private let dailyPromptTitles = [
        "A moment to reflect",
        "Take a breath",
        "A quiet moment"
    ]

    private let dailyPromptBodies = [
        "What's been on your mind today?",
        "What did you notice today?",
        "What moment stood out?",
        "What are you curious about right now?",
        "What's worth capturing?"
    ]

    private init() {}

    // MARK: - Permission

    /// Request notification permission from the user.
    /// Returns true if permission was granted.
    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("❌ Failed to request notification permission: \(error)")
            return false
        }
    }

    /// Check current authorization status
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Daily Prompt

    /// Schedule a daily reflection prompt at the specified time.
    /// - Parameters:
    ///   - hour: Hour of day (0-23)
    ///   - minute: Minute of hour (0-59)
    func scheduleDailyPrompt(at hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()

        // Remove existing daily prompt
        center.removePendingNotificationRequests(withIdentifiers: [Self.dailyPromptId])

        let content = UNMutableNotificationContent()
        content.title = dailyPromptTitles.randomElement() ?? "A moment to reflect"
        content.body = dailyPromptBodies.randomElement() ?? "What's been on your mind today?"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: Self.dailyPromptId,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule daily prompt: \(error)")
            } else {
                print("✅ Daily prompt scheduled for \(hour):\(String(format: "%02d", minute))")
            }
        }
    }

    // MARK: - Weekly Synthesis Reminder

    /// Schedule a weekly synthesis reminder for Sunday.
    /// The notification encourages synthesis if the user has been active.
    /// - Parameter captureCount: Number of captures this week (shown in message)
    func scheduleWeeklySynthesisReminder(captureCount: Int = 0) {
        let center = UNUserNotificationCenter.current()

        // Remove existing weekly reminder
        center.removePendingNotificationRequests(withIdentifiers: [Self.weeklySynthesisId])

        // Only schedule if user has 3+ captures
        guard captureCount >= 3 else {
            print("⏭️ Skipping weekly synthesis reminder (only \(captureCount) captures)")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Weekly reflection"
        content.body = "You captured \(captureCount) moments this week. Ready to find the thread?"
        content.sound = .default

        // Schedule for Sunday at 10am
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 10
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: Self.weeklySynthesisId,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule weekly synthesis reminder: \(error)")
            } else {
                print("✅ Weekly synthesis reminder scheduled for Sunday 10am")
            }
        }
    }

    // MARK: - Inactivity Reminder

    /// Schedule a gentle reminder if the user hasn't captured anything for a while.
    /// - Parameter afterDays: Number of days of inactivity before reminder (default 7)
    func scheduleInactivityReminder(afterDays: Int = 7) {
        let center = UNUserNotificationCenter.current()

        // Remove existing inactivity reminder
        center.removePendingNotificationRequests(withIdentifiers: [Self.inactivityReminderId])

        let content = UNMutableNotificationContent()
        content.title = "Still here"
        content.body = "It's been a while. What's been on your mind?"
        content.sound = .default

        // Schedule for X days from now
        let triggerDate = Calendar.current.date(byAdding: .day, value: afterDays, to: Date()) ?? Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: Self.inactivityReminderId,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule inactivity reminder: \(error)")
            } else {
                print("✅ Inactivity reminder scheduled for \(afterDays) days from now")
            }
        }
    }

    /// Reset the inactivity reminder (call this when user creates a new reflection)
    func resetInactivityReminder(afterDays: Int = 7) {
        scheduleInactivityReminder(afterDays: afterDays)
    }

    // MARK: - Marinating Reminder

    /// Schedule a reminder for a reflection marked as "holding" (marinating).
    /// - Parameters:
    ///   - reflection: The reflection to remind about
    ///   - afterDays: Number of days before reminder (default 14)
    func scheduleMarinatingReminder(for reflectionId: UUID, afterDays: Int = 14) {
        let center = UNUserNotificationCenter.current()
        let identifier = Self.marinatingId(for: reflectionId)

        // Remove existing reminder for this reflection
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        let content = UNMutableNotificationContent()
        content.title = "Something you held"
        content.body = "You marked something as worth holding. Still resonating?"
        content.sound = .default
        content.userInfo = ["reflectionId": reflectionId.uuidString]

        // Schedule for X days from now at 6pm
        let triggerDate = Calendar.current.date(byAdding: .day, value: afterDays, to: Date()) ?? Date()
        var components = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
        components.hour = 18
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule marinating reminder: \(error)")
            } else {
                print("✅ Marinating reminder scheduled for \(afterDays) days from now")
            }
        }
    }

    /// Cancel a marinating reminder for a specific reflection
    func cancelMarinatingReminder(for reflectionId: UUID) {
        let center = UNUserNotificationCenter.current()
        let identifier = Self.marinatingId(for: reflectionId)
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("🗑️ Cancelled marinating reminder for \(reflectionId)")
    }

    // MARK: - Cancel

    /// Cancel a specific notification by identifier
    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    /// Cancel all pending notifications
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🗑️ All notifications cancelled")
    }

    /// Cancel only the daily prompt notification
    func cancelDailyPrompt() {
        cancelNotification(id: Self.dailyPromptId)
    }

    /// Cancel only the weekly synthesis reminder
    func cancelWeeklySynthesis() {
        cancelNotification(id: Self.weeklySynthesisId)
    }

    /// Cancel only the inactivity reminder
    func cancelInactivityReminder() {
        cancelNotification(id: Self.inactivityReminderId)
    }
}
