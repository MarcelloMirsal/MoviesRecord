//
//  NetworkManager.swift
//  NetworkingServices
//
//  Created by Marcello Mirsal on 09/11/2021.
//

import Alamofire

protocol NetworkingManagerProtocol {
    func json(for urlRequest: URLRequest) async throws -> Data
}

final class NetworkingManager: NetworkingManagerProtocol {
    let session: Alamofire.Session
    init(sessionConfigs: URLSessionConfiguration = .default) {
        session = .init(configuration: sessionConfigs)
    }
    
    func json(for urlRequest: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation({ continuation in
            session.request(urlRequest).validate().responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let afError):
                    let networkError = NetworkError(afError: afError)
                    continuation.resume(throwing: networkError)
                }
            }
        })
    }
}
