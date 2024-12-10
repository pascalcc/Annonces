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

        if #available(iOS 16.0, *) {
            TabView {
                ForEach(images) { image in
                    AutoLoadImage(url: image.url)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        } else {
            AutoLoadImage(url: images.first!.url)
        }

    }
}

struct AutoLoadImage: View {

    let url: String

    var body: some View {

        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color("ListingBorder")
                    ProgressView()
                }
            case .success(let image):
                image.resizable()
            case .failure:
                Color.white
            @unknown default:
                Color.white
            }
        }
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
