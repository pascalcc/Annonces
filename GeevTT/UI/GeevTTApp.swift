//
//  GeevTTApp.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import SwiftUI

@main
struct GeevTTApp: App {
    
    let ads = ListingViewModel()
    
    var body: some Scene {
        WindowGroup {
            ListingView(viewModel: ads)
        }
    }
}
