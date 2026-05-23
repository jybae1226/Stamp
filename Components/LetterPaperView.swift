import SwiftUI

struct LetterPaperView: View {
    let letter: Letter

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let paperWidth = width
            let paperHeight = width * 210 / 148

            ZStack {
                paperBackground
                    .frame(width: paperWidth, height: paperHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)

                contentLayer
                    .frame(width: paperWidth * 0.92, height: paperHeight * 0.92)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(148/210, contentMode: .fit)
    }

    private var paperBackground: some View {
        switch letter.paperStyle {
        case .kraft:
            return AnyView(
                Color(red: 0.83, green: 0.66, blue: 0.42)
                    .overlay(
                        NoiseTexture().blendMode(.overlay).opacity(0.14)
                    )
            )
        case .watercolor:
            return AnyView(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.97, green: 0.91, blue: 0.84), Color(red: 0.92, green: 0.96, blue: 0.98)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .check:
            return AnyView(
                ZStack {
                    Color.white
                    CheckPattern(lineColor: Color.gray.opacity(0.25), spacing: 18)
                }
            )
        case .floral:
            return AnyView(
                Color(red: 0.98, green: 0.95, blue: 0.88)
                    .overlay(
                        FloralDecoration()
                    )
            )
        case .white:
            return AnyView(Color.white)
        }
    }

    private var contentLayer: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                header
                Spacer()
                bodyText
                Spacer()
                footer
            }
            .padding(24)

            stampView
        }
    }

    private var header: some View {
        Text("To. \(letter.receiverName.isEmpty ? "받는 사람" : letter.receiverName)")
            .font(.system(size: 18, weight: .semibold, design: .serif))
            .foregroundColor(.black.opacity(0.85))
    }

    private var bodyText: some View {
        Text(letter.content.isEmpty ? "여기에 편지를 써주세요..." : letter.content)
            .font(letter.font.font)
            .foregroundColor(letter.textColor)
            .lineSpacing(6)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.white.opacity(0.35))
            .cornerRadius(16)
    }

    private var footer: some View {
        HStack {
            Text(letter.formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text("From. \(letter.senderName.isEmpty ? "보내는 사람" : letter.senderName)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    private var stampView: some View {
        let stampSize: CGFloat = 82
        let stampContent = StampView(stamp: letter.stamp, size: stampSize)

        switch letter.stampPosition {
        case .topRight:
            VStack {
                HStack {
                    Spacer()
                    stampContent
                }
                Spacer()
            }
        case .topLeft:
            VStack {
                HStack {
                    stampContent
                    Spacer()
                }
                Spacer()
            }
        case .bottomRight:
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    stampContent
                }
            }
        case .bottomLeft:
            VStack {
                Spacer()
                HStack {
                    stampContent
                    Spacer()
                }
            }
        }
    }
}

private struct NoiseTexture: View {
    var body: some View {
        GeometryReader { geometry in
            let columns = Int(geometry.size.width / 6)
            let rows = Int(geometry.size.height / 6)
            Canvas { context, size in
                for x in 0..<columns {
                    for y in 0..<rows {
                        let opacity = Double.random(in: 0.04...0.18)
                        let rect = CGRect(x: CGFloat(x) * 6, y: CGFloat(y) * 6, width: 4, height: 4)
                        context.fill(Path(rect), with: .color(Color.white.opacity(opacity)))
                    }
                }
            }
        }
    }
}

private struct CheckPattern: View {
    let lineColor: Color
    let spacing: CGFloat

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                var path = Path()
                for x in stride(from: 0.0, to: size.width, by: spacing) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }
                for y in stride(from: 0.0, to: size.height, by: spacing) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(path, with: .color(lineColor), lineWidth: 1)
            }
        }
    }
}

private struct FloralDecoration: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width * 0.18)
                    .foregroundColor(Color(red: 0.93, green: 0.74, blue: 0.55).opacity(0.65))
                    .position(x: size.width * 0.16, y: size.height * 0.16)

                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width * 0.16)
                    .foregroundColor(Color(red: 0.96, green: 0.84, blue: 0.62).opacity(0.55))
                    .position(x: size.width * 0.85, y: size.height * 0.18)
            }
        }
    }
}

struct LetterPaperView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(systemName: "photo") ?? UIImage()
        let sampleStamp = Stamp(image: sampleImage, isBlackAndWhite: false, price: 150, frameStyle: .classic)
        let sampleLetter = Letter(
            stamp: sampleStamp,
            paperStyle: .floral,
            stampPosition: .topRight,
            content: "안녕하세요! 여기에 사랑과 정성을 담아 편지를 씁니다. StampLetter로 특별한 인사를 전해보세요.",
            font: .handwriting,
            textColor: .black,
            senderName: "민지",
            receiverName: "지우",
            createdAt: Date()
        )

        LetterPaperView(letter: sampleLetter)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
