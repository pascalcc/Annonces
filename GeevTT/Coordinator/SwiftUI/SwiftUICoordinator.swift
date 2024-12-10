//
//  SwiftUICoordinator.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import AdDetail
import AdListing
import SwiftUI
import UIKit

class SwiftUICoordinator: AppCoordinator, ObservableObject {

    @Published var showingDetail: AdDetailID?

    var listingViewModel = ListingViewModel()

    func start() -> UIViewController {
        let home = MainView(coordinator: self)
        return UIHostingController(rootView: home)
    }

    func buildListing() -> some View {
        ListingView(listingViewModel, coordinator: self)
    }

    func buildDetail(id: String) -> some View {
        DetailView(DetailViewModel(id: id), coordinator: self)
    }

    func presentDetail(id: String) {
        assert(showingDetail == nil)
        showingDetail = AdDetailID(id: id)
    }

    func dismissDetail() {
        showingDetail = nil
        listingViewModel.autoload()
    }
}

struct AdDetailID: Identifiable {
    let id: String
}
