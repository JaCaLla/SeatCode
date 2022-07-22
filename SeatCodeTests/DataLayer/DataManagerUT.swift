//
//  DataManagerUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import XCTest

class DataManagerUT: XCTestCase {

    var sut: DataManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = DataManager()
        currentApp.dbManager.reset()
    }

    func testFetchTripsWithMock() async throws {
        // Given
        let apiManagerMock = APIManagerMock()
        sut = DataManager(apiManager: apiManagerMock)
        
        let expectation = expectation(description: "fetchTrips")
        // When
        let result = await sut.fetchTrips()
        switch result {
        case .success( _):
            // Then
            XCTAssertEqual(apiManagerMock.fetchTripsCounter, 1)
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
    }
    
    func testFetchTrips() async throws {

        let expectation = expectation(description: "fetchTrips")
        // When
        let result = await sut.fetchTrips()
        switch result {
        case .success(let trips):
            // Then
            XCTAssertEqual(trips.count, 7)
            XCTAssertEqual(trips[3].destination.address.isEmpty, false)
            XCTAssertEqual(trips[3].origin.address.isEmpty, false)
            XCTAssertEqual(trips[3].status, "scheduled")
            XCTAssertEqual(trips[3].origin.address.isEmpty, false)
            XCTAssertEqual(trips[3].origin.point.latitude > 0, true)
            XCTAssertEqual(trips[3].route.isEmpty, false)
            XCTAssertNil(trips[3].stopPoints[0].id)
            XCTAssertEqual(trips[3].stopPoints[1].id, 9)
            XCTAssertEqual(trips[3].stopPoints[2].id, 10)
            XCTAssertNil(trips[3].stopPoints[3].id)
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
    }
    
    func testfetchStops() async throws {
        let expectation = expectation(description: "fetchTrips")
        // Given
        let result = await sut.fetchTrips()
        switch result {
        case .success(let trips):
            let trip = trips[0]
            XCTAssertNil(trip.stopPoints[0].stop)
            // When
            let result = await sut.fetchStops(trip: trip)
            switch result {
            case .success(let tripUpdated):
                // Then
                XCTAssertNotNil(tripUpdated)
                XCTAssertEqual(tripUpdated.stopPoints[0].stop, trip.stopPoints[0].stop)
                XCTAssertNotNil(tripUpdated.stopPoints[1].stop)
                XCTAssertEqual(tripUpdated.stopPoints[1].stop?.userName,"Manuel Gomez")
                XCTAssertEqual(tripUpdated.stopPoints[1].stop?.address,"Ramblas, Barcelona")
                XCTAssertNotNil(tripUpdated.stopPoints[2].stop)
                XCTAssertNotNil(tripUpdated.stopPoints[3].stop)
                XCTAssertNotNil(tripUpdated.stopPoints[4].stop)
                XCTAssertEqual(tripUpdated.stopPoints[5].stop, trip.stopPoints[0].stop)
            default:
                              XCTFail("Unexpected response")
            }
        default:
            XCTFail("Unexpected response")
        }
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
    }
    
    func testCreateIssueAsync() async {
        // Given
        let issue = Issue(route: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@",
                          name: "Sara",
                          surename: "Gutierrez",
                          email: "sagu@mailinator.com",
                          timestamp: 123,
                          report: "blah, blah",
                          phone: "123456789",
                          endTime: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")

        let asyncExpectation = expectation(description: "\(#function)")
        // When
        await sut.create(issue: issue)
        // Then
        let issueFetched  = await sut.getIssue(endTime: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        XCTAssertNotNil(issueFetched)
        XCTAssertEqual(issueFetched?.route, "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        XCTAssertEqual(issueFetched?.name, "Sara")
        XCTAssertEqual(issueFetched?.surename, "Gutierrez")
        XCTAssertEqual(issueFetched?.email, "sagu@mailinator.com")
        XCTAssertEqual(issueFetched?.timestamp, 123)
        XCTAssertEqual(issueFetched?.report, "blah, blah")
        XCTAssertEqual(issueFetched?.phone, "123456789")
        XCTAssertEqual(issueFetched?.endTime, "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        asyncExpectation.fulfill()
        await self.waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testGetRouteWOIssue() async {
        // Given
        // When
        let asyncExpectation = expectation(description: "\(#function)")
        let result = await sut.fetchTrips()
        switch result {
        case .success(let trips):
            // Then
            let tripsWithIssues = trips.filter({ $0.hasIssue })
            XCTAssertEqual(tripsWithIssues.count, 0)
        case .failure:
            XCTFail()

        }
        asyncExpectation.fulfill()
        await self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchIssueWhenExists() async {
        // Given
        let issueDB = IssueDB(route: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@",
                              name: "Sara",
                              surename: "Gutierrez",
                              email: "sagu@mailinator.com",
                              timestamp: 123,
                              report: "blah, blah", phone: "123456789",
                              endTime: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        await currentApp.dbManager.create(issueDB: issueDB)
        let asyncExpectation = expectation(description: "\(#function)")
        // When
        let issue = await sut.getIssue(endTime: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        XCTAssertNotNil(issue)
        XCTAssertEqual(issue?.route, "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        XCTAssertEqual(issue?.name, "Sara")
        XCTAssertEqual(issue?.surename, "Gutierrez")
        XCTAssertEqual(issue?.email, "sagu@mailinator.com")
        XCTAssertEqual(issue?.timestamp, 123)
        XCTAssertEqual(issue?.report, "blah, blah")
        XCTAssertEqual(issue?.phone, "123456789")
        XCTAssertEqual(issue?.endTime, "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        
        asyncExpectation.fulfill()
        await self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchIssueWhenDoesNotExists() async {
        // Given
        let issueDB = IssueDB(route: "1",
                              name: "Sara",
                              surename: "Gutierrez",
                              email: "sagu@mailinator.com",
                              timestamp: 123,
                              report: "blah, blah", phone: "123456789",
                              endTime: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")
        await currentApp.dbManager.create(issueDB: issueDB)
        let asyncExpectation = expectation(description: "\(#function)")
        // When
        let issue = await sut.getIssue(endTime: "2")
        XCTAssertNil(issue)
        asyncExpectation.fulfill()
        await self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_getIssuesCountAsync() async {

        XCTAssertEqual(sut.getIssuesCount(), 0)
        // Given
        let issue = Issue(route: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@",
                          name: "Sara",
                          surename: "Gutierrez",
                          email: "sagu@mailinator.com",
                          timestamp: 123,
                          report: "blah, blah", phone: "123456789",
                          endTime: "sdq{Fc}iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@")

        let asyncExpectation = expectation(description: "\(#function)")
        // When
        await sut.create(issue: issue)

        // Then
        XCTAssertEqual(sut.getIssuesCount(), 1)
        asyncExpectation.fulfill()
        await self.waitForExpectations(timeout: 2.0, handler: nil)
    }
}
