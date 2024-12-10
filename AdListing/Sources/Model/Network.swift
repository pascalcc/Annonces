//
//  Loader.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import Alamofire
import CoreLocation
import UIKit

struct Network {

    typealias ListingResponse = ([Ad], String?)

    static func loadListing(
        after: String? = nil,
        nextIndex: Int = 0,
        completion: @escaping (Result<ListingResponse, Error>) -> Void
    ) {
        let url = after.map { "\(listingUrl)&after=\($0)" } ?? listingUrl
        AF.request(
            url,
            method: .post,
            parameters: ListingParameter(),
            encoder: JSONParameterEncoder.default
        ).validate().responseDecodable(of: ListingJson.Response.self) {
            response in
            switch response.result {
            case .success(let response):
                let after = response.paging.after
                let ads = response.data.enumerated().map { (index, json) in
                    Ad(fromJson: json, withIndex: nextIndex + index)
                }
                completion(.success(ListingResponse(ads: ads, next: after)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    private static let paginationSize = 26
    private static let listingUrl =
        "https://prod.geev.fr/v2/search/items/geo?limit=\(paginationSize)"

    fileprivate static let userLocation = CLLocation(
        latitude: 44.838069099999998, longitude: -0.57776780000000005)

    private struct ListingParameter: Encodable {
        let type = ["donation"]
        let distance = 10_000
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let universe = ["object"]
        let donationState = ["open", "reserved"]
    }

}

extension Ad {

    fileprivate init(fromJson json: ListingJson.Ad, withIndex index: Int) {

        let adLocation = CLLocation(
            latitude: json.location.latitude,
            longitude: json.location.longitude
        )

        ad_id = json._id
        title = json.title
        thumbnailURL = json.pictures.first!.squares300
        distance = Int(Network.userLocation.distance(from: adLocation))
        createdAt = Double(json.creationDateMs / 1_000)
        reserved = json.reserved
        ui_index = index
        retry = false
    }

}

private struct ListingJson {

    struct Response: Decodable {
        let paging: Paging
        let data: [Ad]
    }

    struct Paging: Decodable {
        let after: String?
        let before: String?
    }

    struct Ad: Decodable {
        let _id: String
        let creationDateMs: Int
        let location: Location
        let pictures: [PictureURL]
        let reserved: Bool
        let title: String
    }

    struct PictureURL: Decodable {
        let squares300: String
    }

    struct Location: Decodable {
        let latitude: Double
        let longitude: Double
    }

}
