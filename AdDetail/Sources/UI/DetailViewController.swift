//
//  DetailViewController.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 09/12/2024.
//

import SwiftUI
import UIKit

public class DetailViewController: UIViewController {

    let viewModel: DetailViewModel
    let coordinator: DetailCoordinator

    required init?(coder: NSCoder) {
        fatalError("use init(vm:c:) instead")
    }

    public init(_ vm: DetailViewModel, coordinator c: DetailCoordinator) {

        viewModel = vm
        coordinator = c

        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

        viewModel.onLoaded = { [weak self] in
            guard let self else { return }
            self.recreateWithContentLoaded()
        }

        viewModel.onError = { [weak self] in
            guard let self else { return }
            self.coordinator.dismissDetail()
        }

        viewModel.fetchAd()
    }

    public override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        createEmpty()
    }

    private var isCreated = false
    private static let imageHeight = 350

    func createEmpty() {

        guard !isCreated else { return }
        isCreated = true

        let fullWidth = Int(view.frame.width)

        let image = UIView(
            frame: CGRect(
                x: 0,
                y: Int(view.safeAreaInsets.top),
                width: fullWidth,
                height: Self.imageHeight
            ))
        image.backgroundColor = UIColor(named: "ListingBack")
        view.addSubview(image)

        let wheel = UIActivityIndicatorView(style: .large)
        wheel.center = CGPoint(x: image.frame.midX, y: image.frame.midY)
        wheel.startAnimating()
        image.addSubview(wheel)
        addBackButton(over: image)
    }

    private func recreateWithContentLoaded() {

        guard let ad = viewModel.ad else { fatalError("model not ready") }

        view.subviews.forEach { $0.removeFromSuperview() }

        let spacing = 12
        let fullWidth = Int(view.frame.width)
        let fullHeight = Int(view.frame.height)

        let swiftui = PagedImageView(images: viewModel.getImagesURL())
        let image = UIHostingController(rootView: swiftui).view!
        image.frame = CGRect(
            x: 0,
            y: Int(view.safeAreaInsets.top),
            width: fullWidth,
            height: Self.imageHeight
        )
        view.addSubview(image)

        let title = UILabel(
            frame: CGRect(
                x: spacing,
                y: Int(image.frame.maxY) + spacing,
                width: fullWidth - 2 * spacing,
                height: 0
            )
        )
        title.numberOfLines = 0
        title.text = ad.title
        title.font = UIFont.boldSystemFont(ofSize: 22)
        title.sizeToFit()
        view.addSubview(title)

        let posY = Int(title.frame.maxY) + spacing
        let innerSpacing = 4
        let description = UITextView(
            frame: CGRect(
                x: spacing - innerSpacing,
                y: posY,
                width: fullWidth - 2 * (spacing - innerSpacing),
                height: fullHeight - posY - Int(view.safeAreaInsets.bottom)
                    - spacing
            )
        )
        description.isEditable = false
        description.text = ad.description
        description.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(description)

        addBackButton(over: image)

        if ad.firstContact {
            let contact = UIButton(type: .custom)
            contact.setTitle("Soyez le 1er à contacter", for: .normal)
            contact
                .setImage(
                    UIImage(systemName: "person.2"),
                    for: .normal
                )
            contact.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            contact.sizeToFit()

            let contactHeight: CGFloat = 28
            let margin: CGFloat = 8

            contact.frame.size.height = contactHeight
            contact.frame.size.width += CGFloat(2 * spacing)

            contact.center.y = (contactHeight / 2) + image.frame.minY + margin
            contact.center.x =
                CGFloat(fullWidth) - contact.frame.size.width / 2 - margin

            contact.layer.cornerRadius = 6
            contact.layer.borderWidth = 1
            contact.layer.borderColor = UIColor(named: "ListingBorder")!.cgColor
            contact.backgroundColor = .white
            let mainColor = UIColor.black
            contact.tintColor = mainColor
            contact.setTitleColor(mainColor, for: .normal)
            view.addSubview(contact)
        }
    }

    private func addBackButton(over: UIView) {
        let action = UIAction { [weak self] (action) in
            guard let self else { return }
            self.coordinator.dismissDetail()
        }

        let backImage = UIImage(named: "ios-arrow")!
        let back = UIButton(
            frame: CGRect(
                x: 0,
                y: over.frame.minY,
                width: 40,
                height: 40
            ),
            primaryAction: action
        )
        back.setImage(backImage.withTintColor(.white), for: .normal)
        back.setImage(backImage.withTintColor(.gray), for: .highlighted)

        back.layer.shadowColor = UIColor.black.cgColor
        back.layer.shadowRadius = 2
        back.layer.shadowOpacity = 0.75
        back.layer.shadowOffset = CGSize(width: 1, height: 1)

        view.addSubview(back)
    }

}
