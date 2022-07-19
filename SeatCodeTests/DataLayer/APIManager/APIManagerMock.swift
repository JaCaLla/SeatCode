//
//  APIManagerMock.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import Foundation

internal final class APIManagerMock: APIManagerProtocol {
    
    var fetchTripsCounter = 0
    
    func fetchTrips() async -> Result<[TripAPI], ErrorAPI> {
        fetchTripsCounter += 1
        return  .success([])
    }
}
