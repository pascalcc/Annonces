//
//  Container.swift
//  AdListing
//
//  Created by Pascal Costa-Cunha on 17/12/2024.
//

import Swinject

struct PagingInfo {
    let afterId: String?
    let next_ui_index: Int
}

typealias ListingResponse = ([Ad], String?)

protocol DataLoader {

    func loadListing(
        pagingInfo: PagingInfo,
        completion: @escaping (Result<ListingResponse, Error>) -> Void
    )

}

public struct ListingLoader {

    let container: Container

    enum RegisteredContainer: String {
        case server = "server"
        case empty = "empty"
    }

    public init() {
        container = Container()
        container
            .register(
                DataLoader.self,
                name: RegisteredContainer.server.rawValue
            ) { r in
                Network()
            }

        container
            .register(
                DataLoader.self,
                name: RegisteredContainer.empty.rawValue
            ) { r in
                EmptyLoader()
            }

    }

    func dataLoader(_ type: RegisteredContainer) -> DataLoader {
        container
            .resolve(
                DataLoader.self,
                name: type.rawValue
            )!
    }

}

struct EmptyLoader: DataLoader {

    func loadListing(
        pagingInfo: PagingInfo,
        completion: @escaping (
            Result<ListingResponse, Error>
        ) -> Void
    ) {
        completion(.success(([], nil)))
    }
}
