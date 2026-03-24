import SwiftUI

struct TaskPickerView: View {
    @Binding var selectedTasks: Set<TaskTemplate>
    let onContinue: () -> Void
    @State private var shakeOffset: CGFloat = 0

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        ZStack {
            Color.gcBackground.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer().frame(height: 50)

                VStack(spacing: 10) {
                    Text("What does your grind\nactually look like?")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("Pick the daily actions that move your needle. Be honest.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(TaskTemplate.all) { template in
                            TaskTile(
                                template: template,
                                isSelected: selectedTasks.contains(template)
                            ) {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                                    if selectedTasks.contains(template) {
                                        selectedTasks.remove(template)
                                    } else if selectedTasks.count < 8 {
                                        selectedTasks.insert(template)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                VStack(spacing: 14) {
                    Text("\(selectedTasks.count) tasks selected")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundStyle(selectedTasks.isEmpty ? .white.opacity(0.3) : Color.gcGreen)

                    Button("This is my stack →") {
                        if selectedTasks.isEmpty {
                            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { shakeOffset = 8 }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { shakeOffset = -8 }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { shakeOffset = 0 }
                            }
                            return
                        }
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        onContinue()
                    }
                    .buttonStyle(GCPrimaryButtonStyle())
                    .opacity(selectedTasks.isEmpty ? 0.4 : 1)
                    .offset(x: shakeOffset)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
    }
}

private struct TaskTile: View {
    let template: TaskTemplate
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(template.emoji)
                    .font(.title2)
                Text(template.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 8)
            .background(isSelected ? Color.gcGreen.opacity(0.1) : Color.gcCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.gcGreen.opacity(0.5) : Color.gcCardBorder, lineWidth: 1)
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.gcGreen)
                        .offset(x: -8, y: 8)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .shadow(color: isSelected ? Color.gcGreen.opacity(0.15) : .clear, radius: 8)
        }
        .buttonStyle(.plain)
    }
}
