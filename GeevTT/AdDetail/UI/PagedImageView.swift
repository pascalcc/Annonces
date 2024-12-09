//
//  PagedImageView.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 09/12/2024.
//

import SwiftUI

struct PagedImageView: View {

    let images: [ImageURL]

    var body: some View {

        TabView {
            ForEach(images) { image in
                AsyncImage(url: URL(string: image.url)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color("ListingBorder")
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.white
                    @unknown default:
                        Color.white
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))

    }
}

#Preview {
    let images = [
        ImageURL(
            id: 0,
            url: "https://images.geev.fr/6756f9ddcb9d6e4a0ff5c6cd/squares/600"),
        ImageURL(
            id: 1,
            url: "https://images.geev.fr/6756f9ddcb9d6e4a0ff5c6cd/squares/600"),
    ]
    PagedImageView(images: images)
}
