import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reminderHour = 8
    @State private var reminderMinute = 0
    @State private var friendActivity = true
    @State private var stakesUpdates = true
    @State private var streakWarnings = true

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gcBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Subscription
                        settingsSection(title: "SUBSCRIPTION") {
                            settingsRow(icon: "creditcard.fill", title: "Manage Subscription") {
                                if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            settingsRow(icon: "arrow.clockwise", title: "Restore Purchase") {
                                Task { await StoreKitService.shared.restorePurchases() }
                            }
                        }

                        // Notifications
                        settingsSection(title: "NOTIFICATIONS") {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(Color.gcGreen)
                                    .frame(width: 24)
                                Text("Daily reminder")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.white)
                                Spacer()

                                Picker("Hour", selection: $reminderHour) {
                                    ForEach(5..<23) { hour in
                                        Text("\(hour):00").tag(hour)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color.gcGreen)
                            }
                            .gcCard()
                            .onChange(of: reminderHour) { _, newValue in
                                NotificationService.shared.scheduleDailyReminder(hour: newValue, minute: 0)
                            }

                            toggleRow(icon: "person.2.fill", title: "Friend activity", isOn: $friendActivity)
                            toggleRow(icon: "dollarsign.circle.fill", title: "Stakes updates", isOn: $stakesUpdates)
                            toggleRow(icon: "flame.fill", title: "Streak warnings", isOn: $streakWarnings)
                        }

                        // Legal
                        settingsSection(title: "LEGAL") {
                            settingsRow(icon: "lock.shield.fill", title: "Privacy Policy") {}
                            settingsRow(icon: "doc.text.fill", title: "Terms of Use") {}
                        }

                        Text("GrindCheck v1.0")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.2))
                            .padding(.top, 8)

                        Spacer().frame(height: 40)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.gcGreen)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func settingsSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white.opacity(0.3))
                .tracking(2)
                .padding(.horizontal, 24)

            VStack(spacing: 8) {
                content()
            }
            .padding(.horizontal, 24)
        }
    }

    private func settingsRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(Color.gcGreen)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.2))
            }
            .gcCard()
        }
        .buttonStyle(.plain)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.gcGreen)
                .frame(width: 24)
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: isOn)
                .tint(Color.gcGreen)
                .labelsHidden()
        }
        .gcCard()
    }
}
