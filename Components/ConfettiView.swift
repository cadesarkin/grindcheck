import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let color: Color
    let size: CGFloat
    let rotation: Double
    let speed: Double
}

struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    @State private var animate = false
    let colors: [Color]

    init(colors: [Color] = [.gcGreen, .gcOrange, .white, .gcGreen.opacity(0.7)]) {
        self.colors = colors
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 0.6)
                        .rotationEffect(.degrees(animate ? piece.rotation + 360 : piece.rotation))
                        .position(
                            x: piece.x,
                            y: animate ? geo.size.height + 50 : piece.y
                        )
                        .opacity(animate ? 0 : 1)
                }
            }
            .onAppear {
                pieces = (0..<60).map { _ in
                    ConfettiPiece(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: CGFloat.random(in: -100...0),
                        color: colors.randomElement() ?? .white,
                        size: CGFloat.random(in: 6...12),
                        rotation: Double.random(in: 0...360),
                        speed: Double.random(in: 2...4)
                    )
                }
                withAnimation(.easeIn(duration: 3)) {
                    animate = true
                }
            }
        }
        .allowsHitTesting(false)
    }
}
