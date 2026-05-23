import SwiftUI

struct StampView: View {
    let stamp: Stamp
    let size: CGFloat

    init(stamp: Stamp, size: CGFloat = 120) {
        self.stamp = stamp
        self.size = size
    }

    private var stampBackground: Color {
        switch stamp.frameStyle {
        case .classic:
            return Color.white
        case .modern:
            return Color(.systemGray6)
        case .vintage:
            return Color(red: 0.96, green: 0.91, blue: 0.78)
        }
    }

    private var stampBorder: Color {
        switch stamp.frameStyle {
        case .classic:
            return Color(red: 0.82, green: 0.82, blue: 0.82)
        case .modern:
            return Color.gray.opacity(0.55)
        case .vintage:
            return Color(red: 0.68, green: 0.56, blue: 0.37)
        }
    }

    private var accentBar: some View {
        Group {
            if stamp.frameStyle == .classic {
                Rectangle()
                    .fill(Color.red.opacity(0.8))
                    .frame(height: 6)
                    .cornerRadius(3)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
            }
        }
    }

    private var priceText: some View {
        Text("\(stamp.price)원")
            .font(.system(size: size * 0.11, weight: .semibold, design: .serif))
            .foregroundColor(.primary)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.2))
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                stampBackground
                Image(uiImage: stamp.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size * 0.9, height: size * 0.72)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .grayscale(stamp.isBlackAndWhite ? 1.0 : 0.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(stampBorder.opacity(0.8), lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    .padding(.top, 12)

                accentBar
            }
            .frame(height: size * 0.72)

            priceText
                .frame(height: size * 0.19)
        }
        .frame(width: size, height: size)
        .background(stampBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(stampBorder, lineWidth: stamp.frameStyle == .modern ? 1.2 : 2)
        )
        .overlay(PerforationDots(dotSize: max(4, size * 0.045)), alignment: .center)
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
    }
}

private struct StampPerforatedShape: Shape {
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let inset = cornerRadius / 4
        let adjustedRect = rect.insetBy(dx: inset, dy: inset)
        let scallopRadius = min(rect.width, rect.height) * 0.045
        let horizontalCount = max(6, Int((adjustedRect.width - scallopRadius) / (scallopRadius * 2.5)))
        let verticalCount = max(4, Int((adjustedRect.height - scallopRadius) / (scallopRadius * 2.5)))

        path.addRoundedRect(in: adjustedRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))

        for index in 0..<horizontalCount {
            let x = adjustedRect.minX + scallopRadius + CGFloat(index) * ((adjustedRect.width - scallopRadius * 2) / CGFloat(horizontalCount - 1))
            let topCircle = CGRect(x: x - scallopRadius, y: adjustedRect.minY - scallopRadius, width: scallopRadius * 2, height: scallopRadius * 2)
            let bottomCircle = CGRect(x: x - scallopRadius, y: adjustedRect.maxY - scallopRadius, width: scallopRadius * 2, height: scallopRadius * 2)
            path.addEllipse(in: topCircle)
            path.addEllipse(in: bottomCircle)
        }

        for index in 0..<verticalCount {
            let y = adjustedRect.minY + scallopRadius + CGFloat(index) * ((adjustedRect.height - scallopRadius * 2) / CGFloat(verticalCount - 1))
            let leftCircle = CGRect(x: adjustedRect.minX - scallopRadius, y: y - scallopRadius, width: scallopRadius * 2, height: scallopRadius * 2)
            let rightCircle = CGRect(x: adjustedRect.maxX - scallopRadius, y: y - scallopRadius, width: scallopRadius * 2, height: scallopRadius * 2)
            path.addEllipse(in: leftCircle)
            path.addEllipse(in: rightCircle)
        }

        return path
    }
}

private struct PerforationDots: View {
    let dotSize: CGFloat

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let horizontalCount = max(5, Int((width - dotSize) / (dotSize * 2.4)))
            let verticalCount = max(4, Int((height - dotSize) / (dotSize * 2.4)))
            let horizontalSpacing = horizontalCount > 1 ? (width - dotSize * CGFloat(horizontalCount)) / CGFloat(horizontalCount - 1) : 0
            let verticalSpacing = verticalCount > 1 ? (height - dotSize * CGFloat(verticalCount)) / CGFloat(verticalCount - 1) : 0

            ZStack {
                VStack {
                    HStack(spacing: horizontalSpacing) {
                        ForEach(0..<horizontalCount, id: \ .self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.85))
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                    Spacer()
                    HStack(spacing: horizontalSpacing) {
                        ForEach(0..<horizontalCount, id: \ .self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.85))
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                }
                HStack {
                    VStack(spacing: verticalSpacing) {
                        ForEach(0..<verticalCount, id: \ .self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.85))
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                    Spacer()
                    VStack(spacing: verticalSpacing) {
                        ForEach(0..<verticalCount, id: \ .self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.85))
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                }
            }
            .padding(dotSize)
        }
        .allowsHitTesting(false)
    }
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(systemName: "photo") ?? UIImage()
        let sampleStamp = Stamp(image: sampleImage, isBlackAndWhite: false, price: 150, frameStyle: .classic)

        VStack(spacing: 24) {
            StampView(stamp: sampleStamp, size: 140)
            StampView(stamp: Stamp(image: sampleImage, isBlackAndWhite: true, price: 220, frameStyle: .vintage), size: 140)
            StampView(stamp: Stamp(image: sampleImage, isBlackAndWhite: false, price: 320, frameStyle: .modern), size: 140)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
