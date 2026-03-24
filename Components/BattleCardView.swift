import SwiftUI

struct BattleCardView: View {
    let battle: StakesBattle

    var body: some View {
        VStack(spacing: 16) {
            // Opponent + status
            HStack {
                HStack(spacing: 8) {
                    Text(battle.opponentEmoji)
                        .font(.title2)
                    Text("vs \(battle.opponentName)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Spacer()

                if battle.isActive {
                    Text("\(battle.daysRemaining)d left")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.gcOrange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gcOrange.opacity(0.15))
                        .clipShape(Capsule())
                } else {
                    Text(battle.didWin == true ? "WON" : "LOST")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(battle.didWin == true ? Color.gcGreen : Color.gcDanger)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background((battle.didWin == true ? Color.gcGreen : Color.gcDanger).opacity(0.15))
                        .clipShape(Capsule())
                }
            }

            // Score face-off
            HStack {
                VStack(spacing: 4) {
                    Text("You")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                    Text("\(battle.userScore)")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundStyle(battle.userIsAhead ? Color.gcGreen : .white)
                }

                Spacer()

                VStack(spacing: 4) {
                    Text("$\(battle.stakeAmount)")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.gcOrange)
                    Text("STAKE")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.4))
                        .tracking(1.5)
                }

                Spacer()

                VStack(spacing: 4) {
                    Text(battle.opponentName.components(separatedBy: "_").first ?? "Them")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                    Text("\(battle.opponentScore)")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundStyle(!battle.userIsAhead ? Color.gcOrange : .white)
                }
            }

            // Progress bar
            if battle.isActive {
                GeometryReader { geo in
                    let total = max(battle.userScore + battle.opponentScore, 1)
                    let userWidth = CGFloat(battle.userScore) / CGFloat(total) * geo.size.width
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gcOrange.opacity(0.3))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gcGreen)
                            .frame(width: userWidth)
                    }
                }
                .frame(height: 6)
            }
        }
        .gcCard()
    }
}
