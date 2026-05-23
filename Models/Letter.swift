import SwiftUI
import UIKit

enum LetterPaperStyle: String, CaseIterable, Codable, Identifiable {
    case kraft
    case watercolor
    case check
    case floral
    case white

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .kraft: return "크라프트"
        case .watercolor: return "수채화"
        case .check: return "체크"
        case .floral: return "플로럴"
        case .white: return "화이트"
        }
    }

    var previewColor: Color {
        switch self {
        case .kraft: return Color(red: 0.83, green: 0.66, blue: 0.42)
        case .watercolor: return Color(red: 0.93, green: 0.89, blue: 0.98)
        case .check: return Color(.systemBackground)
        case .floral: return Color(red: 0.98, green: 0.95, blue: 0.88)
        case .white: return Color.white
        }
    }
}

enum StampPosition: String, CaseIterable, Codable, Identifiable {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .topRight: return "우측 상단"
        case .topLeft: return "좌측 상단"
        case .bottomRight: return "우측 하단"
        case .bottomLeft: return "좌측 하단"
        }
    }
}

enum LetterFont: String, CaseIterable, Codable, Identifiable {
    case handwriting
    case serif
    case sans

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .handwriting: return "손글씨"
        case .serif: return "세리프"
        case .sans: return "산세리프"
        }
    }

    var font: Font {
        switch self {
        case .handwriting: return .custom("SnellRoundhand", size: 18)
        case .serif: return .serif(.body)
        case .sans: return .system(size: 18, weight: .regular, design: .default)
        }
    }
}

struct Letter: Identifiable, Codable {
    let id: UUID
    let stamp: Stamp
    let paperStyle: LetterPaperStyle
    let stampPosition: StampPosition
    let content: String
    let font: LetterFont
    let textColor: Color
    let senderName: String
    let receiverName: String
    let createdAt: Date
    let imagePath: String?

    init(
        id: UUID = UUID(),
        stamp: Stamp,
        paperStyle: LetterPaperStyle = .white,
        stampPosition: StampPosition = .topRight,
        content: String = "",
        font: LetterFont = .handwriting,
        textColor: Color = .black,
        senderName: String = "",
        receiverName: String = "",
        createdAt: Date = Date(),
        imagePath: String? = nil
    ) {
        self.id = id
        self.stamp = stamp
        self.paperStyle = paperStyle
        self.stampPosition = stampPosition
        self.content = content
        self.font = font
        self.textColor = textColor
        self.senderName = senderName
        self.receiverName = receiverName
        self.createdAt = createdAt
        self.imagePath = imagePath
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: createdAt)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case stamp
        case paperStyle
        case stampPosition
        case content
        case font
        case textColor
        case senderName
        case receiverName
        case createdAt
        case imagePath
        case red
        case green
        case blue
        case opacity
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(stamp, forKey: .stamp)
        try container.encode(paperStyle, forKey: .paperStyle)
        try container.encode(stampPosition, forKey: .stampPosition)
        try container.encode(content, forKey: .content)
        try container.encode(font, forKey: .font)
        try container.encode(senderName, forKey: .senderName)
        try container.encode(receiverName, forKey: .receiverName)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(imagePath, forKey: .imagePath)

        let uiColor = UIColor(textColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        try container.encode(Double(red), forKey: .red)
        try container.encode(Double(green), forKey: .green)
        try container.encode(Double(blue), forKey: .blue)
        try container.encode(Double(alpha), forKey: .opacity)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        stamp = try container.decode(Stamp.self, forKey: .stamp)
        paperStyle = try container.decode(LetterPaperStyle.self, forKey: .paperStyle)
        stampPosition = try container.decode(StampPosition.self, forKey: .stampPosition)
        content = try container.decode(String.self, forKey: .content)
        font = try container.decode(LetterFont.self, forKey: .font)
        senderName = try container.decode(String.self, forKey: .senderName)
        receiverName = try container.decode(String.self, forKey: .receiverName)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)

        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let opacity = try container.decode(Double.self, forKey: .opacity)
        textColor = Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
