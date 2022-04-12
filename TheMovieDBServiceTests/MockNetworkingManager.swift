//
//  MockNetworkingManager.swift
//  TheMovieDBServiceTests
//
//  Created by Mohammed Mirsal on 12/04/2022.
//

import Foundation
@testable import TheMovieDBService

final class MockNetworkingManager: NetworkingManagerProtocol {
    let data: Data
    init(data: Data) {
        self.data = data
    }
    func json(for urlRequest: URLRequest) async throws -> Data {
        return data
    }
}
