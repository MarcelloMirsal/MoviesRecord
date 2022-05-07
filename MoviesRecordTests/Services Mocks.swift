//
//  Services Mocks.swift
//  MoviesRecordTests
//
//  Created by Mohammed Mirsal on 13/04/2022.
//

import TheMovieDBService

class MockTheMovieDBService: TheMovieDBServiceProtocol {
    
    let responseData: Data
    init(responseData: Data) {
        self.responseData = responseData
    }
    
    func requestDiscoverMovies<T>(page: Int, decodingType: T.Type) async -> Result<T, Error> where T : Decodable {
        return await handleFakeRequest(decodingType: decodingType)
    }
    
    func requestMovieVideos<T>(movieID: String, decodingType: T.Type) async -> Result<T, Error> where T : Decodable {
        return await handleFakeRequest(decodingType: decodingType)
    }
    
    func requestMovieImages<T>(movieID: String, decodingType: T.Type) async -> Result<T, Error> where T : Decodable {
        return await handleFakeRequest(decodingType: decodingType)
    }
    
    private func handleFakeRequest<T: Decodable>(decodingType: T.Type) async -> Result<T, Error> {
        do {
            let jsonDecoder = JSONDecoder()
            let decodedObject = try jsonDecoder.decode(decodingType, from: responseData)
            return .success(decodedObject)
        } catch let networkError as NetworkError {
            return .failure(ServiceError.networkingFailure(networkError))
        } catch {
            return .failure(ServiceError.decoding)
        }
    }
}
