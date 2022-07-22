//
//  DataManager.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

protocol DataManagerProtocol: AnyObject {
    func fetchTrips() async -> Result<[Trip], ErrorAPI>
    func create(issue: Issue) async
    func getIssue(endTime: String) async -> Issue?
    func getIssuesCount() -> Int
    func fetchStops(trip: Trip) async -> Result<Trip, ErrorAPI>
}

internal final class DataManager {

    // MARK: - Injected attributes
    private var apiManager: APIManagerProtocol = APIManager()


    // MARK: - Initializers
    init(apiManager: APIManagerProtocol = APIManager()) {

        self.apiManager = apiManager
    }
}

// MARK - DataManagerProtocol
extension DataManager: DataManagerProtocol {

    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        let result = await apiManager.fetchTrips()
        switch result {
        case .success(let apiTrips):
            let trips: [Trip] = apiTrips.map({
                let hasIssue = currentApp.dbManager.getIssue(endTime: $0.endTime) != nil
                return Trip(tripAPI: $0, hasIssue: hasIssue)
            })
            return .success(trips)
        case .failure(let error):
            return .failure(error)
        }
    }

    func create(issue: Issue) async {
        let issueDB = IssueDB(issue: issue)
        return await currentApp.dbManager.create(issueDB: issueDB)
    }

    func getIssue(endTime: String) async -> Issue? {
        guard let issueDB = await currentApp.dbManager.getIssue(endTime: endTime) else {
            return nil
        }
        let issue = Issue(issueDB: issueDB)
        return issue
    }

    func getIssuesCount() -> Int {
        return Int(currentApp.dbManager.getIssues().count)
    }

    func fetchStops(trip: Trip) async -> Result<Trip, ErrorAPI> {
        let ids = trip.stopPoints.compactMap({ $0.id })
        let result = await apiManager.fetchStopsPar(ids: ids)
        switch result {
        case .success(let dicStopsAPI):
            if let updatedTrip = update(trip: trip, dicStopsAPI: dicStopsAPI) {
                return .success(updatedTrip)
            }
        case .failure(let error):
            return .failure(error)
        }
        return .failure(.fetchStopsFailed)
    }

    // MARK: - Private/Internal methods
    private func update(trip: Trip, dicStopsAPI: [Int: StopAPI]) -> Trip? {
        var updatedTrip = trip
        var stopPoints: [StopPoint] = []
        for stopPoint in trip.stopPoints {
            if let id = stopPoint.id,
                let stopAPI = dicStopsAPI[id] {
                var stopPointUpdated = stopPoint
                stopPointUpdated.set(stop: Stop(stopAPI: stopAPI))
                stopPoints.append(stopPointUpdated)
            } else if let first = trip.stopPoints.first,
                first == stopPoint {
                stopPoints.append(stopPoint)
            } else if let last = trip.stopPoints.last,
                      last == stopPoint {
                stopPoints.append(stopPoint)
            } else {
                return nil
            }
        }
        updatedTrip.set(stopPoints: stopPoints)
        return updatedTrip
    }

}
