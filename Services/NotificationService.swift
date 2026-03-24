import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    /// Fires at 7pm if score < 50% — streak warning
    func scheduleStreakWarning() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["grindcheck.streak.warning"])

        let content = UNMutableNotificationContent()
        content.title = "Your streak is on the line 🔥"
        content.body = "You're under 50% output today. Don't let the day slide."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "grindcheck.streak.warning",
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    func scheduleDailyReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["grindcheck.daily"])

        let content = UNMutableNotificationContent()
        content.title = "Time to grind ⚡"
        content.body = "Your daily stack is waiting. Ship something today."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "grindcheck.daily",
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
