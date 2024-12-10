//
//  SwiftUICoordinator.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import UIKit
import SwiftUI
import AdListing
import AdDetail


struct AdDetail : Identifiable {
    let id: String
}

class SwiftUICoordinator : AppCoordinator, ObservableObject {

    @Published var showingDetail: AdDetail?
    
    func start() -> UIViewController {
        let home = MainView(coordinator: self)
        return UIHostingController(rootView: home)
    }

    //@ViewBuilder
    func buildListing() -> some View {
        ListingView(coordinator: self)
    }
    
    //@ViewBuilder
    func buildDetail(id:String) -> some View {
        DetailView(viewModel: DetailViewModel(id: id), coordinator: self)
    }
        
    func presentDetail(id: String) {
        showingDetail =  AdDetail(id: id)
    }

    func dismissDetail() {
        showingDetail = nil
    }

    
}
