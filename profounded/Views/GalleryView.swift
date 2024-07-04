//
//  GalleryView.swift
//  profounded
//
//  Created by Hisham Zannoun on 7/2/24.
//

import SwiftUI

struct GalleryView: View {
    var images: [GeneratedImage]

    var body: some View {
        ZStack {
            Color(UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0))
                .edgesIgnoringSafeArea(.all)

            VStack {
                if let mostRecentImage = images.first {
                    if let url = URL(string: mostRecentImage.url) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                CustomProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 350)
                                    .clipShape(Rectangle())
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 350)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .onAppear {
                            print("Loading image from URL: \(mostRecentImage.url)")
                        }
                    }
                }

                Spacer().frame(height: 50) // Spacer to push the gallery further down

                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 5) {
                    ForEach(images.dropFirst()) { image in
                        VStack {
                            if let url = URL(string: image.url) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        CustomProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 120, height: 120)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 120, height: 120)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .onAppear {
                                    print("Loading image from URL: \(image.url)")
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                            }
                            Text(image.createdAt, style: .date)
                                .font(.caption)
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
            }
        }
    }
}

