//
//  Ads.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import Combine
import UIKit

@MainActor
class Ads: ObservableObject {
    private enum Pagination {
        case notStarted
        case next(String)
        case pending
        case complete
    }

    private var pagination: Pagination = .notStarted

    @Published private(set) var loaded: [Ad] = []

    func refresh() {
        loaded.removeAll()

        pagination = .notStarted
        loadMore()
    }

    func preload(_ index: Int) {
        if index > loaded.count - 6 {
            loadMore()
        }
    }

    private func haveMoreToLoad() -> (Bool, String?) {
        switch pagination {
        case .notStarted:
            (true, nil)
        case .next(let after):
            (true, after)
        case .complete, .pending:
            (false, nil)
        }
    }

    private func loadMore() {
        let (more, after) = haveMoreToLoad()
        guard more else { return }

        pagination = .pending
        Loader.loadListing(after: after, nextIndex: loaded.count) { response in
            switch response {
            case .success(let (ads, next)):
                self.pagination = next.map { .next($0) } ?? .complete
                self.loaded.append(contentsOf: ads)
            case .failure(_):
                self.pagination = after.map { .next($0) } ?? .notStarted
            }
        }
    }

}
