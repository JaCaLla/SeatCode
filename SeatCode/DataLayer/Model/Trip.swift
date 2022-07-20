//
//  Trip.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

struct Trip {
    let status: String
    let startTime: Date
    let endTime: Date
    let driverName: String
    let destination: OriginDestination
    let origin: OriginDestination
    let polylineStr: String
    let stopPoints: [Point]
    
    // MARK: - Initializer/Constructor
    init(tripAPI: TripAPI) {
        self.status = tripAPI.status
        self.startTime = tripAPI.startTime
        self.endTime = tripAPI.endTime
        self.driverName = tripAPI.driverName
        self.origin = OriginDestination(originDestinationAPI: tripAPI.origin)
        self.destination = OriginDestination(originDestinationAPI: tripAPI.destination)
        self.polylineStr = tripAPI.route
        self.stopPoints = Trip.buildPointsTrip(tripAPI: tripAPI)

    }
    
    // MARK: - Private/Internal methods
    private static func buildPointsTrip(tripAPI: TripAPI) -> [Point] {
        var points: [Point] = []
        points.append(Point(pointAPI: tripAPI.origin.point))
        points.append(contentsOf: tripAPI.stops.compactMap({
            guard let uwpPoint = $0.point else { return nil}
            return Point(pointAPI: uwpPoint, id: $0.id)
        }))
        points.append(Point(pointAPI: tripAPI.destination.point))
        return points
    }
}
