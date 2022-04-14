//
//  TheMovieDBServiceRouter.swift
//  TheMovieDBService
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import Foundation

public struct TheMovieDBServiceRouter {
    let version = "3"
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/\(version)")!
    }
    public init() {
    }
    
    func discoverMoviesRequest(page: Int = 1) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL.absoluteString)!
        let path = Routing.discoverMoviesPath.rawValue
        let apiKeyQuery = Queries.apiKey.rawValue
        let pageQuery = Queries.page.rawValue
        urlComponents.path += path
        urlComponents.queryItems = [
            .init(name: apiKeyQuery, value: NetworkingConstants.apiKey.rawValue),
            .init(name: pageQuery, value: "\(page)")
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
    public func imageRequest(forImageId id: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://www.themoviedb.org/t/p")!
        urlComponents.path += Routing.imageSizePath.rawValue
        urlComponents.path += "/\(id)"
        return URLRequest(url: urlComponents.url!)
    }
    
    func parse<T: Decodable>(data: Data, to type: T.Type, decoder: JSONDecoder = .init() ) throws -> T {
        do {
            let decodableObject = try decoder.decode(type, from: data)
            return decodableObject
        } catch {
            throw ServiceError.decoding
        }
    }
}


fileprivate enum Routing: String {
    case discoverMoviesPath = "/discover/movie"
    case imageSizePath = "/w400"
}

fileprivate enum Queries: String {
    case apiKey = "api_key"
    case page = "page"
}

