//
//  DetailWrapper.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 09/12/2024.
//

import AdDetail
import SwiftUI
import UIKit

struct DetailView: UIViewControllerRepresentable {

    let viewModel: DetailViewModel
    let coordinator: DetailCoordinator

    init(_ vm: DetailViewModel, coordinator c: DetailCoordinator) {
        viewModel = vm
        coordinator = c
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewControllerType, context: Context
    ) {
        uiViewController.viewSafeAreaInsetsDidChange()
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        DetailViewController(viewModel, coordinator: coordinator)
    }
}
