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
    var createCounterDeprecated = 0
    var getIssueCounterDeprecated = 0
    var createCounter = 0
    var getIssueCounter = 0
    var getIssuesCounter = 0
    var fetchStopsCounter = 0
    
    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        fetchTripsCounter += 1
        return .success([])
    }
    
    func create(issue: Issue, onComplete: @escaping () -> Void) {
        createCounterDeprecated += 1
    }
    
    func getIssue(route: String, onComplete: @escaping (Issue?) -> Void) {
        getIssueCounterDeprecated += 1
    }
    
    func create(issue: Issue) async {
        createCounter += 1
    }
    
    func getIssue(endTime: String) async -> Issue? {
        getIssueCounter += 1
        return nil
    }
    
    func getIssuesCount() -> Int {
        getIssuesCounter += 1
        return 0
    }
    
    func fetchStops(trip: Trip) async -> Result<Trip, ErrorAPI> {
        fetchStopsCounter += 1
        return .failure(.failedParallelFetching)
    }
}
