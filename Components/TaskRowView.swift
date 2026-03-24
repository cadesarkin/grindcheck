import SwiftUI

struct TaskRowView: View {
    let task: GrindTask
    let onComplete: () -> Void

    @State private var showXP = false

    var body: some View {
        Button(action: {
            guard !task.isCompletedToday else { return }
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            onComplete()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                showXP = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { showXP = false }
            }
        }) {
            HStack(spacing: 14) {
                Text(task.emoji)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 3) {
                    Text(task.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(task.isCompletedToday ? Color.gcGreen : .white)

                    Text(task.category.uppercased())
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.35))
                        .tracking(1)
                }

                Spacer()

                if task.isCompletedToday {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.gcGreen)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text("+\(task.pointValue)")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            .gcCard(completed: task.isCompletedToday)
            .overlay(alignment: .trailing) {
                if showXP {
                    Text("+\(task.pointValue) pts")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.gcGreen)
                        .offset(y: -30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: task.isCompletedToday)
    }
}
