import Foundation

struct ScoringEngine {
    /// Output score as 0–100 based on points earned vs max possible
    static func outputScore(tasks: [GrindTask]) -> Int {
        let maxPoints = tasks.reduce(0) { $0 + $1.pointValue }
        guard maxPoints > 0 else { return 0 }
        let earnedPoints = tasks.filter(\.isCompletedToday).reduce(0) { $0 + $1.pointValue }
        return Int((Double(earnedPoints) / Double(maxPoints)) * 100.0)
    }

    /// Points earned today
    static func pointsEarnedToday(tasks: [GrindTask]) -> Int {
        tasks.filter(\.isCompletedToday).reduce(0) { $0 + $1.pointValue }
    }

    /// Max possible points today
    static func maxPointsToday(tasks: [GrindTask]) -> Int {
        tasks.reduce(0) { $0 + $1.pointValue }
    }

    /// Whether the streak is safe (score >= 50%)
    static func streakIsSafe(tasks: [GrindTask]) -> Bool {
        outputScore(tasks: tasks) >= 50
    }

    /// Score for a specific date from completion history
    static func scoreForDate(_ date: Date, tasks: [GrindTask]) -> Int {
        let maxPoints = tasks.reduce(0) { $0 + $1.pointValue }
        guard maxPoints > 0 else { return 0 }
        let earned = tasks.filter { $0.wasCompletedOn(date) }.reduce(0) { $0 + $1.pointValue }
        return Int((Double(earned) / Double(maxPoints)) * 100.0)
    }

    /// Last 7 days of scores for the weekly chart
    static func weeklyScores(tasks: [GrindTask]) -> [(date: Date, score: Int)] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            return (date: date, score: scoreForDate(date, tasks: tasks))
        }
    }
}
