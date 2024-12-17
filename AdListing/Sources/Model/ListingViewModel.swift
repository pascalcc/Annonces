//
//  Ads.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import Combine
import UIKit

@MainActor
public class ListingViewModel: ObservableObject {
    private enum Pagination: Equatable {
        case notStarted
        case next(String)
        case pending
        case complete
    }

    @Published private var pagination: Pagination = .notStarted

    @Published private(set) var loaded: [Ad] = []

    private var toRetry: Set<Int> = []

    private let container: ListingLoader

    public init(container: ListingLoader = ListingLoader()) {
        self.container = container
    }

    func isEmptyAndLoading() -> Bool {
        loaded.isEmpty && pagination == .pending
    }

    func refresh() {
        guard pagination != .pending else { return }

        loaded.removeAll()
        pagination = .notStarted
        loadMore()
    }

    public func autoload() {
        if pagination == .notStarted {
            loadMore()
        } else {
            if !toRetry.isEmpty {
                var alls = loaded
                for index in toRetry {
                    alls[index] = loaded[index].retryCopy()
                }
                toRetry.removeAll()
                loaded = alls
            }
        }
    }

    func preload(_ index: Int) {
        if index > loaded.count - 8 {
            loadMore()
        }
    }

    func markToReload(_ index: Int) {
        toRetry.insert(index)
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

        let pagingInfo = PagingInfo(afterId: after, next_ui_index: loaded.count)
        container.dataLoader(.server).loadListing(pagingInfo: pagingInfo) {
            response in
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
