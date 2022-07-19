//
//  DataManagerMock.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import Foundation

internal final class DataManagerMock: DataManagerProtocol {
    
    var fetchTripsCounter = 0
    
    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        fetchTripsCounter += 1
        return .success([])
    }
}
