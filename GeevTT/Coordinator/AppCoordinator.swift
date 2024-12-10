//
//  AppCordinator.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import AdDetail
import AdListing
import UIKit

@MainActor
protocol AppCoordinator: DetailCoordinator, ListingCoordinator {
    func start() -> UIViewController
    func presentDetail(id: String)
    func dismissDetail()
}
