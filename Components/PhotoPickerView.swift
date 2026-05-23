import SwiftUI
import PhotosUI

struct PhotoPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // No dynamic updates needed.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PhotoPickerView

        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    DispatchQueue.main.async {
                        if let image = object as? UIImage {
                            self.parent.selectedImage = image
                        }
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    @State static var previewImage: UIImage? = UIImage(systemName: "photo")

    static var previews: some View {
        PhotoPickerView(selectedImage: $previewImage)
            .previewDisplayName("Photo Picker")
    }
}

// Info.plist에 추가할 권한 키:
// NSPhotoLibraryUsageDescription: "사진 라이브러리에서 이미지를 선택하기 위해 필요합니다."