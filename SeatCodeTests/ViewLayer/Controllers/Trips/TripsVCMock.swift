//
//  TripsVCMock.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
@testable import SeatCode

internal final class TripsVCMock: TripsVCProtocol {

    var presentActivityIndicatorCounter = 0
    var removeActivityIndicatorCounter = 0
    var presentCounter = 0
    var presentFetchedTripsCounter = 0
    var onGetIssueCounter = 0
    var presentStopPointsCounter = 0

    func presentActivityIndicator() {
        presentActivityIndicatorCounter += 1
    }

    func removeActivityIndicator() {
        removeActivityIndicatorCounter += 1
    }

    func presentAlertError(message: String) {
        presentCounter += 1
    }

    func presentFetchedTrips(tripsVM: [TripVM]) {
        presentFetchedTripsCounter += 1
    }

    func onGetIssue(issue: Issue) {
        onGetIssueCounter += 1
    }

    func presentStopPoints(tripVM: TripVM) {
        presentStopPointsCounter += 1
    }
}
