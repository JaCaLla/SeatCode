//
//  APIManagerMock.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
import Foundation
@testable import SeatCode

internal final class APIManagerMock: APIManagerProtocol {

    var fetchTripsCounter = 0
    var fetchStopCounter = 0
    var fetchStopsCounter = 0
    var fetchStopsParCounter = 0

    func fetchTrips() async -> Result<[TripAPI], ErrorAPI> {
        fetchTripsCounter += 1
        return .success([])
    }

    func fetchStop(id: Int) async -> Result<StopAPI, ErrorAPI> {
        fetchStopCounter += 1
        return .failure(.failedOnParsingJSON)
    }

    func fetchStopsSeq(ids: [Int]) async -> Result<[Int: StopAPI], ErrorAPI> {
        fetchStopsCounter += 1
        return .failure(.failedOnParsingJSON)
    }

    func fetchStopsPar(ids: [Int]) async -> Result<[Int: StopAPI], ErrorAPI> {
        fetchStopsParCounter += 1
        return .failure(.failedOnParsingJSON)
    }

}
