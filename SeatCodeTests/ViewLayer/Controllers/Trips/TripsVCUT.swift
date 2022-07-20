//
//  TripsVCUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 20/7/22.
//
@testable import SeatCode
import XCTest

class TripsVCUT: XCTestCase {

    var sut: TripsVC!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TripsVC.instantiate()
    }

    func testTitle() {
        _ = sut.view
        XCTAssertEqual(sut.title, "User trips")
    }
}
