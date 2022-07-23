//
//  DBManagerUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 20/7/22.
//
@testable import SeatCode
import XCTest

class DBManagerUT: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        currentApp.dbManager.reset()
    }

    // MARK: - Issue
    func testDBIsEmptyAtTheBeggining() {
        XCTAssertEqual(currentApp.dbManager.getIssues().count, 0)
    }

    func testCreateIssueAsync() async {
        // Given
        let expectation = expectation(description: "fetchTrips")
        // When
        let issueDB = IssueDB(route: "1", name: "Sara", surename: "Gutierrez", email: "sagu@mailinator.com", timestamp: 123, report: "blah, blah", phone: "123456789", endTime: "1")
        await currentApp.dbManager.create(issueDB: issueDB)
        // Then
        let count = await currentApp.dbManager.getIssues().count
        XCTAssertEqual(count, 1)
        guard let issueDBStored = await currentApp.dbManager.getIssues().first else {
            XCTFail("testCreateIssueAsync failed")
            return
        }
        XCTAssertEqual(issueDBStored.route, "1")
        XCTAssertEqual(issueDBStored.name, "Sara")
        XCTAssertEqual(issueDBStored.surename, "Gutierrez")
        XCTAssertEqual(issueDBStored.email, "sagu@mailinator.com")
        XCTAssertEqual(issueDBStored.timestamp, 123)
        XCTAssertEqual(issueDBStored.report, "blah, blah")
        XCTAssertEqual(issueDBStored.phone, "123456789")
        XCTAssertEqual(issueDBStored.endTime, "1")
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
    }

    func testUpdateIssueAsync() async {

        let issueDB = IssueDB(route: "1",
                              name: "Sara",
                              surename: "Gutierrez",
                              email: "sagu@mailinator.com",
                              timestamp: 123,
                              report: "blah, blah",
                              phone: "123456789", endTime: "1")
        await currentApp.dbManager.create(issueDB: issueDB)
        // Given
        let issueDBNew = IssueDB(route: "1",
                                 name: "Juan",
                                 surename: "Sino",
                                 email: "jusi@mailinator.com",
                                 timestamp: 53,
                                 report: "plat, plat",
                                 phone: "2222222222", endTime: "1")
        await currentApp.dbManager.create(issueDB: issueDBNew)
        // When
        let issues = await currentApp.dbManager.getIssues()
        XCTAssertEqual(issues.count, 1)
        guard let issueDBStored = issues.first else {
            XCTFail("testUpdateIssueAsync")
            return
        }
        XCTAssertEqual(issueDBStored.route, "1")
        XCTAssertEqual(issueDBStored.name, "Juan")
        XCTAssertEqual(issueDBStored.surename, "Sino")
        XCTAssertEqual(issueDBStored.email, "jusi@mailinator.com")
        XCTAssertEqual(issueDBStored.timestamp, 53)
        XCTAssertEqual(issueDBStored.report, "plat, plat")
        XCTAssertEqual(issueDBStored.phone, "2222222222")
        XCTAssertEqual(issueDBStored.endTime, "1")
    }

}
