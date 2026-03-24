import SwiftUI

extension Color {
    static let gcBackground = Color(red: 8/255, green: 8/255, blue: 16/255)
    static let gcGreen = Color(red: 0, green: 1, blue: 148/255)
    static let gcOrange = Color(red: 1, green: 107/255, blue: 0)
    static let gcDanger = Color(red: 1, green: 59/255, blue: 48/255)
    static let gcText = Color(red: 245/255, green: 245/255, blue: 245/255)
    static let gcMuted = Color(red: 58/255, green: 58/255, blue: 60/255)

    static let gcCardFill = Color.white.opacity(0.03)
    static let gcCardBorder = Color.white.opacity(0.06)
    static let gcCompletedFill = Color.gcGreen.opacity(0.08)
    static let gcCompletedBorder = Color.gcGreen.opacity(0.19)
}

extension LinearGradient {
    static let gcOrangeGradient = LinearGradient(
        colors: [.gcOrange, Color(red: 1, green: 149/255, blue: 0)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Button Styles

struct GCPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color.gcBackground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.gcGreen)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.gcGreen.opacity(0.3), radius: 12, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct GCSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Card Modifier

struct GCCardModifier: ViewModifier {
    var isCompleted: Bool = false

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(isCompleted ? Color.gcCompletedFill : Color.gcCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isCompleted ? Color.gcCompletedBorder : Color.gcCardBorder, lineWidth: 1)
            )
    }
}

extension View {
    func gcCard(completed: Bool = false) -> some View {
        modifier(GCCardModifier(isCompleted: completed))
    }
}
