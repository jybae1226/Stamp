import SwiftUI

struct ArchiveView: View {
    @State private var letters: [Letter] = []
    @State private var selectedLetter: Letter?
    @State private var isShowingDetail = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            Group {
                if letters.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(letters) { letter in
                                letterCell(letter)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            delete(letter)
                                        } label: {
                                            Label("삭제", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("보관함")
            .onAppear(perform: loadLetters)
            .sheet(isPresented: $isShowingDetail) {
                if let letter = selectedLetter {
                    NavigationStack {
                        PreviewSaveView(letter: letter)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("아직 편지가 없어요 ✉️")
                .font(.title3)
                .fontWeight(.semibold)
            Text("첫 편지를 써보세요!")
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func letterCell(_ letter: Letter) -> some View {
        Button(action: {
            selectedLetter = letter
            isShowingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                thumbnail(for: letter)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .clipped()

                Text(letter.receiverName.isEmpty ? "받는 사람 없음" : letter.receiverName)
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(letter.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    private func thumbnail(for letter: Letter) -> some View {
        Group {
            if let imagePath = letter.imagePath,
               let uiImage = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                LetterPaperView(letter: letter)
            }
        }
    }

    private func loadLetters() {
        let key = "SavedLetters"
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Letter].self, from: data) {
            letters = decoded
        } else {
            letters = []
        }
    }

    private func saveLetters() {
        let key = "SavedLetters"
        if let data = try? JSONEncoder().encode(letters) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func delete(_ letter: Letter) {
        withAnimation {
            letters.removeAll { $0.id == letter.id }
            saveLetters()
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
    }
}
