//
//  LikesHistoryView.swift
//  profounded
//
//  Created by Hisham Zannoun on 7/4/24.
//

import SwiftUI

struct LikesHistoryView: View {
    @State private var likes: [Like] = []

    var body: some View {
        ZStack {
            Color(UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0))
                .edgesIgnoringSafeArea(.all)

            VStack {
                ScrollView {
                    VStack(spacing: 15) { // Adding spacing between cards
                        ForEach(likes) { like in
                            LikeCardView(like: like)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
        .onAppear {
            fetchLikes()
        }
    }

    private func fetchLikes() {
        let currentUserId: Int64 = 2 // Hardcoded user ID for now

        DatabaseManager.shared.fetchAllLikes(for: currentUserId) { fetchedLikes in
            likes = fetchedLikes
            print("Fetched likes: \(fetchedLikes)")
        }
    }
}

struct LikeCardView: View {
    var like: Like

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(like.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .italic()

            HStack {
                Button(action: {}) {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(like.isLike ? Color(red: 0.85, green: 0.65, blue: 0.13) : Color.gray.opacity(0.5))
                }
                .disabled(true)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(!like.isLike ? Color(red: 0.85, green: 0.65, blue: 0.13) : Color.gray.opacity(0.5))
                }
                .disabled(true)
            }

            Text(like.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0))) // Matching card color to the rest of the app
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .frame(maxWidth: .infinity, alignment: .center)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    LikesHistoryView()
}

