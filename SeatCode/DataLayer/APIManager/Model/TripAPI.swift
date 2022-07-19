//
//  Trip.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

struct TripAPI: Codable {
    let status: String
    let startTime: Date
    let endTime: Date
    let driverName: String
    let destination: OriginDestinationAPI
    let origin: OriginDestinationAPI
}

