import SwiftUI

struct StreakBadgeView: View {
    let streak: Int
    var large: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(large ? .title2 : .caption)
                .foregroundStyle(Color.gcOrange)
            Text("\(streak)")
                .font(.system(size: large ? 20 : 14, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, large ? 14 : 10)
        .padding(.vertical, large ? 8 : 5)
        .background(Color.gcOrange.opacity(0.15))
        .clipShape(Capsule())
    }
}

struct LevelBadgeView: View {
    let level: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundStyle(Color.gcGreen)
            Text("Lv \(level)")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.gcGreen.opacity(0.12))
        .clipShape(Capsule())
    }
}
