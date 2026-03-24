import SwiftUI

struct ProfileView: View {
    @ObservedObject var store: TaskStore
    @State private var showSettings = false

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Header
                    HStack {
                        Spacer()
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title3)
                                .foregroundStyle(.white.opacity(0.4))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    // Avatar + name
                    VStack(spacing: 12) {
                        Text(store.profile.avatarEmoji)
                            .font(.system(size: 64))

                        Text(store.profile.username)
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundStyle(.white)

                        Text("Member since \(store.profile.memberSince.formatted(.dateTime.month(.wide).year()))")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.35))
                    }

                    // Big stat trio
                    HStack(spacing: 16) {
                        statCard(emoji: "🔥", label: "Streak", value: "\(store.profile.currentStreak)")
                        statCard(emoji: "⭐", label: "Level", value: "\(store.profile.level)")
                        statCard(emoji: "⚡", label: "Output", value: "\(store.profile.totalPoints)")
                    }
                    .padding(.horizontal, 24)

                    // Stakes record
                    HStack {
                        Text("Battle Record")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                        Spacer()
                        Text(store.profile.stakesRecord)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.gcOrange)
                    }
                    .gcCard()
                    .padding(.horizontal, 24)

                    // Badges
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ACHIEVEMENTS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white.opacity(0.3))
                            .tracking(2)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ], spacing: 12) {
                            ForEach(Achievement.all) { badge in
                                let earned = badge.isEarned(by: store.profile)
                                VStack(spacing: 6) {
                                    Text(badge.emoji)
                                        .font(.system(size: 28))
                                        .opacity(earned ? 1 : 0.2)
                                    Text(badge.name)
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundStyle(earned ? .white : .white.opacity(0.2))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(earned ? Color.gcGreen.opacity(0.06) : Color.gcCardFill)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(earned ? Color.gcGreen.opacity(0.2) : Color.gcCardBorder, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    // Weekly chart
                    VStack(alignment: .leading, spacing: 14) {
                        Text("THIS WEEK")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white.opacity(0.3))
                            .tracking(2)

                        WeeklyChartView(scores: store.weeklyScores)
                            .frame(maxWidth: .infinity)
                    }
                    .gcCard()
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 120)
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private func statCard(emoji: String, label: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(emoji).font(.title2)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white.opacity(0.4))
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.gcCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gcCardBorder, lineWidth: 1)
        )
    }
}
