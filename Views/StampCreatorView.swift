import SwiftUI

struct StampCreatorView: View {
    @State private var selectedImage: UIImage?
    @State private var isBlackAndWhite = false
    @State private var priceText = "100"
    @State private var frameStyle: StampFrameStyle = .classic
    @State private var isShowingPicker = false

    private var price: Int {
        let value = Int(priceText) ?? 0
        return min(max(value, 1), 999)
    }

    private var canProceed: Bool {
        selectedImage != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    photoArea

                    filterSection

                    priceSection

                    frameStyleSection

                    NavigationLink(destination: LetterWriterView()) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(canProceed ? Color.red : Color.gray.opacity(0.5))
                            .cornerRadius(14)
                    }
                    .disabled(!canProceed)
                }
                .padding()
            }
            .navigationTitle("우표 만들기")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingPicker) {
                PhotoPickerView(selectedImage: $selectedImage)
            }
        }
    }

    private var photoArea: some View {
        Group {
            if let image = selectedImage {
                StampPreview(image: image, isBlackAndWhite: isBlackAndWhite, price: price, frameStyle: frameStyle)
                    .frame(height: 260)
            } else {
                Button(action: { isShowingPicker = true }) {
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.red)

                        Text("사진 선택하기")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                            .foregroundColor(.gray.opacity(0.6))
                    )
                }
            }
        }
        .animation(.easeInOut, value: selectedImage)
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("필터 선택")
                .font(.headline)

            HStack(spacing: 12) {
                filterButton(title: "컬러", isSelected: !isBlackAndWhite) {
                    isBlackAndWhite = false
                }
                filterButton(title: "흑백", isSelected: isBlackAndWhite) {
                    isBlackAndWhite = true
                }
            }
        }
    }

    private func filterButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(isSelected ? Color.red : Color(.systemGray6))
                .cornerRadius(12)
        }
    }

    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("가격 입력")
                .font(.headline)

            HStack {
                TextField("1~999", text: $priceText)
                    .keyboardType(.numberPad)
                    .padding(14)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(12)
                    .onChange(of: priceText) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            priceText = filtered
                        }
                        if let value = Int(filtered), value > 999 {
                            priceText = "999"
                        }
                    }

                Text("원")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 8)
            }
        }
    }

    private var frameStyleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("우표 프레임")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(StampFrameStyle.allCases) { style in
                        Button(action: { frameStyle = style }) {
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(style.previewColor.opacity(0.3))
                                    .frame(width: 84, height: 84)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(frameStyle == style ? Color.red : Color.clear, lineWidth: 3)
                                    )

                                Text(style.displayName)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

private struct StampPreview: View {
    let image: UIImage
    let isBlackAndWhite: Bool
    let price: Int
    let frameStyle: StampFrameStyle

    var body: some View {
        VStack {
            StampView(stamp: Stamp(image: image, isBlackAndWhite: isBlackAndWhite, price: price, frameStyle: frameStyle), size: 220)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
}

struct StampCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        StampCreatorView()
    }
}
