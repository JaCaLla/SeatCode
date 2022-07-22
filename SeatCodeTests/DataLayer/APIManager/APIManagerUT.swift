//
//  APIManagerUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import XCTest

class APIManagerUT: XCTestCase {

    var sut: APIManagerProtocol!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = APIManager()
    }

    func testFetchTrips() async throws {

        let expectation = expectation(description: "fetchTrips")

        let result = await sut.fetchTrips()

        switch result {
        case .success(let tripAPI):
            XCTAssertEqual(tripAPI[3].destination.address.isEmpty, false)
            XCTAssertEqual(tripAPI[3].origin.address.isEmpty, false)
            XCTAssertEqual(tripAPI[3].origin.point.latitude > 0, true)
            XCTAssertEqual(tripAPI[3].route.isEmpty, false)
            XCTAssertEqual(tripAPI[3].stops.count, 2)
            XCTAssertEqual(tripAPI[3].stops[0].id, 9)
            XCTAssertEqual(tripAPI.count, 7)
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()

        await waitForExpectations(timeout: 3)
    }
    
    func testFetchStop() async throws {

        let expectation = expectation(description: "fetchTrips")

        let result = await sut.fetchStop(id:1)

        switch result {
        case .success(let stopAPI):
            XCTAssertEqual(stopAPI.address, "Ramblas, Barcelona")
            XCTAssertEqual(stopAPI.userName, "Manuel Gomez")
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()

        await waitForExpectations(timeout: 3)
    }
    
    func testFetchStopsSequential() async throws {

        let expectation = expectation(description: "fetchTrips")

        let ids = Array(1...9)
        let result = await sut.fetchStopsSeq(ids:ids)

        switch result {
        case .success(let stopsAPI):
            XCTAssertEqual(stopsAPI.count, ids.count)
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()

        await waitForExpectations(timeout: 5)
    }

    func testFetchStopsParallel() async throws {

        let expectation = expectation(description: "fetchTrips")

        let ids = Array(1...9)
        let result = await sut.fetchStopsPar(ids: ids)

        switch result {
        case .success(let stopsAPI):
            XCTAssertEqual(stopsAPI.count, ids.count)
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()

        await waitForExpectations(timeout: 5)
    }
    
    func testMeasurePerfonace() async {
        let timeSeq = await timeElapsedInSecondsWhenRunningCode(operation: {
            do {
                try await self.testFetchStopsSequential()
            } catch {
                XCTFail("failed testMeasurePerfonace")
            }
        })
        
        let timePar = await timeElapsedInSecondsWhenRunningCode(operation: {
            do {
                try await self.testFetchStopsParallel()
            } catch {
                XCTFail("failed testMeasurePerfonace")
            }
        })
        
        XCTAssertTrue(timePar < timeSeq)
    }
    
    
    func timeElapsedInSecondsWhenRunningCode(operation: () async -> ()) async -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
         await operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return Double(timeElapsed)
    }
}
