import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var store: TaskStore
    @State private var selectedTab = 0

    private let tabs = ["Friends", "Global", "This Week"]

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                Text("The Board")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.white)
                    .padding(.top, 16)

                // Tab picker
                HStack(spacing: 0) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedTab = index }
                        } label: {
                            Text(tab)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(selectedTab == index ? Color.gcGreen : .white.opacity(0.4))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == index ? Color.gcGreen.opacity(0.1) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(4)
                .background(Color.gcCardFill)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 24)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(currentEntries) { entry in
                            LeaderboardRowView(entry: entry)
                        }

                        // User's global rank if not in top 10
                        if selectedTab == 1, let userEntry = userGlobalEntry, userEntry.rank > 10 {
                            Divider()
                                .overlay(Color.white.opacity(0.1))
                                .padding(.vertical, 4)

                            HStack {
                                Text("Your rank")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.4))
                                Spacer()
                                Text("#\(userEntry.rank) of 12,847")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundStyle(Color.gcGreen)
                            }
                            .padding(.horizontal, 4)

                            LeaderboardRowView(entry: userEntry)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 120)
                }
            }
        }
    }

    private var currentEntries: [LeaderboardEntry] {
        switch selectedTab {
        case 0:
            var friends = LeaderboardEntry.mockFriends
            let userEntry = LeaderboardEntry(
                rank: 0, name: store.profile.username,
                avatarEmoji: store.profile.avatarEmoji,
                level: store.profile.level,
                streak: store.profile.currentStreak,
                todayScore: store.outputScore,
                totalPoints: store.profile.totalPoints,
                isCurrentUser: true
            )
            friends.append(userEntry)
            friends.sort { $0.totalPoints > $1.totalPoints }
            return friends.enumerated().map { idx, e in
                LeaderboardEntry(rank: idx + 1, name: e.name, avatarEmoji: e.avatarEmoji, level: e.level, streak: e.streak, todayScore: e.todayScore, totalPoints: e.totalPoints, isCurrentUser: e.isCurrentUser)
            }
        case 1:
            return LeaderboardEntry.withUser(profile: store.profile, todayScore: store.outputScore)
        default:
            return LeaderboardEntry.mockFriends
        }
    }

    private var userGlobalEntry: LeaderboardEntry? {
        currentEntries.first { $0.isCurrentUser }
    }
}
