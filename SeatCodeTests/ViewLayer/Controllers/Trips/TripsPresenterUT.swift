//
//  TripsPresenterUT.swift
//  SeatCodeTests
//
//  Created by Javier Calatrava on 19/7/22.
//
@testable import SeatCode
import XCTest

class TripsPresenterUT: XCTestCase {
    
    var sut: TripsPresenterProtocol!
    var oldApp = currentApp

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TripsPresenter()
    }
}
