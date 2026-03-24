import SwiftUI

struct MainTabView: View {
    @StateObject private var taskStore = TaskStore()
    @State private var selectedTab = 0

    let selectedTasks: Set<TaskTemplate>

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                TodayView(store: taskStore)
                    .tag(0)

                LeaderboardView(store: taskStore)
                    .tag(1)

                StakesView()
                    .tag(2)

                ProfileView(store: taskStore)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom tab bar
            customTabBar
        }
        .preferredColorScheme(.dark)
        .onAppear {}
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "bolt.fill", label: "Grind", tab: 0)
            tabItem(icon: "chart.bar.fill", label: "Board", tab: 1)
            tabItem(icon: "dollarsign.circle.fill", label: "Stakes", tab: 2)
            tabItem(icon: "person.fill", label: "Profile", tab: 3)
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 0))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 0.5)
        }
    }

    private func tabItem(icon: String, label: String, tab: Int) -> some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedTab = tab }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(selectedTab == tab ? Color.gcGreen : .white.opacity(0.4))

                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(selectedTab == tab ? Color.gcGreen : .white.opacity(0.4))

                Circle()
                    .fill(selectedTab == tab ? Color.gcGreen : .clear)
                    .frame(width: 4, height: 4)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
