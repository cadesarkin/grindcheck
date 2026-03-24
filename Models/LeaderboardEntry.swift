import Foundation

struct LeaderboardEntry: Identifiable, Hashable {
    let id = UUID()
    let rank: Int
    let name: String
    let avatarEmoji: String
    let level: Int
    let streak: Int
    let todayScore: Int
    let totalPoints: Int
    let isCurrentUser: Bool

    static let mockGlobal: [LeaderboardEntry] = [
        LeaderboardEntry(rank: 1, name: "alex_builds", avatarEmoji: "😎", level: 38, streak: 94, todayScore: 100, totalPoints: 42300, isCurrentUser: false),
        LeaderboardEntry(rank: 2, name: "morgan_ops", avatarEmoji: "🔥", level: 34, streak: 72, todayScore: 91, totalPoints: 38100, isCurrentUser: false),
        LeaderboardEntry(rank: 3, name: "j_creator", avatarEmoji: "🎨", level: 29, streak: 58, todayScore: 85, totalPoints: 31400, isCurrentUser: false),
        LeaderboardEntry(rank: 4, name: "ship_sarah", avatarEmoji: "🚀", level: 25, streak: 43, todayScore: 78, totalPoints: 27200, isCurrentUser: false),
        LeaderboardEntry(rank: 5, name: "deep_dan", avatarEmoji: "🧠", level: 22, streak: 35, todayScore: 72, totalPoints: 23800, isCurrentUser: false),
        LeaderboardEntry(rank: 6, name: "rise_rach", avatarEmoji: "⚡", level: 19, streak: 28, todayScore: 67, totalPoints: 19500, isCurrentUser: false),
        LeaderboardEntry(rank: 7, name: "kyle_capital", avatarEmoji: "💰", level: 16, streak: 21, todayScore: 55, totalPoints: 15200, isCurrentUser: false),
        LeaderboardEntry(rank: 8, name: "nina_growth", avatarEmoji: "📈", level: 13, streak: 14, todayScore: 50, totalPoints: 11400, isCurrentUser: false),
        LeaderboardEntry(rank: 9, name: "chill_chad", avatarEmoji: "🏖️", level: 10, streak: 8, todayScore: 33, totalPoints: 8100, isCurrentUser: false),
        LeaderboardEntry(rank: 10, name: "late_larry", avatarEmoji: "😴", level: 7, streak: 3, todayScore: 20, totalPoints: 5200, isCurrentUser: false),
    ]

    static func withUser(profile: UserProfile, todayScore: Int) -> [LeaderboardEntry] {
        var entries = mockGlobal
        let userEntry = LeaderboardEntry(
            rank: 0,
            name: profile.username,
            avatarEmoji: profile.avatarEmoji,
            level: profile.level,
            streak: profile.currentStreak,
            todayScore: todayScore,
            totalPoints: profile.totalPoints,
            isCurrentUser: true
        )
        entries.append(userEntry)
        entries.sort { $0.totalPoints > $1.totalPoints }
        return entries.enumerated().map { idx, e in
            LeaderboardEntry(
                rank: idx + 1,
                name: e.name,
                avatarEmoji: e.avatarEmoji,
                level: e.level,
                streak: e.streak,
                todayScore: e.todayScore,
                totalPoints: e.totalPoints,
                isCurrentUser: e.isCurrentUser
            )
        }
    }

    static let mockFriends: [LeaderboardEntry] = [
        LeaderboardEntry(rank: 1, name: "alex_builds", avatarEmoji: "😎", level: 12, streak: 21, todayScore: 85, totalPoints: 8400, isCurrentUser: false),
        LeaderboardEntry(rank: 2, name: "jordan_ships", avatarEmoji: "🎧", level: 9, streak: 14, todayScore: 72, totalPoints: 6200, isCurrentUser: false),
        LeaderboardEntry(rank: 3, name: "sam_grinds", avatarEmoji: "💪", level: 7, streak: 9, todayScore: 55, totalPoints: 4800, isCurrentUser: false),
    ]
}
