//
//  Trip.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

struct Trip {
    let status: String
    let startTime: String
    var endTime: String
    let driverName: String
    let destination: OriginDestination
    let origin: OriginDestination
    let route: String
    var stopPoints: [StopPoint]
    let hasIssue: Bool

    // MARK: - Initializer/Constructor
    init(tripAPI: TripAPI, hasIssue: Bool) {
        self.status = tripAPI.status
        self.startTime = tripAPI.startTime
        self.endTime = tripAPI.endTime
        self.driverName = tripAPI.driverName
        self.origin = OriginDestination(originDestinationAPI: tripAPI.origin)
        self.destination = OriginDestination(originDestinationAPI: tripAPI.destination)
        self.route = tripAPI.route
        self.stopPoints = Trip.buildPointsTrip(tripAPI: tripAPI)
        self.hasIssue = hasIssue

    }

    mutating func set(stopPoints: [StopPoint]) {
        self.stopPoints = stopPoints
    }

    // MARK: - Private/Internal methods
    private static func buildPointsTrip(tripAPI: TripAPI) -> [StopPoint] {
        var points: [StopPoint] = []
        points.append(StopPoint(pointAPI: tripAPI.origin.point))
        points.append(contentsOf: tripAPI.stops.compactMap({
            guard let uwpPoint = $0.point else { return nil }
            return StopPoint(pointAPI: uwpPoint, id: $0.id)
        }))
        points.append(StopPoint(pointAPI: tripAPI.destination.point))
        return points
    }
}
