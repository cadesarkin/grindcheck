import Foundation
import SwiftData
import SwiftUI

@MainActor
final class TaskStore: ObservableObject {
    @Published var tasks: [GrindTask] = []
    @Published var profile: UserProfile = UserProfile()
    @Published var showFullOutput = false
    @Published var lastPointsGain: Int = 0

    private var modelContext: ModelContext?

    func configure(with context: ModelContext) {
        self.modelContext = context
        loadData()
    }

    private func loadData() {
        guard let context = modelContext else { return }

        let taskDescriptor = FetchDescriptor<GrindTask>(sortBy: [SortDescriptor(\.sortOrder)])
        tasks = (try? context.fetch(taskDescriptor)) ?? []

        let profileDescriptor = FetchDescriptor<UserProfile>()
        if let existing = try? context.fetch(profileDescriptor).first {
            profile = existing
        } else {
            let newProfile = UserProfile()
            context.insert(newProfile)
            try? context.save()
            profile = newProfile
        }

        resetDailyStatusIfNeeded()
        profile.checkStreakReset()
    }

    private func resetDailyStatusIfNeeded() {
        for task in tasks {
            task.resetDailyStatus()
        }
    }

    func addTasksFromTemplates(_ templates: [TaskTemplate]) {
        guard let context = modelContext else { return }
        for (index, template) in templates.enumerated() {
            let task = GrindTask(
                name: template.name,
                emoji: template.emoji,
                category: template.category,
                pointValue: template.pointValue,
                sortOrder: index
            )
            context.insert(task)
        }
        try? context.save()
        loadData()
    }

    func completeTask(_ task: GrindTask) {
        guard !task.isCompletedToday else { return }
        task.markCompleted()
        profile.awardPoints(task.pointValue)
        lastPointsGain = task.pointValue

        let score = outputScore
        if score >= 50 {
            profile.updateStreak(outputScorePercent: Double(score))
        }

        if score == 100 {
            showFullOutput = true
        }

        try? modelContext?.save()
        objectWillChange.send()
    }

    // MARK: - Computed

    var outputScore: Int {
        ScoringEngine.outputScore(tasks: tasks)
    }

    var pointsEarnedToday: Int {
        ScoringEngine.pointsEarnedToday(tasks: tasks)
    }

    var maxPointsToday: Int {
        ScoringEngine.maxPointsToday(tasks: tasks)
    }

    var completedCount: Int {
        tasks.filter(\.isCompletedToday).count
    }

    var totalCount: Int {
        tasks.count
    }

    var streakIsSafe: Bool {
        ScoringEngine.streakIsSafe(tasks: tasks)
    }

    var weeklyScores: [(date: Date, score: Int)] {
        ScoringEngine.weeklyScores(tasks: tasks)
    }
}
