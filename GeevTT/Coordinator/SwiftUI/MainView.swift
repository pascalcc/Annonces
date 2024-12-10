//
//  MainView.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import SwiftUI

struct MainView: View {

    @StateObject var coordinator: SwiftUICoordinator

    var body: some View {
        coordinator.buildListing().fullScreenCover(
            item: $coordinator.showingDetail
        ) { detail in
            coordinator.buildDetail(id: detail.id)
        }
    }
}

#Preview {
    MainView(coordinator: SwiftUICoordinator())
}
