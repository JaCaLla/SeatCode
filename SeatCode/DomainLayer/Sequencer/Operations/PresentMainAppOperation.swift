//
//  PresentMainAppOperation.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
import UIKit

class PresentMainAppOperation: ConcurrentOperation {

    override init() {
        super.init()
    }

    override func main() {
        DispatchQueue.main.async {
            MainFlowCoordinator.shared.start()
            self.state = .finished
        }
    }
}
