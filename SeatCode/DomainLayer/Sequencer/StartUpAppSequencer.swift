//
//  StartUpAppSequencer.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
import UIKit

class  StartUpAppSequencer {
    fileprivate let operationQueue = OperationQueue()

    func start() {

        let presentMainAppOperation = PresentMainAppOperation()

        let operations = [presentMainAppOperation]

        // Add operation dependencies
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
}

