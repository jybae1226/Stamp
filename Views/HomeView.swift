import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1.0, green: 0.97, blue: 0.93)
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Text("📮 StampLetter")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.45, green: 0.18, blue: 0.12))

                        Text("나만의 우표로 쓰는 편지")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.44, green: 0.24, blue: 0.12))
                    }
                    .padding(.top, 24)

                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)

                        VStack(spacing: 24) {
                            HStack(spacing: 18) {
                                Image(systemName: "envelope.open.fill")
                                    .font(.system(size: 42))
                                    .foregroundColor(Color(red: 0.76, green: 0.24, blue: 0.18))
                                    .padding(18)
                                    .background(Color(red: 1.0, green: 0.93, blue: 0.88))
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("나만의 우표 편지를 만들어요")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text("사진과 손글씨가 담긴 감성 편지를 작성해보세요.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }

                            HStack(spacing: 14) {
                                StampIconView(symbol: "stamp.fill", color: Color(red: 0.81, green: 0.30, blue: 0.21))
                                StampIconView(symbol: "square.and.pencil", color: Color(red: 0.96, green: 0.56, blue: 0.34))
                                StampIconView(symbol: "sparkles", color: Color(red: 0.95, green: 0.81, blue: 0.53))
                            }
                        }
                        .padding(28)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        NavigationLink(destination: StampCreatorView()) {
                            Text("✉️ 새 편지 만들기")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 54)
                                .background(Color(red: 0.76, green: 0.24, blue: 0.18))
                                .cornerRadius(18)
                        }

                        NavigationLink(destination: ArchiveView()) {
                            Text("📁 내 편지 보관함")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.76, green: 0.24, blue: 0.18))
                                .frame(maxWidth: .infinity, minHeight: 54)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color(red: 0.76, green: 0.24, blue: 0.18), lineWidth: 2)
                                )
                                .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
    }
}

private struct StampIconView: View {
    let symbol: String
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.18))
                .frame(width: 72, height: 72)
            Image(systemName: symbol)
                .font(.system(size: 28))
                .foregroundColor(color)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
