import SwiftUI
import SwiftData

@main
struct GrindCheckApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var storeKit = StoreKitService.shared
    @StateObject private var taskStore = TaskStore()
    @State private var selectedOnboardingTasks: Set<TaskTemplate> = []

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GrindTask.self,
            UserProfile.self,
            StakesBattle.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            rootView
                .modelContainer(sharedModelContainer)
                .onAppear {
                    taskStore.configure(with: sharedModelContainer.mainContext)
                }
                .preferredColorScheme(.dark)
        }
    }

    @ViewBuilder
    private var rootView: some View {
        if !hasCompletedOnboarding {
            // First launch or onboarding not complete
            OnboardingContainerView(hasCompletedOnboarding: $hasCompletedOnboarding)
                .onChange(of: hasCompletedOnboarding) { _, completed in
                    if completed {
                        // Add selected tasks from onboarding
                        // This is handled via the binding chain
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    }
                }
        } else if !storeKit.isSubscribed {
            // Returning user, not subscribed — show paywall directly
            PaywallView(
                selectedIdentities: [],
                selectedTasks: [],
                hasCompletedOnboarding: .constant(true)
            )
        } else {
            // Subscribed — main app
            MainTabView(selectedTasks: selectedOnboardingTasks)
                .environmentObject(taskStore)
        }
    }
}
