//
//  Trip.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

struct TripAPI: Codable {
    let status: String
    let startTime: String
    let endTime: String
    let driverName: String
    let destination: OriginDestinationAPI
    let origin: OriginDestinationAPI
    let route: String
    var stops: [TripStopAPI] = []
}
