//
//  UIKitCoordinator.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import AdDetail
import AdListing
import SwiftUI
import UIKit

class UIKitCoordinator: AppCoordinator {

    private var viewControllers: [UIViewController] = []

    func start() -> UIViewController {
        let home = UIHostingController(rootView: ListingView(coordinator: self))
        viewControllers.append(home)
        return home
    }

    func presentDetail(id: String) {
        assert(viewControllers.count == 1)

        let detail = DetailViewController(
            DetailViewModel(id: id), coordinator: self)
        detail.modalPresentationStyle = .fullScreen
        viewControllers.last!.present(detail, animated: true)

        viewControllers.append(detail)
    }

    func dismissDetail() {
        let current = viewControllers.removeLast()
        assert(current is DetailViewController)
        current.dismiss(animated: true)
    }

}
