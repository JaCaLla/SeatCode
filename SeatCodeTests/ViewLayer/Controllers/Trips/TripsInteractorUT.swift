//
//  TripsInteractorUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import XCTest

class TripsInteractorUT: XCTestCase {

    var sut: TripsInteractorProtocol!
    var oldApp = currentApp

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TripsInteractor()
    }

    func testFetchTripsWithMock() async throws {
        // Given
        oldApp = currentApp
        let dataManagerMock = DataManagerMock()
        currentApp = App(dataManager: dataManagerMock)

        let expectation = expectation(description: "testFetchTripsWithMock")
        // When
        let result = await sut.fetchTrips()
        switch result {
        case .success:
            // Then
            XCTAssertEqual(dataManagerMock.fetchTripsCounter, 1)
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()
        await waitForExpectations(timeout: 1)

        currentApp = oldApp
    }

    func testFetchTrips() async throws {

        let expectation = expectation(description: "fetchTrips")
        // When
        let result = await sut.fetchTrips()
        switch result {
        case .success(let trips):
            // Then
            XCTAssertEqual(trips.count, 7)
            XCTAssertEqual(trips[3].status, "scheduled")
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
    }

    func testFetchStops() async throws {
        // Given
        let expectation = expectation(description: "testFetchStops")
        let result = await sut.fetchTrips()
        switch result {
        case .success(let trips):
            XCTAssertEqual(trips.count, 7)
            let trip = trips[0]
            let result = await sut.fetchStops(trip: trip)
            switch result {
            case .success(let trip):
                XCTAssertEqual(trip.stopPoints[0].stop, trip.stopPoints[0].stop)
                XCTAssertNotNil(trip.stopPoints[1].stop)
                XCTAssertEqual(trip.stopPoints[1].stop?.userName, "Manuel Gomez")
                XCTAssertEqual(trip.stopPoints[1].stop?.address, "Ramblas, Barcelona")
                XCTAssertNotNil(trip.stopPoints[2].stop)
                XCTAssertNotNil(trip.stopPoints[3].stop)
                XCTAssertNotNil(trip.stopPoints[4].stop)
                XCTAssertEqual(trip.stopPoints[5].stop, trip.stopPoints[0].stop)
            default:
                XCTFail("Unexpected response")
            }
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
    }

}
