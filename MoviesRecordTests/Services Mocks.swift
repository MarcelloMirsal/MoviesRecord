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
        do {
            let jsonDecoder = JSONDecoder()
            let decodedObject = try jsonDecoder.decode(decodingType, from: responseData)
            return .success(decodedObject)
        } catch {
            return .failure(ServiceError.decoding)
        }
    }
    
}
