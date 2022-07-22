//
//  TripsInteractor.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

// MARK: - Protocol
protocol TripsInteractorProtocol {
    func fetchTrips() async -> Result<[Trip], ErrorAPI>
    func getIssue(endTime: String) async -> Issue?
    func fetchStops(trip: Trip) async -> Result<Trip, ErrorAPI>
}

class TripsInteractor {
    
}


// MARK: - TripsInteractorProtocol
extension TripsInteractor: TripsInteractorProtocol {
    
    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        return await currentApp.dataManager.fetchTrips()
    }
    
    func getIssue(endTime: String) async -> Issue? {
       await currentApp.dataManager.getIssue(endTime: endTime)
    }
    
    func fetchStops(trip: Trip) async -> Result<Trip, ErrorAPI> {
        return await currentApp.dataManager.fetchStops(trip: trip)
    }
}
