//
//  TheMovieDBService.swift
//  TheMovieDBService
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import Foundation

public protocol TheMovieDBServiceProtocol {
    func requestDiscoverMovies<T: Decodable>(page: Int, decodingType: T.Type) async -> Result<T, Error>
    func requestMovieVideos <T: Decodable>(movieID: String, decodingType: T.Type) async -> Result<T, Error>
    func requestMovieImages <T: Decodable>(movieID: String, decodingType: T.Type) async -> Result<T, Error>
    func requestMovieCasting <T: Decodable>(movieID: String, decodingType: T.Type) async -> Result<T, Error>
    func requestMovieSearch <T: Decodable>(query: String, decodingType: T.Type) async -> Result<T, Error>
}


public final class TheMovieDBService: TheMovieDBServiceProtocol {
    
    let networkingManager: NetworkingManagerProtocol
    let router = TheMovieDBServiceRouter()
    public init() {
        self.networkingManager = NetworkingManager()
    }
    
    init(networkingManager: NetworkingManagerProtocol) {
        self.networkingManager = networkingManager
    }
    
    public func requestDiscoverMovies<T: Decodable>(page: Int, decodingType: T.Type) async -> Result<T, Error> {
        let urlRequest = router.discoverMoviesRequest(page: page)
        return await networkRequest(urlRequest: urlRequest, decodingType: decodingType)
    }
    
    public func requestMovieVideos <T: Decodable>(movieID: String, decodingType: T.Type) async -> Result<T, Error> {
        let urlRequest = router.movieVideosRequest(movieID: movieID)
        return await networkRequest(urlRequest: urlRequest, decodingType: decodingType)
    }
    
    public func requestMovieImages<T>(movieID: String, decodingType: T.Type) async -> Result<T, Error> where T : Decodable {
        let urlRequest = router.movieImagesRequest(movieID: movieID)
        return await networkRequest(urlRequest: urlRequest, decodingType: decodingType)
    }
    
    public func requestMovieCasting<T>(movieID: String, decodingType: T.Type) async -> Result<T, Error> where T : Decodable {
        let urlRequest = router.movieCastingRequest(movieID: movieID)
        return await networkRequest(urlRequest: urlRequest, decodingType: decodingType)
    }
    
    public func requestMovieSearch <T: Decodable>(query: String, decodingType: T.Type) async -> Result<T, Error> {
        let urlRequest = router.movieSearchRequest(query: query)
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
