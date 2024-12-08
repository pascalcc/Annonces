//
//  Loader.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import Alamofire
import CoreLocation
import UIKit

struct Loader {

    typealias ListingResponse = ([Ad], String?)

    struct ListingParameter: Encodable {
        let type = ["donation"]
        let distance = 200  //10_000
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let universe = ["object"]
        let donationState = ["open", "reserved"]
    }

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
        ).validate().responseDecodable(
            of: ListingJson.Response.self
        ) { response in
            switch response.result {
            case .success(let response):
                let after = response.paging.after
                let ads = response.data.enumerated().map { (index, json) in
                    Ad.fromJson(json, withIndex: nextIndex + index)
                }

                completion(.success(ListingResponse(ads: ads, next: after)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

private let userLocation = CLLocation(
    latitude: 44.838069099999998, longitude: -0.57776780000000005)
private let paginationSize = 26
private let listingUrl =
    "https://prod.geev.fr/v2/search/items/geo?limit=\(paginationSize)"

extension Ad {

    fileprivate static func fromJson(
        _ json: ListingJson.Ad, withIndex index: Int
    ) -> Ad {

        let adLocation = CLLocation(
            latitude: json.location.latitude,
            longitude: json.location.longitude
        )

        return Ad(
            id: json._id,
            title: json.title,
            thumbnailURL: json.pictures.first!.squares300,
            distance: Int(userLocation.distance(from: adLocation)),
            createdAt: Double(json.creationDateMs / 1_000),
            reserved: json.reserved,
            ui_index: index
        )
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
        let pageLength: Int
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
/*
 {
 "_id":"6755882d54733887cc30e289",
 "acquired":false,
 "available":true,
 "author":{"id":"654152f8b5ce75c0fcfaab5f",
            "firstName":"Camille",
            "lastName":"Serre",
            "type":"person",
            "picture":{"squares32":"https://images.geev.fr/654152f81307210013e801d2/squares/32",
                        "squares64":"https://images.geev.fr/654152f81307210013e801d2/squares/64",
                        "squares128":"https://images.geev.fr/654152f81307210013e801d2/squares/128",
                        "squares300":"https://images.geev.fr/654152f81307210013e801d2/squares/300",
                        "squares600":"https://images.geev.fr/654152f81307210013e801d2/squares/600",
                        "resizes1000":"https://images.geev.fr/654152f81307210013e801d2/resizes/1000"},
            "subscription":null},
 "category":"storage",
 "closed":false,
 "consumptionRule":{"banana_expiration_ms":1733831472301,
                    "premium_expiration_ms":1733745072301,
                    "premiumExclusivityMinimumExpirationMs":1733691072301},
 "creationDateMs":1733658669000,
 "description":"Little Marcel \nAbritait une montre ",
 "given":false,
 "location":{"city":"Bordeaux",
            "country":"France",
            "department":"Gironde",
            "latitude":44.85197241835314,
            "longitude":-0.5878905406465282,
            "obfuscated":true},
 "lastModerationDateMs":1733658672000,
 "offensive":0,
 "pictures":[{"squares32":"https://images.geev.fr/6755882a54733887cc30df9a/squares/32",
            "squares64":"https://images.geev.fr/6755882a54733887cc30df9a/squares/64",
            "squares128":"https://images.geev.fr/6755882a54733887cc30df9a/squares/128",
            "squares300":"https://images.geev.fr/6755882a54733887cc30df9a/squares/300",
            "squares600":"https://images.geev.fr/6755882a54733887cc30df9a/squares/600",
            "resizes1000":"https://images.geev.fr/6755882a54733887cc30df9a/resizes/1000"},
            {"squares32":"https://images.geev.fr/6755882b54733887cc30dfff/squares/32","squares64":"https://images.geev.fr/6755882b54733887cc30dfff/squares/64","squares128":"https://images.geev.fr/6755882b54733887cc30dfff/squares/128","squares300":"https://images.geev.fr/6755882b54733887cc30dfff/squares/300","squares600":"https://images.geev.fr/6755882b54733887cc30dfff/squares/600","resizes1000":"https://images.geev.fr/6755882b54733887cc30dfff/resizes/1000"}],"reserved":false,"searchId":"67558830355120132704b430","state":"good","spam":0,"seller":false,"sellingInfo":null,"stock":1,"availableStock":1,"title":"Boite cadeau ","type":"donation","universe":"object","unlockedCounter":0,"unlocked":false,"unlockedCounterObfuscated":"low","updateDateMs":1733658669000,"validated":true,"validationDateMs":1733658672301,"validationStatus":"done"},{"_id":"675587620b34e26107a4b632","acquired":false,"available":true,"author":{"id":"5c4327b80fe89a0012629911","firstName":"Julie","lastName":"Berg","type":"person","picture":{"squares32":"https://images.geev.fr/618afa18f49b650019386a65/squares/32","squares64":"https://images.geev.fr/618afa18f49b650019386a65/squares/64","squares128":"https://images.geev.fr/618afa18f49b650019386a65/squares/128","squares300":"https://images.geev.fr/618afa18f49b650019386a65/squares/300","squares600":"https://images.geev.fr/618afa18f49b650019386a65/squares/600","resizes1000":"https://images.geev.fr/618afa18f49b650019386a65/resizes/1000"},"subscription":null},"category":"other_appliance","closed":false,"consumptionRule":{"banana_expiration_ms":1733831268229,"premium_expiration_ms":1733744868229,"premiumExclusivityMinimumExpirationMs":1733690868229},"creationDateMs":1733658466000,"description":"Fonctionne encore\n3 étages \n\nA récupérer sur Mérignac ","given":false,"location":{"city":"Mérignac","country":"France","department":"Gironde","latitude":44.84184130397457,"longitude":-0.6627021847359863,"obfuscated":true},"lastModerationDateMs":1733658468000,"offensive":0,"pictures":[{"squares32":"https://images.geev.fr/675587610b34e26107a4b4ac/squares/32","squares64":"https://images.geev.fr/675587610b34e26107a4b4ac/squares/64","squares128":"https://images.geev.fr/675587610b34e26107a4b4ac/squares/128","squares300":"https://images.geev.fr/675587610b34e26107a4b4ac/squares/300","squares600":"https://images.geev.fr/675587610b34e26107a4b4ac/squares/600","resizes1000":"https://images.geev.fr/675587610b34e26107a4b4ac/resizes/1000"},{"squares32":"https://images.geev.fr/675587620b34e26107a4b61d/squares/32","squares64":"https://images.geev.fr/675587620b34e26107a4b61d/squares/64","squares128":"https://images.geev.fr/675587620b34e26107a4b61d/squares/128","squares300":"https://images.geev.fr/675587620b34e26107a4b61d/squares/300","squares600":"https://images.geev.fr/675587620b34e26107a4b61d/squares/600","resizes1000":"https://images.geev.fr/675587620b34e26107a4b61d/resizes/1000"}],"reserved":false,"searchId":"6755876480d1f281e63d7fac","state":"good","spam":0,"seller":false,"sellingInfo":null,"stock":1,"availableStock":1,"title":"Cuiseur vapeur","type":"donation","universe":"object","unlockedCounter":0,"unlocked":false,"unlockedCounterObfuscated":"low","updateDateMs":1733658466000,"validated":true,"validationDateMs":1733658468229,"validationStatus":"done"},{"_id":"675586b727dac58155e5501a","acquired":false,"available":true,"author":{"id":"67194b728e426709384733b8","firstName":"Nanna","lastName":"🐅","type":"person","picture":{"squares32":"https://images.geev.fr/671a97b05ec0106852b4a2ca/squares/32","squares64":"https://images.geev.fr/671a97b05ec0106852b4a2ca/squares/64","squares128":"https://images.geev.fr/671a97b05ec0106852b4a2ca/squares/128","squares300":"https://images.geev.fr/671a97b05ec0106852b4a2ca/squares/300","squares600":"https://images.geev.fr/671a97b05ec0106852b4a2ca/squares/600","resizes1000":"https://images.geev.fr/671a97b05ec0106852b4a2ca/resizes/1000"},"subscription":null},"category":"jewels","closed":false,"consumptionRule":{"banana_expiration_ms":1733831130725,"premium_expiration_ms":null,"premiumExclusivityMinimumExpirationMs":null},"creationDateMs":1733658295000,"description":"Divers bijoux fantaisie \n\nTous sont neufs \n\nSur Villenave d’Ornon quartier Chambéry  ","given":false,"location":{"city":"Villenave-d'Ornon","country":"France","department":"Gironde","latitude":44.764997075564956,"longitude":-0.5815912740383933,"obfuscated":true},"lastModerationDateMs":1733658330000,"offensive":0,"pictures":[{"squares32":"https://images.geev.fr/675586b727dac58155e5500d/squares/32","squares64":"https://images.geev.fr/675586b727dac58155e5500d/squares/64","squares128":"https://images.geev.fr/675586b727dac58155e5500d/squares/128","squares300":"https://images.geev.fr/675586b727dac58155e5500d/squares/300","squares600":"https://images.geev.fr/675586b727dac58155e5500d/squares/600","resizes1000":"https://images.geev.fr/675586b727dac58155e5500d/resizes/1000"}
            ],
 "reserved":false,
 "searchId":"675586da3ed775a857aa04bf",
 "state":"good",
 "spam":0,
 "seller":false,
 "sellingInfo":null,
 "stock":1,
 "availableStock":1,
 "title":"Lot de bijoux fantaisie 🥝",
 "type":"donation",
 "universe":"object",
 "unlockedCounter":0,
 "unlocked":false,
 "unlockedCounterObfuscated":"low",
 "updateDateMs":1733658295000,
 "validated":true,
 "validationDateMs":1733658330725,
 "validationStatus":"done"}]

 */
