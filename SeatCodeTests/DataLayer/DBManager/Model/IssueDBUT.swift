//
//  IssueDBUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 20/7/22.
//
@testable import SeatCode
import XCTest

class IssueDBUT: XCTestCase {

    func testConsturctor() {
        // Given
        // When
        let issueDB = IssueDB(route: "a",
                              name: "as",
                              surename: "df",
                              email: "asdf@gmail.com",
                              timestamp: 123,
                              report:"blah, blah",
                              phone: "123456789",
                              endTime: "a")
        // Then
        XCTAssertEqual(issueDB.route, "a")
        XCTAssertEqual(issueDB.name, "as")
        XCTAssertEqual(issueDB.surename, "df")
        XCTAssertEqual(issueDB.email, "asdf@gmail.com")
        XCTAssertEqual(issueDB.timestamp, 123)
        XCTAssertEqual(issueDB.report, "blah, blah")
        XCTAssertEqual(issueDB.phone, "123456789")
        XCTAssertEqual(issueDB.endTime, "a")
        
    }
    
    func testConstructorWhenIssue() {
        // Given
        // When
        let issue = Issue(route: "a",
                          name: "as",
                          surename: "df",
                          email: "asdf@gmail.com",
                          timestamp: 123,
                          report:"blah, blah",
                          phone: "123456789",
                          endTime: "a")
        let issueDB = IssueDB(issue: issue)
        // Then
        XCTAssertEqual(issueDB.route, "a")
        XCTAssertEqual(issueDB.name, "as")
        XCTAssertEqual(issueDB.surename, "df")
        XCTAssertEqual(issueDB.email, "asdf@gmail.com")
        XCTAssertEqual(issueDB.timestamp, 123)
        XCTAssertEqual(issueDB.report, "blah, blah")
        XCTAssertEqual(issueDB.phone, "123456789")
        XCTAssertEqual(issueDB.endTime, "a")
        
    }
}
