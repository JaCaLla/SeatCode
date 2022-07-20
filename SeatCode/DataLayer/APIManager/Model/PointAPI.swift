//
//  PointAPI.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import Foundation

// MARK: - Point
struct PointAPI: Codable {
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "_latitude"
        case longitude = "_longitude"
    }
}
