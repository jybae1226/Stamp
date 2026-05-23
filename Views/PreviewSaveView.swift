import SwiftUI
import UIKit

struct PreviewSaveView: View {
    let letter: Letter

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LetterPaperView(letter: letter)
                    .padding()
            }
            .background(Color(.systemGroupedBackground))

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    actionButton(title: "저장하기", color: .red) {
                        saveToPhotoLibrary()
                    }
                    actionButton(title: "공유하기", color: .blue) {
                        shareLetter()
                    }
                }

                HStack(spacing: 12) {
                    actionButton(title: "보관함에 저장", color: .orange) {
                        saveToArchive()
                    }
                    Button(action: { dismiss() }) {
                        Text("다시 편집")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Color(.systemGray5))
                            .cornerRadius(14)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground).shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: -2))
        }
        .navigationTitle("미리보기")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityViewController(activityItems: shareItems)
        }
    }

    private func actionButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(color)
                .cornerRadius(14)
        }
    }

    private func renderLetterImage() -> UIImage? {
        let renderer = ImageRenderer(content: LetterPaperView(letter: letter).frame(width: 700, height: 1000))
        renderer.scale = 3
        return renderer.uiImage
    }

    private func saveToPhotoLibrary() {
        guard let image = renderLetterImage() else {
            showError("이미지 생성에 실패했습니다.")
            return
        }
        PhotoSaver { result in
            switch result {
            case .success:
                showSuccess("사진 앱에 저장되었어요 📮")
            case .failure(let error):
                showError("저장에 실패했어요: \(error.localizedDescription)")
            }
        }.writeToPhotoAlbum(image)
    }

    private func shareLetter() {
        guard let image = renderLetterImage() else {
            showError("공유할 이미지를 생성하지 못했어요.")
            return
        }
        shareItems = [image]
        showShareSheet = true
    }

    private func saveToArchive() {
        guard let image = renderLetterImage() else {
            showError("보관용 이미지를 생성하지 못했어요.")
            return
        }
        guard let imagePath = saveImageToDocuments(image: image) else {
            showError("이미지 파일 저장에 실패했습니다.")
            return
        }

        var archivedLetter = letter
        archivedLetter = Letter(
            id: letter.id,
            stamp: letter.stamp,
            paperStyle: letter.paperStyle,
            stampPosition: letter.stampPosition,
            content: letter.content,
            font: letter.font,
            textColor: letter.textColor,
            senderName: letter.senderName,
            receiverName: letter.receiverName,
            createdAt: letter.createdAt,
            imagePath: imagePath
        )

        var savedLetters = loadSavedLetters()
        savedLetters.append(archivedLetter)
        saveLetters(savedLetters)
        showSuccess("편지가 보관함에 저장되었어요.")
    }

    private func saveImageToDocuments(image: UIImage) -> String? {
        guard let data = image.pngData() else { return nil }
        let filename = "letter_\(letter.id.uuidString).png"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return url.path
        } catch {
            return nil
        }
    }

    private func loadSavedLetters() -> [Letter] {
        let key = "SavedLetters"
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Letter].self, from: data)) ?? []
    }

    private func saveLetters(_ letters: [Letter]) {
        let key = "SavedLetters"
        if let data = try? JSONEncoder().encode(letters) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func showSuccess(_ message: String) {
        alertTitle = "성공"
        alertMessage = message
        showAlert = true
    }

    private func showError(_ message: String) {
        alertTitle = "오류"
        alertMessage = message
        showAlert = true
    }
}

private class PhotoSaver: NSObject {
    private let completion: (Result<Void, Error>) -> Void

    init(completion: @escaping (Result<Void, Error>) -> Void) {
        self.completion = completion
    }

    func writeToPhotoAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }
}

private struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct PreviewSaveView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(systemName: "photo") ?? UIImage()
        let sampleStamp = Stamp(image: sampleImage, isBlackAndWhite: false, price: 150, frameStyle: .classic)
        let sampleLetter = Letter(
            stamp: sampleStamp,
            paperStyle: .floral,
            stampPosition: .topRight,
            content: "안녕하세요! 여기에 편지를 써주세요...",
            font: .handwriting,
            textColor: .black,
            senderName: "민지",
            receiverName: "지우",
            createdAt: Date()
        )
        NavigationStack {
            PreviewSaveView(letter: sampleLetter)
        }
    }
}
