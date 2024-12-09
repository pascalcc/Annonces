//
//  Ad.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 08/12/2024.
//

import Foundation

struct Ad: Identifiable {
    let id: String
    let title: String
    let thumbnailURL: String
    let distance: Int
    let createdAt: Double
    let reserved: Bool

    let ui_index: Int
}

//MARK: - UI infos

extension Ad {
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
