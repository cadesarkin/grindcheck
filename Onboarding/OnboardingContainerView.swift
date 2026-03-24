import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentPage = 0
    @State private var selectedIdentities: Set<String> = []
    @State private var selectedTasks: Set<TaskTemplate> = []
    @Binding var hasCompletedOnboarding: Bool

    private let totalPages = 7

    var body: some View {
        ZStack(alignment: .top) {
            Color.gcBackground.ignoresSafeArea()

            // Progress dots
            HStack(spacing: 6) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index <= currentPage ? Color.gcGreen : Color.white.opacity(0.2))
                        .frame(width: 8, height: 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                }
            }
            .padding(.top, 16)
            .zIndex(10)

            // Pages
            TabView(selection: $currentPage) {
                IdentityView(selectedIdentities: $selectedIdentities) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage = 1 }
                }
                .tag(0)

                ProblemView {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage = 2 }
                }
                .tag(1)

                ScoreboardPreviewView {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage = 3 }
                }
                .tag(2)

                TaskPickerView(selectedTasks: $selectedTasks) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage = 4 }
                }
                .tag(3)

                CommitmentView {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage = 5 }
                }
                .tag(4)

                StakesIntroView {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage = 6 }
                }
                .tag(5)

                PaywallView(
                    selectedIdentities: selectedIdentities,
                    selectedTasks: selectedTasks,
                    hasCompletedOnboarding: $hasCompletedOnboarding
                )
                .tag(6)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
        }
        .preferredColorScheme(.dark)
    }
}
