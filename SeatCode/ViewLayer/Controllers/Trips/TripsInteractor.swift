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
}

class TripsInteractor {
    
}


// MARK: - TripsInteractorProtocol
extension TripsInteractor: TripsInteractorProtocol {
    
    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        return await currentApp.dataManager.fetchTrips()
    }
}
