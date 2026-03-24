import Foundation
import SwiftData

@Model
final class StakesBattle {
    var id: UUID
    var opponentName: String
    var opponentEmoji: String
    var stakeAmount: Int
    var durationDays: Int
    var startDate: Date
    var userScore: Int
    var opponentScore: Int
    var userStreakBroken: Bool
    var opponentStreakBroken: Bool
    var isActive: Bool
    var didWin: Bool?

    init(
        opponentName: String,
        opponentEmoji: String,
        stakeAmount: Int,
        durationDays: Int
    ) {
        self.id = UUID()
        self.opponentName = opponentName
        self.opponentEmoji = opponentEmoji
        self.stakeAmount = stakeAmount
        self.durationDays = durationDays
        self.startDate = Date()
        self.userScore = 0
        self.opponentScore = 0
        self.userStreakBroken = false
        self.opponentStreakBroken = false
        self.isActive = true
        self.didWin = nil
    }

    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: durationDays, to: startDate) ?? startDate
    }

    var daysRemaining: Int {
        max(0, Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0)
    }

    var isExpired: Bool {
        Date() >= endDate
    }

    var userIsAhead: Bool {
        userScore > opponentScore
    }

    var scoreDisplay: String {
        "\(userScore) – \(opponentScore)"
    }

    static let mockActive: [StakesBattle] = {
        let b1 = StakesBattle(opponentName: "alex_builds", opponentEmoji: "😎", stakeAmount: 10, durationDays: 30)
        b1.userScore = 87
        b1.opponentScore = 74
        let b2 = StakesBattle(opponentName: "morgan_ops", opponentEmoji: "🔥", stakeAmount: 25, durationDays: 14)
        b2.userScore = 42
        b2.opponentScore = 48
        return [b1, b2]
    }()

    static let mockCompleted: [StakesBattle] = {
        let b1 = StakesBattle(opponentName: "j_creator", opponentEmoji: "🎨", stakeAmount: 10, durationDays: 30)
        b1.userScore = 210
        b1.opponentScore = 185
        b1.isActive = false
        b1.didWin = true
        return [b1]
    }()
}
