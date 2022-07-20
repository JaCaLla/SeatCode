//
//  TripPresenterUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import XCTest

class TripsPresenterUT: XCTestCase {
    
    var sut: TripsPresenterProtocol!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TripsPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchTripsWhenMock() async throws {
        // Given
        let tripsInteractorMock = TripsInteractorMock()
        sut = TripsPresenter(interactor: tripsInteractorMock)
        let tripsVCMock = TripsVCMock()
        sut.set(tripsVC: tripsVCMock)

        let expectation = expectation(description: "testFetchTripsWithMock")
        // When
        await sut.fetchTrips()
        
        // Then
        XCTAssertEqual(tripsInteractorMock.fetchTripsCount, 1)
        
        expectation.fulfill()
        await waitForExpectations(timeout: 10)
    }
}
