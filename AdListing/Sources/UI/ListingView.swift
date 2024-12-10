//
//  ListingView.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import SwiftUI

public struct ListingView: View {

    @ObservedObject var viewModel: ListingViewModel
    private let coordinator: ListingCoordinator

    private static let spacing = 14.0
    private static let columns = [
        GridItem(.flexible(), spacing: spacing),
        GridItem(.flexible()),
    ]

    public init(_ vm: ListingViewModel, coordinator c: ListingCoordinator) {
        viewModel = vm
        coordinator = c
    }

    @State private var isRefreshing = false

    public var body: some View {

        RefreshableScrollView(viewModel: viewModel) {
            LazyVGrid(columns: Self.columns, spacing: Self.spacing) {
                ForEach(viewModel.loaded) { ad in
                    Thumbnail(ad: ad, viewModel: viewModel).task {
                        viewModel.preload(ad.ui_index)
                    }.onTapGesture {
                        coordinator.presentDetail(id: ad.ad_id)
                    }
                }
            }
            .padding(.horizontal, Self.spacing)
        }

        .background(Color("ListingBack"))
        .overlay {
            ProgressView()
                .scaleEffect(2.0)
                .opacity(viewModel.loaded.isEmpty ? 1.0 : 0.0)
        }
        .onAppear {
            viewModel.autoload()
        }

    }

}

private struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct RefreshableScrollView<Content: View>: View {

    let viewModel: ListingViewModel
    let content: () -> Content

    @State private var isRefreshing = false

    public var body: some View {

        if #available(iOS 16.0, *) {

            ScrollView {
                content()
            }
            .refreshable {
                viewModel.refresh()
            }

        } else {

            ScrollView {
                content()
            }
            .background(
                GeometryReader {
                    Color.clear.preference(
                        key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("scroll")).origin.y)
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) {
                if $0 < -100 && !isRefreshing {
                    isRefreshing = true
                    Task {
                        viewModel.refresh()
                        await MainActor.run {
                            isRefreshing = false
                        }
                    }
                }
            }
            .coordinateSpace(name: "scroll")
        }
    }
}

struct Thumbnail: View {

    let ad: Ad
    let viewModel: ListingViewModel

    fileprivate static let spacing = 6.0
    fileprivate static let rounded = 8.0

    var body: some View {
        VStack(alignment: .leading, spacing: Self.spacing) {
            TopImage(ad: ad, toReload: viewModel.markToReload(_:))
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

    let ad: Ad
    let toReload: (Int) -> ()

    var body: some View {

        AsyncImage(url: URL(string: ad.thumbnailURL)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color("ListingBorder")
                    ProgressView()
                }
            case .success(let image):
                image.resizable()
            case .failure:
                Color.white.task {
                    toReload(ad.ui_index)
                }
            @unknown default:
                Color.white.task {
                    print("WHAT !!!")
                }
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
    ListingView(ListingViewModel(), coordinator: FakeCoordinator())
}

private struct FakeCoordinator: ListingCoordinator {
    func presentDetail(id: String) {
    }

}
