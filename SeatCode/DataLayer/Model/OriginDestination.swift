//
//  OriginDestination.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

struct OriginDestination {
    let address: String
    let point: StopPoint
    
    // MARK: - Initializer/Constructor
    init(originDestinationAPI: OriginDestinationAPI) {
        self.address = originDestinationAPI.address
        self.point = StopPoint(pointAPI: originDestinationAPI.point)
    }
}

