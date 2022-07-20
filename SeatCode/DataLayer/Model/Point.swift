//
//  Point.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import Foundation

// MARK: - Point
struct Point {
    let latitude, longitude: Double
    let id: Int?
    
    // MARK: - Initializer/Constructor
    init(pointAPI: PointAPI, id: Int? = nil) {
        self.latitude = pointAPI.latitude
        self.longitude = pointAPI.longitude
        self.id = id
    }
}
