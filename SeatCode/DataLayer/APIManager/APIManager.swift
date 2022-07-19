//
//  APIManager.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

protocol APIManagerProtocol: AnyObject {
   func fetchTrips() async -> Result<[TripAPI], ErrorAPI>
}

internal final class APIManager: APIManagerProtocol {

    private let apiScheme = "https"
    private let host = "europe-west1-metropolis-fe-test.cloudfunctions.net"
    private let path = "/api/"
    private let decoder = JSONDecoder()


    // MARK: - APIManagerProtocol
    func fetchTrips() async -> Result<[TripAPI], ErrorAPI> {
        let url = createURLFromParameters(parameters: [:], pathparam: "trips")
        return await fetchAsync(url: url)
    }

    // MARK: - Private/Internal functions
    fileprivate func fetchAsync<T: Codable>(url: URL) async -> Result<T , ErrorAPI> {

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                return .failure(ErrorAPI.invalidHTTPResponse)
            }
            do {
                decoder.dateDecodingStrategy = dateDecodingStrategy()
                let dataParsed: T = try self.decoder.decode(T.self, from: data)
                return .success(dataParsed)
            } catch {
                return .failure(ErrorAPI.failedOnParsingJSON)
            }
        } catch {
            return .failure(ErrorAPI.errorResponse(error))
        }
    }
    
    private func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return .formatted(dateFormatter)
    }
    
    private func createURLFromParameters(parameters: [String: Any], pathparam: String?) -> URL {

        var components = URLComponents()
        components.scheme = apiScheme
        components.host = host
        components.path = path
        if let paramPath = pathparam {
            components.path = path + "\(paramPath)"
        }
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }

        return components.url!
    }
}
