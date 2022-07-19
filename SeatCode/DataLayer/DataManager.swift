//
//  DataManager.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

protocol DataManagerProtocol: AnyObject {
    func fetchTrips() async -> Result<[Trip], ErrorAPI>
}

internal final class DataManager {
    
    // MARK: - Injected attributes
    private var apiManager:APIManagerProtocol = APIManager()


    // MARK: - Initializers
    init(apiManager:APIManagerProtocol = APIManager()) {

        self.apiManager = apiManager
    }
}

extension DataManager: DataManagerProtocol {
    
    func fetchTrips() async -> Result<[Trip], ErrorAPI> {
        let result = await apiManager.fetchTrips()
        switch result {
        case .success(let apiTrips):
            let trips = apiTrips.map({ Trip(tripAPI: $0)})
            return .success(trips)
        case .failure(let error):
            return .failure(error)
        }
    }
}
