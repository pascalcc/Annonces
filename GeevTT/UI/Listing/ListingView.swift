//
//  ListingView.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import SwiftUI

struct ListingView: View {

    @StateObject var ads: Ads

    private static let spacing = 14.0
    private let columns = [
        GridItem(.flexible(), spacing: spacing),
        GridItem(.flexible()),
    ]

    var body: some View {

        ScrollView {
            LazyVGrid(columns: columns, spacing: Self.spacing) {
                ForEach(ads.loaded) { ad in
                    AdThumbnail(ad: ad).task {
                        ads.preload(ad.ui_index)
                    }
                }
            }
            .padding(.horizontal, Self.spacing)
        }
        .background(Color("ListingBack"))
        .refreshable {
            ads.refresh()
        }
        .onAppear {
            ads.refresh()
        }
    }
}

struct AdThumbnail: View {

    let ad: Ad

    fileprivate static let spacing = 6.0
    fileprivate static let spacingText = 10.0
    fileprivate static let rounded = 8.0

    var body: some View {
        VStack(alignment: .leading, spacing: Self.spacing) {
            TopImage(ad: ad)
            Description(ad: ad)
            InfosView(ad: ad)
        }
        .background(.white)
        .cornerRadius(Self.rounded)
        .overlay {
            RoundedRectangle(cornerRadius: Self.rounded)
                .stroke(Color("ListingBorder"))
        }
        .onTapGesture {
            //TODO with Coordinator
            print("selected \(ad.id)")
        }
    }
}

struct TopImage: View {

    let ad: Ad

    var body: some View {

        AsyncImage(url: URL(string: ad.thumbnailURL)) { image in
            image.resizable()
        } placeholder: {
            ZStack {
                Color("ListingBorder")
                ProgressView()
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
                    .opacity(ad.reserved ? 1 : 0)
                    .offset(y: geometry.size.height - 25)
            }

        }
    }

}

struct Description: View {

    let ad: Ad

    var body: some View {

        VStack(alignment: .leading) {
            Text(ad.title)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .font(.system(size: 14, weight: .regular))
                .padding(.leading, AdThumbnail.spacingText)
            Spacer(minLength: 1)
        }
        .frame(height: 52)
        .padding(.top, AdThumbnail.spacing)

    }
}

struct InfosView: View {

    let ad: Ad

    var body: some View {
        HStack(alignment: .top) {
            InfoView(info: .time, text: ad.formattedTime())
            InfoView(info: .distance, text: ad.formattedDistance())
        }
        .padding(AdThumbnail.spacing)
        .padding(.leading, AdThumbnail.spacingText - AdThumbnail.spacing)
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
    let ads = Ads()
    ListingView(ads: ads)
}
