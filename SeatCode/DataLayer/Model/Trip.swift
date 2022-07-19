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
    
    init(tripAPI: TripAPI) {
        self.status = tripAPI.status
        self.startTime = tripAPI.startTime
        self.endTime = tripAPI.endTime
        self.driverName = tripAPI.driverName
        self.origin = OriginDestination(originDestinationAPI: tripAPI.origin)
        self.destination = OriginDestination(originDestinationAPI: tripAPI.destination)
    }
}
