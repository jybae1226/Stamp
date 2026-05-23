import SwiftUI

struct LetterWriterView: View {
    let stamp: Stamp

    @State private var paperStyle: LetterPaperStyle = .white
    @State private var stampPosition: StampPosition = .topRight
    @State private var font: LetterFont = .handwriting
    @State private var textColor: Color = .black
    @State private var receiverName = ""
    @State private var senderName = ""
    @State private var content = ""
    @State private var createdAt = Date()

    private var currentLetter: Letter {
        Letter(
            stamp: stamp,
            paperStyle: paperStyle,
            stampPosition: stampPosition,
            content: content,
            font: font,
            textColor: textColor,
            senderName: senderName,
            receiverName: receiverName,
            createdAt: createdAt
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        LetterPaperView(letter: currentLetter)
                            .frame(height: 380)
                            .padding(.horizontal)

                        customizationPanel
                            .padding(.horizontal)
                    }
                    .padding(.top)
                }

                NavigationLink(destination: PreviewSaveView(letter: currentLetter)) {
                    Text("완성하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.red)
                        .cornerRadius(16)
                        .padding([.horizontal, .bottom])
                }
            }
            .navigationTitle("편지 쓰기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var customizationPanel: some View {
        VStack(spacing: 24) {
            sectionTitle("편지지 선택")
            paperStylePicker

            sectionTitle("우표 위치")
            stampPositionGrid

            sectionTitle("폰트 선택")
            fontPicker

            sectionTitle("글자 색상")
            textColorPicker

            sectionTitle("받는 사람 / 보내는 사람")
            nameFields

            sectionTitle("편지 내용")
            messageEditor
        }
        .padding(.vertical)
    }

    private func sectionTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
    }

    private var paperStylePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(LetterPaperStyle.allCases) { style in
                    Button(action: { paperStyle = style }) {
                        VStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(style.previewColor)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(paperStyle == style ? Color.red : Color.clear, lineWidth: 3)
                                )
                            Text(style.displayName)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .padding(8)
                        .background(Color(.systemBackground))
                        .cornerRadius(18)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 3)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var stampPositionGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(StampPosition.allCases) { position in
                Button(action: { stampPosition = position }) {
                    VStack(spacing: 8) {
                        Image(systemName: position == .topRight || position == .bottomLeft ? "square.grid.2x2" : "square.grid.2x2")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 46, height: 46)
                            .background(paperStyle.previewColor.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text(position.displayName)
                            .font(.caption2)
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(stampPosition == position ? Color.red.opacity(0.12) : Color(.secondarySystemBackground))
                    .cornerRadius(16)
                }
            }
        }
    }

    private var fontPicker: some View {
        HStack(spacing: 12) {
            ForEach(LetterFont.allCases) { item in
                Button(action: { font = item }) {
                    Text(item.displayName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(font == item ? .white : .primary)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(font == item ? Color.red : Color(.systemGray5))
                        .cornerRadius(12)
                }
            }
        }
    }

    private var textColorPicker: some View {
        let colors: [Color] = [.black, .red, .brown, .blue, .purple]
        return HStack(spacing: 12) {
            ForEach(colors, id: \.self) { color in
                Button(action: { textColor = color }) {
                    Circle()
                        .fill(color)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(textColor == color ? Color.red : Color.clear, lineWidth: 3)
                        )
                }
            }
            ColorPicker("", selection: $textColor)
                .labelsHidden()
        }
    }

    private var nameFields: some View {
        VStack(spacing: 12) {
            TextField("To.", text: $receiverName)
                .padding(14)
                .background(Color(.secondarySystemFill))
                .cornerRadius(12)
            TextField("From.", text: $senderName)
                .padding(14)
                .background(Color(.secondarySystemFill))
                .cornerRadius(12)
        }
    }

    private var messageEditor: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $content)
                .padding(12)
                .frame(minHeight: 160)
                .background(Color(.secondarySystemFill))
                .cornerRadius(16)
                .font(letterFont)

            if content.isEmpty {
                Text("여기에 편지를 써주세요...")
                    .foregroundColor(.secondary)
                    .padding(18)
            }
        }
    }

    private var letterFont: Font {
        font.font
    }
}

struct LetterWriterView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(systemName: "photo") ?? UIImage()
        let sampleStamp = Stamp(image: sampleImage, isBlackAndWhite: false, price: 150, frameStyle: .classic)
        LetterWriterView(stamp: sampleStamp)
    }
}
