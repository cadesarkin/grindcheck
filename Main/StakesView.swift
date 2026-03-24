import SwiftUI

struct StakesView: View {
    @State private var showNewBattle = false

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Text("The Battles")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.top, 16)

                    // Challenge button
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        showNewBattle = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Challenge a Friend")
                        }
                    }
                    .buttonStyle(GCSecondaryButtonStyle())
                    .padding(.horizontal, 24)

                    // Active battles
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("ACTIVE BATTLES")

                        ForEach(StakesBattle.mockActive, id: \.id) { battle in
                            BattleCardView(battle: battle)
                        }
                    }
                    .padding(.horizontal, 24)

                    // Completed
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("COMPLETED")

                        ForEach(StakesBattle.mockCompleted, id: \.id) { battle in
                            BattleCardView(battle: battle)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 120)
                }
            }

            // New battle sheet
            if showNewBattle {
                newBattleSheet
            }
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white.opacity(0.3))
            .tracking(2)
    }

    private var newBattleSheet: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
                .onTapGesture {
                    withAnimation { showNewBattle = false }
                }

            VStack(spacing: 24) {
                Text("Start a Battle")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(.white)

                VStack(spacing: 14) {
                    infoRow(label: "Opponent", value: "Share invite link")
                    infoRow(label: "Stake", value: "$5 – $50")
                    infoRow(label: "Duration", value: "7, 14, or 30 days")
                }

                Button("Share Invite Link") {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    withAnimation { showNewBattle = false }
                }
                .buttonStyle(GCPrimaryButtonStyle())

                Button("Cancel") {
                    withAnimation { showNewBattle = false }
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
            }
            .padding(28)
            .background(Color.gcBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gcCardBorder, lineWidth: 1)
            )
            .padding(.horizontal, 32)
            .transition(.scale.combined(with: .opacity))
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gcOrange)
        }
        .gcCard()
    }
}
