import SwiftUI

struct OutputScoreRing: View {
    let score: Int
    let size: CGFloat

    private var fraction: Double {
        Double(score) / 100.0
    }

    private var ringColor: Color {
        if score >= 80 { return .gcGreen }
        if score >= 50 { return .gcOrange }
        return .gcDanger
    }

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: size * 0.08)

            // Progress ring
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: score)

            // Score text
            VStack(spacing: 2) {
                Text("\(score)")
                    .font(.system(size: size * 0.3, weight: .bold, design: .monospaced))
                    .foregroundStyle(ringColor)

                Text("OUTPUT")
                    .font(.system(size: size * 0.08, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(2)
            }
        }
        .frame(width: size, height: size)
    }
}
