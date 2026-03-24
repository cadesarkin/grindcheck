import SwiftUI

struct IdentityView: View {
    @Binding var selectedIdentities: Set<String>
    let onContinue: () -> Void

    private let identities: [(emoji: String, label: String, key: String)] = [
        ("🚀", "Founder / Building a startup", "founder"),
        ("📈", "Operator / Running a business", "operator"),
        ("🎯", "Creator / Monetising an audience", "creator"),
        ("💼", "Ambitious professional / Career climbing", "professional"),
    ]

    var body: some View {
        ZStack {
            AmbientBackgroundView()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 14) {
                    Text("Are you actually\ndoing the work?")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("Everyone says they're building. Very few have the data to prove it. GrindCheck is for the ones who want proof.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                VStack(spacing: 12) {
                    ForEach(identities, id: \.key) { identity in
                        IdentityCard(
                            emoji: identity.emoji,
                            label: identity.label,
                            isSelected: selectedIdentities.contains(identity.key)
                        ) {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                                if selectedIdentities.contains(identity.key) {
                                    selectedIdentities.remove(identity.key)
                                } else {
                                    selectedIdentities.insert(identity.key)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                Button("That's me →") {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    onContinue()
                }
                .buttonStyle(GCPrimaryButtonStyle())
                .disabled(selectedIdentities.isEmpty)
                .opacity(selectedIdentities.isEmpty ? 0.4 : 1)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

private struct IdentityCard: View {
    let emoji: String
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Text(emoji)
                    .font(.title2)
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.gcOrange)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(16)
            .background(isSelected ? Color.gcOrange.opacity(0.1) : Color.gcCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.gcOrange.opacity(0.5) : Color.gcCardBorder, lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.gcOrange.opacity(0.15) : .clear, radius: 8)
        }
        .buttonStyle(.plain)
    }
}
