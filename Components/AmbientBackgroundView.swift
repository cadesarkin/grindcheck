import SwiftUI

struct AmbientBackgroundView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            // Electric green orb
            Circle()
                .fill(RadialGradient(
                    colors: [Color.gcGreen.opacity(0.25), .clear],
                    center: .center, startRadius: 0, endRadius: 200
                ))
                .frame(width: 400, height: 400)
                .offset(x: animate ? 50 : -50, y: animate ? -100 : -60)
                .blur(radius: 80)

            // Orange orb
            Circle()
                .fill(RadialGradient(
                    colors: [Color.gcOrange.opacity(0.2), .clear],
                    center: .center, startRadius: 0, endRadius: 180
                ))
                .frame(width: 350, height: 350)
                .offset(x: animate ? -30 : 40, y: animate ? 80 : 50)
                .blur(radius: 70)

            // Subtle green accent
            Circle()
                .fill(RadialGradient(
                    colors: [Color.gcGreen.opacity(0.1), .clear],
                    center: .center, startRadius: 0, endRadius: 120
                ))
                .frame(width: 250, height: 250)
                .offset(x: animate ? 70 : -10, y: animate ? 30 : 120)
                .blur(radius: 60)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
