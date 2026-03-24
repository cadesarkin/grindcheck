import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var username: String
    var avatarEmoji: String
    var selectedIdentities: [String]
    var totalPoints: Int
    var currentStreak: Int
    var bestStreak: Int
    var memberSince: Date
    var lastCompletionDate: Date?
    var stakesWins: Int
    var stakesLosses: Int

    init(username: String = "founder") {
        self.id = UUID()
        self.username = username
        self.avatarEmoji = "🚀"
        self.selectedIdentities = []
        self.totalPoints = 0
        self.currentStreak = 0
        self.bestStreak = 0
        self.memberSince = Date()
        self.lastCompletionDate = nil
        self.stakesWins = 0
        self.stakesLosses = 0
    }

    // MARK: - Levelling (every 500 cumulative points)

    static let pointsPerLevel = 500

    var level: Int {
        (totalPoints / Self.pointsPerLevel) + 1
    }

    var pointsInCurrentLevel: Int {
        totalPoints % Self.pointsPerLevel
    }

    var levelProgressFraction: Double {
        Double(pointsInCurrentLevel) / Double(Self.pointsPerLevel)
    }

    var pointsToNextLevel: Int {
        Self.pointsPerLevel - pointsInCurrentLevel
    }

    // MARK: - Streak (broken if output score < 50%)

    func updateStreak(outputScorePercent: Double) {
        let calendar = Calendar.current
        let today = Date()

        guard outputScorePercent >= 50.0 else { return }

        if let last = lastCompletionDate {
            if calendar.isDate(last, inSameDayAs: today) { return }
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if calendar.isDate(last, inSameDayAs: yesterday) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        lastCompletionDate = today
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
    }

    func checkStreakReset() {
        let calendar = Calendar.current
        let today = Date()
        guard let last = lastCompletionDate else { return }
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        if !calendar.isDate(last, inSameDayAs: today) && !calendar.isDate(last, inSameDayAs: yesterday) {
            currentStreak = 0
        }
    }

    func awardPoints(_ amount: Int) {
        totalPoints += amount
    }

    // MARK: - Achievements

    var earnedBadges: [Achievement] {
        Achievement.all.filter { $0.isEarned(by: self) }
    }

    var stakesRecord: String {
        "\(stakesWins)W – \(stakesLosses)L"
    }
}

// MARK: - Achievements

struct Achievement: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let description: String
    let requirement: AchievementRequirement

    func isEarned(by profile: UserProfile) -> Bool {
        switch requirement {
        case .streak(let days): return profile.bestStreak >= days
        case .level(let lvl): return profile.level >= lvl
        case .totalPoints(let pts): return profile.totalPoints >= pts
        case .stakesWin(let wins): return profile.stakesWins >= wins
        }
    }

    static func == (lhs: Achievement, rhs: Achievement) -> Bool { lhs.name == rhs.name }
    func hash(into hasher: inout Hasher) { hasher.combine(name) }

    static let all: [Achievement] = [
        Achievement(name: "7-Day Grinder", emoji: "🔥", description: "7-day streak", requirement: .streak(7)),
        Achievement(name: "Full Output Week", emoji: "⚡", description: "100% output for 7 days straight", requirement: .streak(7)),
        Achievement(name: "First Stakes Win", emoji: "💰", description: "Win your first battle", requirement: .stakesWin(1)),
        Achievement(name: "30-Day Founder", emoji: "🚀", description: "30-day streak", requirement: .streak(30)),
        Achievement(name: "100-Day Operator", emoji: "💎", description: "100-day streak", requirement: .streak(100)),
        Achievement(name: "Level 5", emoji: "⭐", description: "Reach level 5", requirement: .level(5)),
        Achievement(name: "Level 10", emoji: "🌟", description: "Reach level 10", requirement: .level(10)),
        Achievement(name: "Level 25", emoji: "✨", description: "Reach level 25", requirement: .level(25)),
        Achievement(name: "1K Output", emoji: "📈", description: "Earn 1,000 total points", requirement: .totalPoints(1000)),
        Achievement(name: "10K Output", emoji: "🏆", description: "Earn 10,000 total points", requirement: .totalPoints(10000)),
    ]
}

enum AchievementRequirement: Hashable {
    case streak(Int)
    case level(Int)
    case totalPoints(Int)
    case stakesWin(Int)
}
