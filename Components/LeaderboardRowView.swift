import SwiftUI

struct LeaderboardRowView: View {
    let entry: LeaderboardEntry

    private var rankDisplay: String {
        switch entry.rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "#\(entry.rank)"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Group {
                if entry.rank <= 3 {
                    Text(rankDisplay)
                        .font(.title3)
                } else {
                    Text(rankDisplay)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            .frame(width: 36)

            // Avatar
            Text(entry.avatarEmoji)
                .font(.title3)

            // Name + level
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(entry.isCurrentUser ? Color.gcGreen : .white)
                Text("Lv \(entry.level)")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.4))
            }

            Spacer()

            // Today's score
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(entry.todayScore)")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundStyle(entry.isCurrentUser ? Color.gcGreen : .white)
                HStack(spacing: 3) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.gcOrange)
                    Text("\(entry.streak)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(entry.isCurrentUser ? Color.gcGreen.opacity(0.08) : Color.gcCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(entry.isCurrentUser ? Color.gcGreen.opacity(0.25) : Color.gcCardBorder, lineWidth: 1)
        )
    }
}
