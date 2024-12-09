//
//  Network.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 09/12/2024.
//

import Alamofire
import RxSwift

struct Network {

    static func detailAd(id: String) -> Single<AdDetail> {

        let url = "https://prod.geev.fr/v1/api/v0.19/articles/\(id)"

        return Single.create { single in
            let request = AF.request(url)
                .validate()
                .responseDecodable(of: Response.self) {
                    response in
                    switch response.result {
                    case .success(let ad):
                        let ad = AdDetail(fromJson: ad)
                        single(.success(ad))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create { request.cancel() }
        }
    }

}

extension AdDetail {

    init(fromJson json: Response) {
        let images = json.pictures.map {
            "https://images.geev.fr/\($0)/squares/600"
        }

        title = json.title
        description = json.description
        imagesURL = images
        firstContact = !json.reserved
    }

}

struct Response: Decodable {
    let _id: String
    let title: String
    let description: String
    let pictures: [String]
    let reserved: Bool  // HACK to simulate contacted
}
