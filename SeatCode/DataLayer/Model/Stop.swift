//
//  Stop.swift
//  SeatCode
//
//  Created by Javier Calatrava on 22/7/22.
//

import Foundation

struct Stop {
    let address: String
    let userName: String
    let stopTime: Date
    
    init(stopAPI: StopAPI) {
        self.address = stopAPI.address
        self.userName = stopAPI.userName
        self.stopTime = stopAPI.stopTime
    }
}

extension Stop: Equatable {
    static func == (lhs: Stop, rhs: Stop) -> Bool {
        return lhs.address == rhs.address &&
        lhs.userName == rhs.userName &&
        lhs.stopTime == rhs.stopTime
    }
}
