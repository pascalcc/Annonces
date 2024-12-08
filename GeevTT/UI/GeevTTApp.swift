//
//  GeevTTApp.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import SwiftUI

@main
struct GeevTTApp: App {
    
    let ads = Ads()
    
    var body: some Scene {
        WindowGroup {
            ListingView(ads: ads)
        }
    }
}
