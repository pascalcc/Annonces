//
//  DetailViewModel.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 09/12/2024.
//

import RxSwift

@MainActor
public class DetailViewModel {

    private let ad_id: String
    private(set) var ad: Ad! = nil

    private let disposeBag = DisposeBag()

    var onLoaded: (() -> Void)?
    var onError: (() -> Void)?

    public init(id: String) {
        self.ad_id = id
    }

    func fetchAd() {
        Network.detailAd(id: self.ad_id).subscribe(
            onSuccess: { [weak self] ad in
                guard let self else { return }
                self.ad = ad
                self.onLoaded?()
            },
            onFailure: { [weak self] error in
                guard let self else { return }
                self.onError?()
            }
        ).disposed(by: disposeBag)
    }

    func getImagesURL() -> [ImageURL] {
        ad.imagesURL.enumerated().map { ImageURL(id: $0, url: $1) }
    }
}

struct ImageURL: Identifiable {
    let id: Int
    let url: String
}
