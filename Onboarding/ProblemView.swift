import SwiftUI

struct ProblemView: View {
    let onContinue: () -> Void

    @State private var showCard1 = false
    @State private var showCard2 = false
    @State private var showCard3 = false
    @State private var showDivider = false
    @State private var showPunchline = false

    private let problems: [(String, String)] = [
        ("❌", "You're busy, not productive — and deep down you know the difference"),
        ("❌", "Nobody in your circle is holding you accountable to your actual goals"),
        ("❌", "There's no scoreboard. So it's easy to let days slide."),
    ]

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Text("Here's why your output\nisn't where you want it.")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    if showCard1 { problemCard(problems[0]) }
                    if showCard2 { problemCard(problems[1]) }
                    if showCard3 { problemCard(problems[2]) }
                }
                .padding(.horizontal, 24)

                if showDivider {
                    Rectangle()
                        .fill(Color.gcGreen.opacity(0.4))
                        .frame(height: 1)
                        .padding(.horizontal, 60)
                        .transition(.opacity)
                }

                if showPunchline {
                    Text("GrindCheck puts a scoreboard\non your effort.")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.gcGreen)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer()

                if showPunchline {
                    Button("Show me →") {
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
        .onAppear { animateSequence() }
    }

    private func problemCard(_ problem: (String, String)) -> some View {
        HStack(spacing: 12) {
            Text(problem.0)
                .font(.title3)
            Text(problem.1)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
        }
        .gcCard()
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private func animateSequence() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3)) { showCard1 = true }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.8)) { showCard2 = true }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(1.3)) { showCard3 = true }
        withAnimation(.easeInOut(duration: 0.6).delay(2.0)) { showDivider = true }
        withAnimation(.easeInOut(duration: 0.6).delay(2.5)) { showPunchline = true }
    }
}
