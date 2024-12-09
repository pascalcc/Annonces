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

    required init?(coder: NSCoder) {
        fatalError("use init(id:) instead")
    }

    init(_ vm: DetailViewModel) {

        viewModel = vm

        super.init(nibName: nil, bundle: nil)

        viewModel.onLoaded = { [weak self] in
            guard let self else { return }
            self.recreateWithContentLoaded()
        }

        viewModel.onError = { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
        }

        viewModel.fetchAd()
    }

    private static let imageHeight = 350

    public override func viewDidLoad() {
        super.viewDidLoad()
        createEmpty()
    }

    func addBackButton() -> CGRect {
        let action = UIAction { [weak self] (action) in
            guard let self else { return }
            self.dismiss(animated: true)
        }

        let backImage = UIImage(named: "ios-arrow")!
        let back = UIButton(
            frame: CGRect(x: 0, y: 0, width: 40, height: 40),
            primaryAction: action)
        back.setImage(backImage.withTintColor(.white), for: .normal)
        back.setImage(backImage.withTintColor(.gray), for: .highlighted)
        view.addSubview(back)
        return back.frame
    }

    func createEmpty() {

        let fullWidth = Int(view.frame.width)
        let image = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: fullWidth,
                height: Self.imageHeight
            ))
        image.backgroundColor = UIColor(named: "ListingBack")
        view.addSubview(image)

        let wheel = UIActivityIndicatorView(style: .large)
        wheel.center = CGPoint(x: image.frame.midX, y: image.frame.midY)
        wheel.startAnimating()
        image.addSubview(wheel)

        let _ = addBackButton()
    }

    func recreateWithContentLoaded() {

        guard let ad = viewModel.ad else { return }

        view.subviews.forEach { $0.removeFromSuperview() }

        let spacing = 12
        let fullWidth = Int(view.frame.width)

        let swiftui = PagedImageView(images: viewModel.getImagesURL())
        let image = UIHostingController(rootView: swiftui).view!
        image.frame = CGRect(
            x: 0,
            y: 0,
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
                height: Int(view.frame.height) - posY - 5 * spacing
            )
        )
        description.isEditable = false
        description.text = ad.description
        description.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(description)

        let backFrame = addBackButton()

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

            contact.frame.size.height = 28
            contact.frame.size.width += CGFloat(2 * spacing)
                        
            contact.center.y = backFrame.midY
            contact.center.x = CGFloat(fullWidth) - contact.frame.size.width / 2
                - contact.frame.minY

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

}
