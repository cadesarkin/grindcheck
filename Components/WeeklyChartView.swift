import SwiftUI

struct WeeklyChartView: View {
    let scores: [(date: Date, score: Int)]

    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }()

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(scores.enumerated()), id: \.offset) { _, entry in
                VStack(spacing: 6) {
                    // Bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(barColor(for: entry.score))
                        .frame(width: 28, height: max(4, CGFloat(entry.score) / 100.0 * 100))
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: entry.score)

                    // Score label
                    Text("\(entry.score)")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.5))

                    // Day label
                    Text(dayFormatter.string(from: entry.date))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.35))
                }
            }
        }
        .frame(height: 140)
    }

    private func barColor(for score: Int) -> Color {
        if score >= 80 { return .gcGreen }
        if score >= 50 { return .gcOrange }
        if score > 0 { return .gcDanger }
        return .white.opacity(0.1)
    }
}
