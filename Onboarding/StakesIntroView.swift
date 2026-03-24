import SwiftUI

struct StakesIntroView: View {
    let onContinue: () -> Void

    @State private var showVS = false
    @State private var showBenefits = false

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 12) {
                    Text("Put something\non the line.")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("Accountability hits different when there's real stakes. Challenge a founder friend to a 30-day output battle. Whoever breaks their streak first loses.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                // VS visual
                if showVS {
                    HStack(spacing: 24) {
                        VStack(spacing: 6) {
                            Text("🚀")
                                .font(.system(size: 44))
                            Text("You")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.7))
                        }

                        VStack(spacing: 6) {
                            Text("VS")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundStyle(Color.gcOrange)
                            Text("$10")
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.gcGreen)
                        }

                        VStack(spacing: 6) {
                            Text("😎")
                                .font(.system(size: 44))
                            Text("Friend")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(Color.gcCardFill)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.gcOrange.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    .transition(.scale.combined(with: .opacity))
                }

                if showBenefits {
                    VStack(spacing: 12) {
                        benefitRow(emoji: "💸", text: "Set a stake from $5–$50")
                        benefitRow(emoji: "🤝", text: "Invite one friend — they accept or decline")
                        benefitRow(emoji: "🏆", text: "Winner keeps both stakes at the end of 30 days")
                    }
                    .padding(.horizontal, 24)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if showBenefits {
                    Text("GrindCheck does not hold funds. Stakes are honoured peer-to-peer via the honour system — this is a commitment contract, not gambling.")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(.white.opacity(0.3))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .transition(.opacity)
                }

                Spacer()

                if showBenefits {
                    Button("Sounds like a deal →") {
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
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4)) { showVS = true }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(1.0)) { showBenefits = true }
        }
    }

    private func benefitRow(emoji: String, text: String) -> some View {
        HStack(spacing: 12) {
            Text(emoji).font(.title3)
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .gcCard()
    }
}
