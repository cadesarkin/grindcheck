import SwiftUI

struct PaywallView: View {
    let selectedIdentities: Set<String>
    let selectedTasks: Set<TaskTemplate>
    @Binding var hasCompletedOnboarding: Bool

    @StateObject private var storeKit = StoreKitService.shared
    @State private var selectedPlan: String = "grindcheck.annual"
    @State private var isPurchasing = false

    private var identityLabel: String {
        let map: [String: String] = [
            "founder": "🚀 Founder",
            "operator": "📈 Operator",
            "creator": "🎯 Creator",
            "professional": "💼 Professional",
        ]
        return selectedIdentities.compactMap { map[$0] }.first ?? "🚀 Founder"
    }

    private var taskSummary: String {
        let sorted = Array(selectedTasks).prefix(3)
        let names = sorted.map { "\($0.emoji) \($0.name)" }
        let extra = selectedTasks.count > 3 ? " +\(selectedTasks.count - 3) more" : ""
        return names.joined(separator: ", ") + extra
    }

    private var ctaLabel: String {
        selectedPlan == "grindcheck.annual" ? "Start Grinding — $49.99/year" : "Start Grinding — $7.99/month"
    }

    var body: some View {
        ZStack {
            AmbientBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    Spacer().frame(height: 50)

                    Text("You're set up.\nNow go to work.")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    // Personalised summary
                    VStack(alignment: .leading, spacing: 10) {
                        summaryRow(label: "You are", value: identityLabel)
                        summaryRow(label: "Your daily stack", value: taskSummary)
                        summaryRow(label: "Your streak", value: "Starts today 🔥")
                    }
                    .padding(18)
                    .background(Color.gcCardFill)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gcGreen.opacity(0.15), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Benefit cards
                    HStack(spacing: 12) {
                        benefitCard(emoji: "📊", title: "Track", subtitle: "Daily output scoring")
                        benefitCard(emoji: "🏆", title: "Compete", subtitle: "Founder leaderboards")
                        benefitCard(emoji: "💸", title: "Stakes", subtitle: "Real accountability")
                    }
                    .padding(.horizontal, 24)

                    // Pricing
                    VStack(spacing: 12) {
                        // Annual
                        planOption(
                            id: "grindcheck.annual",
                            title: "Annual",
                            price: "$49.99/year",
                            badge: "BEST VALUE · $4.17/mo",
                            isSelected: selectedPlan == "grindcheck.annual"
                        )

                        // Monthly
                        planOption(
                            id: "grindcheck.monthly",
                            title: "Monthly",
                            price: "$7.99/month",
                            badge: nil,
                            isSelected: selectedPlan == "grindcheck.monthly"
                        )
                    }
                    .padding(.horizontal, 24)

                    // CTA
                    Button(ctaLabel) {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        isPurchasing = true

                        Task {
                            if let product = storeKit.products.first(where: { $0.id == selectedPlan }) {
                                let success = try? await storeKit.purchase(product)
                                if success == true {
                                    hasCompletedOnboarding = true
                                }
                            } else {
                                // StoreKit products not loaded (dev/simulator) — unlock anyway for testing
                                hasCompletedOnboarding = true
                            }
                            isPurchasing = false
                        }
                    }
                    .buttonStyle(GCPrimaryButtonStyle())
                    .disabled(isPurchasing)
                    .padding(.horizontal, 24)

                    Text("Cancel anytime via App Store settings.")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.white.opacity(0.35))

                    // Footer links
                    HStack(spacing: 16) {
                        Button("Restore Purchase") {
                            Task { await storeKit.restorePurchases() }
                        }
                        Text("·").foregroundStyle(.white.opacity(0.2))
                        Button("Privacy Policy") {}
                        Text("·").foregroundStyle(.white.opacity(0.2))
                        Button("Terms") {}
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.3))

                    Spacer().frame(height: 40)
                }
            }
        }
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.45))
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    private func benefitCard(emoji: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Text(emoji).font(.title2)
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.45))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.gcCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gcCardBorder, lineWidth: 1)
        )
    }

    private func planOption(id: String, title: String, price: String, badge: String?, isSelected: Bool) -> some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedPlan = id }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                    Text(price)
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                if let badge {
                    Text(badge)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(LinearGradient.gcOrangeGradient)
                        .clipShape(Capsule())
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.gcGreen : .white.opacity(0.3))
            }
            .padding(18)
            .background(isSelected ? Color.gcGreen.opacity(0.06) : Color.gcCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.gcGreen.opacity(0.4) : Color.gcCardBorder, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
