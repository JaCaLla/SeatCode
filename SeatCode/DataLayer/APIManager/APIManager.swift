//
//  APIManager.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation

protocol APIManagerProtocol: AnyObject {
   func fetchTrips() async -> Result<[TripAPI], ErrorAPI>
    func fetchStop(id: Int) async -> Result<StopAPI, ErrorAPI>
    func fetchStopsSeq(ids: [Int]) async -> Result<[Int: StopAPI], ErrorAPI>
    func fetchStopsPar(ids: [Int]) async -> Result<[Int: StopAPI], ErrorAPI>
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
    
    func fetchStop(id: Int) async -> Result<StopAPI, ErrorAPI> {
        let url = createURLFromParameters(parameters: [:], pathparam: "stops/\(id)")
        return await fetchAsync(url: url)
    }
    
    func fetchStopsSeq(ids: [Int]) async -> Result<[Int: StopAPI], ErrorAPI> {
        var stopsAPI: [Int: StopAPI] = [:]
        for id in ids {
            let result = await fetchStop(id: id)
            switch result {
            case .success(let stopAPI):
                stopsAPI[id] = stopAPI
            case .failure(let errorAPI):
                return .failure(errorAPI)
            }
        }
        return .success(stopsAPI)
    }
    
    func fetchStopsPar(ids: [Int]) async -> Result<[Int: StopAPI], ErrorAPI> {
        let results : [Int: Result<StopAPI, ErrorAPI>] =
        await withTaskGroup(of: (Int, Result<StopAPI, ErrorAPI>).self, body: { [self] group in
            for id in ids {
                group.addTask { [self] in await (id, self.fetchStop(id: id))}
            }
            return await group.reduce(into: [:]) { $0[$1.0] = $1.1 }
        })
        
        var stopsAPI: [Int: StopAPI] = [:]
        for id in ids {
            switch results[id] {
            case .success(let stopAPI):
                stopsAPI[id] = stopAPI
            case .failure(let errorAPI):
                return .failure(errorAPI)
            case .none:
                return .failure(.failedParallelFetching)
            }
        }
        return .success(stopsAPI)
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
