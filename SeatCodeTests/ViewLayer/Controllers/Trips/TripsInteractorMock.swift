//
//  TripsInteractorMock.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode

internal final class TripsInteractorMock: TripsInteractorProtocol {

    var getIssueCounter = 0
    var fetchTripsCount = 0
    var fetchStopsCount = 0

    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        fetchTripsCount += 1
        return .success([])
    }

    func getIssue(endTime: String) async -> Issue? {
        getIssueCounter += 1
        return nil
    }

    func fetchStops(trip: Trip) async -> Result<Trip, ErrorAPI> {
        fetchStopsCount += 1
        return .failure(.failedOnParsingJSON)
    }
}
