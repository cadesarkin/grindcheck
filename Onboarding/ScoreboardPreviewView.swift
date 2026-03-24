import SwiftUI

struct ScoreboardPreviewView: View {
    let onContinue: () -> Void

    @State private var visibleRows = 0

    private let mockRows: [(rank: String, name: String, pts: String, streak: String, extras: String)] = [
        ("🥇", "alex_builds", "47 pts", "🔥 34 days", "Revenue: ✅  Cold outreach: ✅"),
        ("🥈", "morgan_ops", "41 pts", "🔥 28 days", ""),
        ("🥉", "You", "38 pts", "🔥 21 days", ""),
        ("#4", "j_creator", "29 pts", "🔥 14 days", ""),
    ]

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Text("Your founder circle.\nRanked by output.")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    ForEach(Array(mockRows.enumerated()), id: \.offset) { index, row in
                        if index < visibleRows {
                            mockLeaderboardRow(row: row, isUser: row.name == "You")
                                .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }
                    }
                }
                .padding(.horizontal, 24)

                if visibleRows >= mockRows.count {
                    Text("12,000 founders are tracking their output right now. The top 10% all have one thing in common — they don't let days slide.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .transition(.opacity)
                }

                Spacer()

                if visibleRows >= mockRows.count {
                    Button("I want on that board →") {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        onContinue()
                    }
                    .buttonStyle(GCPrimaryButtonStyle())
                    .padding(.horizontal, 24)
                    .transition(.opacity)
                }

                Spacer().frame(height: 30)
            }
        }
        .onAppear {
            for i in 0..<mockRows.count {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(i) * 0.4 + 0.3)) {
                    visibleRows = i + 1
                }
            }
        }
    }

    private func mockLeaderboardRow(row: (rank: String, name: String, pts: String, streak: String, extras: String), isUser: Bool) -> some View {
        HStack(spacing: 12) {
            Text(row.rank)
                .font(row.rank.count <= 2 ? .title3 : .system(size: 14, weight: .bold, design: .monospaced))
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(row.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isUser ? Color.gcGreen : .white)
                if !row.extras.isEmpty {
                    Text(row.extras)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(row.pts)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundStyle(isUser ? Color.gcGreen : .white)
                Text(row.streak)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(isUser ? Color.gcGreen.opacity(0.08) : Color.gcCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isUser ? Color.gcGreen.opacity(0.3) : Color.gcCardBorder, lineWidth: 1)
        )
    }
}
