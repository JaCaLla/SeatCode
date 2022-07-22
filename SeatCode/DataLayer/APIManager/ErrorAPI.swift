//
//  ErrorAPI.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

enum ErrorAPI: Error {
    case errorResponse(Error)
    case invalidHTTPResponse
    case failedOnParsingJSON
    case noDataResponse
    case failedParallelFetching
    case fetchStopsFailed
}
