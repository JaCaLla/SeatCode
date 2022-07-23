//
//  Point.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import Foundation

// MARK: - Point
struct StopPoint {
    let latitude, longitude: Double
    let id: Int?
    var stop: Stop?

    // MARK: - Initializer/Constructor
    init(pointAPI: PointAPI, id: Int? = nil) {
        self.latitude = pointAPI.latitude
        self.longitude = pointAPI.longitude
        self.id = id
    }

    // MARK: - Public methods
    mutating func set(stop: Stop) {
        self.stop = stop
    }
}

extension StopPoint: Equatable {
    static func == (lhs: StopPoint, rhs: StopPoint) -> Bool {
        var continueCheck = true
        if lhs.id == nil && lhs.id == nil {

        } else if let lhsId = lhs.id,
            let rhsId = rhs.id {
            continueCheck = continueCheck && lhsId == rhsId
        } else {
            return false
        }
        if lhs.id == nil && lhs.id == nil {

        } else if let lhsStop = lhs.stop,
            let rhsStop = rhs.stop {
            continueCheck = continueCheck && lhsStop == rhsStop
        } else {
            return false
        }

        return continueCheck &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
