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

    func updateUIViewController(
        _ uiViewController: UIViewControllerType, context: Context
    ) {
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        DetailViewController(viewModel, coordinator: coordinator)
    }
}
