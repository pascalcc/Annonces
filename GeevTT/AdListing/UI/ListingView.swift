//
//  ListingView.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import SwiftUI

public struct ListingView: View {

    @StateObject var viewModel: ListingViewModel

    private static let spacing = 14.0
    private static let columns = [
        GridItem(.flexible(), spacing: spacing),
        GridItem(.flexible()),
    ]

    @State private var adDetail: Ad? = nil

    public var body: some View {

        ScrollView {
            LazyVGrid(columns: Self.columns, spacing: Self.spacing) {
                ForEach(viewModel.loaded) { ad in
                    Thumbnail(ad: ad).task {
                        viewModel.preload(ad.ui_index)
                    }.onTapGesture {
                        //TODO with Coordinator?
                        adDetail = ad
                    }

                }
            }
            .padding(.horizontal, Self.spacing)
        }
        .background(Color("ListingBack"))
        .refreshable {
            viewModel.refresh()
        }
        .onAppear {
            viewModel.refresh()
        }
        .fullScreenCover(
            item: $adDetail,
            onDismiss: { adDetail = nil }
        ) { ad in
            DetailView(viewModel: DetailViewModel(id: ad.id))
        }
    }

}

struct Thumbnail: View {

    let ad: Ad

    fileprivate static let spacing = 6.0
    fileprivate static let rounded = 8.0

    var body: some View {
        VStack(alignment: .leading, spacing: Self.spacing) {
            TopImage(imageUrl: ad.thumbnailURL, isReserved: ad.reserved)
            Description(text: ad.title)
            InfosView(
                time: ad.formattedTime(),
                distance: ad.formattedDistance()
            )
        }
        .background(.white)
        .cornerRadius(Self.rounded)
        .overlay {
            RoundedRectangle(cornerRadius: Self.rounded)
                .stroke(Color("ListingBorder"))
        }
    }
}

struct TopImage: View {

    let imageUrl: String
    let isReserved: Bool

    var body: some View {

        AsyncImage(url: URL(string: imageUrl)) { phase in
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
        .frame(height: 170)
        .overlay {
            GeometryReader { geometry in
                Text("Réservé")
                    .frame(width: geometry.size.width, height: 25)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
                    .background(.red)
                    .opacity(isReserved ? 1 : 0)
                    .offset(y: geometry.size.height - 25)
            }
        }

    }

}

struct Description: View {

    let text: String

    fileprivate static let spacingText = 10.0

    var body: some View {

        VStack(alignment: .leading) {
            Text(text)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .font(.system(size: 14, weight: .regular))
                .padding(.leading, Self.spacingText)
            Spacer(minLength: 1)
        }
        .frame(height: 52)
        .padding(.top, Thumbnail.spacing)

    }
}

struct InfosView: View {

    let time: String
    let distance: String

    var body: some View {
        HStack(alignment: .top) {
            InfoView(info: .time, text: time)
            InfoView(info: .distance, text: distance)
        }
        .padding(Thumbnail.spacing)
        .padding(.leading, Description.spacingText - Thumbnail.spacing)
    }

}

struct InfoView: View {

    enum Info {
        case time, distance

        func icon() -> String {
            switch self {
            case .time: return "icon-clock"
            case .distance: return "icon-pin"
            }
        }
    }

    let info: Info
    let text: String

    var body: some View {
        HStack {
            Image(info.icon())
                .resizable()
                .frame(width: 14, height: 14).padding(0)
            Text(text)
                .font(.system(size: 12, weight: .light))
            Spacer()
        }
    }
}

#Preview {
    ListingView(viewModel: ListingViewModel())
}
