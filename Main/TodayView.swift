import SwiftUI

struct TodayView: View {
    @ObservedObject var store: TaskStore

    @State private var showCelebration = false

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        StreakBadgeView(streak: store.profile.currentStreak)
                        Spacer()
                        LevelBadgeView(level: store.profile.level)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    // Output Score Ring
                    OutputScoreRing(score: store.outputScore, size: 160)
                        .padding(.top, 8)

                    // Points summary
                    HStack(spacing: 24) {
                        statPill(label: "EARNED", value: "\(store.pointsEarnedToday)", color: .gcGreen)
                        statPill(label: "REMAINING", value: "\(store.maxPointsToday - store.pointsEarnedToday)", color: .white.opacity(0.5))
                        statPill(label: "TASKS", value: "\(store.completedCount)/\(store.totalCount)", color: .gcOrange)
                    }

                    // Level progress
                    VStack(spacing: 6) {
                        HStack {
                            Text("Level \(store.profile.level)")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.gcGreen)
                            Spacer()
                            Text("\(store.profile.pointsToNextLevel) pts to next")
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundStyle(.white.opacity(0.4))
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.08))
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gcGreen)
                                    .frame(width: geo.size.width * store.profile.levelProgressFraction)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: store.profile.levelProgressFraction)
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(.horizontal, 24)

                    // Task list
                    VStack(spacing: 10) {
                        ForEach(store.tasks, id: \.id) { task in
                            TaskRowView(task: task) {
                                store.completeTask(task)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    // Activity ticker
                    activityTicker
                        .padding(.horizontal, 24)

                    Spacer().frame(height: 100)
                }
            }

            // Full output celebration
            if showCelebration {
                fullOutputCelebration
            }
        }
        .onChange(of: store.showFullOutput) { _, newValue in
            if newValue {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showCelebration = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation { showCelebration = false }
                    store.showFullOutput = false
                }
            }
        }
    }

    private func statPill(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.white.opacity(0.35))
                .tracking(1)
        }
    }

    private var activityTicker: some View {
        VStack(spacing: 8) {
            HStack {
                Text("LIVE FEED")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.3))
                    .tracking(2)
                Spacer()
            }

            VStack(spacing: 6) {
                tickerRow("alex_builds just completed Cold Outreach 🔥")
                tickerRow("morgan_ops hit Full Output today ⚡")
                tickerRow("j_creator is on a 14-day streak 🏆")
            }
        }
        .gcCard()
    }

    private func tickerRow(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white.opacity(0.5))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var fullOutputCelebration: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            ConfettiView()

            VStack(spacing: 16) {
                Text("⚡")
                    .font(.system(size: 64))
                Text("FULL OUTPUT DAY")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(Color.gcGreen)
                Text("You completed every task. That's the standard.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .transition(.opacity)
        .onTapGesture {
            withAnimation { showCelebration = false }
            store.showFullOutput = false
        }
    }
}
