import SwiftUI
import UIKit

enum StampFrameStyle: String, CaseIterable, Codable, Identifiable {
    case classic
    case modern
    case vintage

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classic:
            return "클래식"
        case .modern:
            return "모던"
        case .vintage:
            return "빈티지"
        }
    }

    var previewColor: Color {
        switch self {
        case .classic:
            return .red
        case .modern:
            return .gray
        case .vintage:
            return Color.brown.opacity(0.8)
        }
    }
}

struct Stamp: Identifiable, Codable {
    let id: UUID
    let image: UIImage
    let isBlackAndWhite: Bool
    let price: Int
    let frameStyle: StampFrameStyle

    init(
        id: UUID = UUID(),
        image: UIImage,
        isBlackAndWhite: Bool = false,
        price: Int = 100,
        frameStyle: StampFrameStyle = .classic
    ) {
        self.id = id
        self.image = image
        self.isBlackAndWhite = isBlackAndWhite
        self.price = price
        self.frameStyle = frameStyle
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case imageData
        case isBlackAndWhite
        case price
        case frameStyle
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isBlackAndWhite, forKey: .isBlackAndWhite)
        try container.encode(price, forKey: .price)
        try container.encode(frameStyle, forKey: .frameStyle)

        guard let imageData = image.pngData() else {
            let context = EncodingError.Context(codingPath: [CodingKeys.imageData], debugDescription: "Unable to encode UIImage as PNG data.")
            throw EncodingError.invalidValue(image, context)
        }

        try container.encode(imageData, forKey: .imageData)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        isBlackAndWhite = try container.decode(Bool.self, forKey: .isBlackAndWhite)
        price = try container.decode(Int.self, forKey: .price)
        frameStyle = try container.decode(StampFrameStyle.self, forKey: .frameStyle)

        let imageData = try container.decode(Data.self, forKey: .imageData)
        guard let decodedImage = UIImage(data: imageData) else {
            let context = DecodingError.Context(codingPath: [CodingKeys.imageData], debugDescription: "Unable to decode image data into UIImage.")
            throw DecodingError.dataCorrupted(context)
        }
        image = decodedImage
    }
}
