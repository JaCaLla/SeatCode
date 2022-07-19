//
//  TripsInteractorMock.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode

internal final class TripsInteractorMock: TripsInteractorProtocol {
    
    var fetchTripsCount = 0
    
    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        fetchTripsCount += 1
        return .success([])
    }
}
