//
//  TheMovieDBService.swift
//  TheMovieDBService
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import Foundation

class TheMovieDBService {
    let networkingManager: NetworkingManagerProtocol
    let router = TheMovieDBServiceRouter()
    init(networkingManager: NetworkingManagerProtocol = NetworkingManager()) {
        self.networkingManager = networkingManager
    }
    
    func requestDiscoverMovies<T: Decodable>(page: Int, decodingType: T.Type) async -> Result<T, Error> {
        let urlRequest = router.discoverMoviesRequest(page: page)
        return await networkRequest(urlRequest: urlRequest, decodingType: decodingType)
    }
    
    private func networkRequest<T: Decodable>(urlRequest: URLRequest, decodingType: T.Type) async -> Result<T, Error> {
        do {
            let data = try await networkingManager.json(for: urlRequest)
            let decodedObject = try router.parse(data: data, to: decodingType)
            return .success(decodedObject)
        } catch let networkError as NetworkError {
            return .failure(ServiceError.networkingFailure(networkError))
        } catch {
            return .failure(ServiceError.decoding)
        }
    }
}