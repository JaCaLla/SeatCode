//
//  RouteVM.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

struct TripVM {
    var driverName: String
    var startEnd: String
    var originDestination: String
    
    // MARK: - Constructor/Initializer
    init(trip: Trip) {

        self.driverName = trip.driverName
        self.startEnd = "\(trip.startTime) - \(trip.endTime)"
        self.originDestination = "\(trip.origin.address) - \(trip.destination.address)"
    }
}
