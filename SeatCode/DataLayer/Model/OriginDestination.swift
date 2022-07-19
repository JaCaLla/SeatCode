//
//  OriginDestination.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

struct OriginDestination {
    let address: String
    
    init(originDestinationAPI: OriginDestinationAPI) {
        self.address = originDestinationAPI.address
    }
}

