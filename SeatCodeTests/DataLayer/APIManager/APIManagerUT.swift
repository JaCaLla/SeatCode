//
//  APIManagerUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import XCTest

class APIManagerUT: XCTestCase {

    var sut: APIManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = APIManager()
    }

    func testFetchTrips() async throws {

        let expectation = expectation(description: "fetchTrips")

        let result = await sut.fetchTrips()

        switch result {
        case .success(let apiTrips):
            XCTAssertEqual(apiTrips[3].destination.address.isEmpty, false)
            XCTAssertEqual(apiTrips[3].origin.address.isEmpty, false)
            XCTAssertEqual(apiTrips[3].origin.point.latitude > 0, true)
            XCTAssertEqual(apiTrips[3].route.isEmpty, false)
            XCTAssertEqual(apiTrips[3].stops.count, 2)
            XCTAssertEqual(apiTrips[3].stops[0].id, 9)
            XCTAssertEqual(apiTrips.count, 7)
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()

        await waitForExpectations(timeout: 3)
    }

}
