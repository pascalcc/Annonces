//
//  Ad.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import Foundation

struct Ad: Identifiable {
    var id: String {
        retry ? ad_id : ad_id + "r"
    }

    let ad_id: String
    let title: String
    let thumbnailURL: String
    let distance: Int
    let createdAt: Double
    let reserved: Bool

    let ui_index: Int
    let retry: Bool
}

extension Ad {

    func retryCopy() -> Ad {
        Ad(
            ad_id: ad_id,
            title: title,
            thumbnailURL: thumbnailURL,
            distance: distance,
            createdAt: createdAt,
            reserved: reserved,
            ui_index: ui_index,
            retry: !retry
        )
    }

    func formattedTime() -> String {
        let created = Date(timeIntervalSince1970: createdAt)
        let elasped = -Int(created.timeIntervalSinceNow)

        let minutes = elasped / 60
        if minutes < 60 {
            return "\(minutes)min"
        }
        let hours = minutes / 60
        if hours < 24 {
            return "\(hours)h"
        }
        let days = hours / 24
        return "\(days)j"
    }

    func formattedDistance() -> String {
        if distance < 1000 {
            return "\(distance)m"
        }

        return "\(Double(distance / 100) / 10.0) km".replacingOccurrences(
            of: ".",
            with: ","
        )
    }

}
