//
//  UIKitCoordinator.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import UIKit
import SwiftUI
import AdDetail
import AdListing


class UIKitCoordinator : AppCoordinator {
    
    private var viewControllers: [UIViewController] = []
    
    func start() -> UIViewController {
        let swiftui = ListingView(coordinator: self)
        let home = UIHostingController(rootView: swiftui)
        viewControllers.append(home)
        return home
    }
    
    func presentDetail(id:String) {
        let vm = DetailViewModel(id: id)
        let detail = DetailViewController(vm, coordinator: self)
        
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
