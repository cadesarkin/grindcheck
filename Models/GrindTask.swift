import Foundation
import SwiftData

@Model
final class GrindTask {
    var id: UUID
    var name: String
    var emoji: String
    var category: String
    var pointValue: Int
    var isCompletedToday: Bool
    var completionDates: [Date]
    var createdAt: Date
    var sortOrder: Int

    init(
        name: String,
        emoji: String,
        category: String,
        pointValue: Int,
        sortOrder: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.category = category
        self.pointValue = pointValue
        self.isCompletedToday = false
        self.completionDates = []
        self.createdAt = Date()
        self.sortOrder = sortOrder
    }

    func markCompleted() {
        let today = Date()
        let calendar = Calendar.current
        guard !completionDates.contains(where: { calendar.isDate($0, inSameDayAs: today) }) else { return }
        completionDates.append(today)
        isCompletedToday = true
    }

    func resetDailyStatus() {
        let calendar = Calendar.current
        isCompletedToday = completionDates.contains { calendar.isDate($0, inSameDayAs: Date()) }
    }

    func wasCompletedOn(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return completionDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }

    var totalCompletions: Int { completionDates.count }
}

// MARK: - Task Templates for Onboarding

struct TaskTemplate: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let category: String
    let pointValue: Int

    static let all: [TaskTemplate] = [
        TaskTemplate(name: "Send cold outreach", emoji: "📧", category: "Revenue", pointValue: 12),
        TaskTemplate(name: "Deep work block (2hr+)", emoji: "💻", category: "Output", pointValue: 12),
        TaskTemplate(name: "Sales call / demo", emoji: "📞", category: "Revenue", pointValue: 12),
        TaskTemplate(name: "Publish content", emoji: "📝", category: "Growth", pointValue: 10),
        TaskTemplate(name: "Review metrics", emoji: "📊", category: "Strategy", pointValue: 8),
        TaskTemplate(name: "Work on revenue", emoji: "💰", category: "Revenue", pointValue: 15),
        TaskTemplate(name: "Train / gym", emoji: "🏋️", category: "Health", pointValue: 8),
        TaskTemplate(name: "Read / learn", emoji: "📖", category: "Growth", pointValue: 6),
        TaskTemplate(name: "Meditate / clear head", emoji: "🧘", category: "Health", pointValue: 6),
        TaskTemplate(name: "No doom scrolling", emoji: "🚫", category: "Focus", pointValue: 8),
        TaskTemplate(name: "8hrs sleep", emoji: "😴", category: "Health", pointValue: 6),
        TaskTemplate(name: "Meaningful networking", emoji: "🤝", category: "Growth", pointValue: 8),
        TaskTemplate(name: "Write / journal", emoji: "✍️", category: "Growth", pointValue: 6),
        TaskTemplate(name: "Ship something", emoji: "🎯", category: "Output", pointValue: 12),
    ]
}
