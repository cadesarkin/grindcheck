import SwiftUI

struct CommitmentView: View {
    let onContinue: () -> Void

    @State private var badgeScale: CGFloat = 0.3
    @State private var badgeOpacity: Double = 0
    @State private var glowOpacity: Double = 0
    @State private var showContent = false
    @State private var showFlame = false
    @State private var permissionGranted = false

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Text("Your accountability streak\nstarts today.")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                // Day 1 badge
                ZStack {
                    // Glow
                    Circle()
                        .fill(RadialGradient(
                            colors: [Color.gcGreen.opacity(0.3), .clear],
                            center: .center, startRadius: 0, endRadius: 80
                        ))
                        .frame(width: 200, height: 200)
                        .opacity(glowOpacity)

                    VStack(spacing: 4) {
                        Text("DAY")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white.opacity(0.6))
                            .tracking(3)
                        Text("1")
                            .font(.system(size: 72, weight: .heavy, design: .monospaced))
                            .foregroundStyle(Color.gcGreen)
                    }
                    .scaleEffect(badgeScale)
                    .opacity(badgeOpacity)
                }
                .frame(height: 160)

                if showContent {
                    Text("Founders who track daily are 4x more likely to hit their 90-day goals.")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .transition(.opacity)
                }

                if showFlame {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.gcOrange, .gcGreen],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                if showContent {
                    VStack(spacing: 12) {
                        if !permissionGranted {
                            Button("Turn on daily check-in reminder") {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                Task {
                                    let granted = await NotificationService.shared.requestPermission()
                                    if granted {
                                        NotificationService.shared.scheduleStreakWarning()
                                        NotificationService.shared.scheduleDailyReminder(hour: 8, minute: 0)
                                    }
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                                        permissionGranted = true
                                        showFlame = true
                                    }
                                }
                            }
                            .buttonStyle(GCSecondaryButtonStyle())
                            .transition(.opacity)

                            Button("I'll manage without reminders") {
                                withAnimation { permissionGranted = true; showFlame = true }
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.35))
                        }

                        if permissionGranted {
                            Button("Lock in my streak →") {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                onContinue()
                            }
                            .buttonStyle(GCPrimaryButtonStyle())
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding(.horizontal, 24)
                    .transition(.opacity)
                }

                Spacer().frame(height: 30)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3)) {
                badgeScale = 1.0
                badgeOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.6)) {
                glowOpacity = 0.8
            }
            withAnimation(.easeIn(duration: 0.5).delay(1.0)) {
                showContent = true
            }
        }
    }
}
