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
    
    public func movieDetailsRequest(movieID: String) -> URLRequest {
        let apiKeyQuery = Queries.apiKey.rawValue
        var urlComponents = URLComponents(string: baseURL.absoluteString)!
        urlComponents.path += Routing.movieDetails(movieID: movieID)
        urlComponents.queryItems = [
            .init(name: apiKeyQuery, value: NetworkingConstants.apiKey.rawValue)
        ]
        return .init(url: urlComponents.url!)
    }
    
    public func imageRequest(forImageId id: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://www.themoviedb.org/t/p")!
        urlComponents.path += Routing.imageSizePath.rawValue
        urlComponents.path += "/\(id)"
        return URLRequest(url: urlComponents.url!)
    }
    
    public func castImageRequest(forImageId id: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://www.themoviedb.org/t/p")!
        urlComponents.path += Routing.castingImageSize.rawValue
        urlComponents.path += "/\(id)"
        return URLRequest(url: urlComponents.url!)
    }
    
    func movieVideosRequest(movieID: String) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL.absoluteString)!
        urlComponents.path += Routing.movieVideos(movieID: movieID)
        urlComponents.queryItems = [
            .init(name: Queries.apiKey.rawValue, value: NetworkingConstants.apiKey.rawValue)
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
    func movieImagesRequest(movieID: String) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL.absoluteString)!
        urlComponents.path += Routing.movieImages(movieID: movieID)
        urlComponents.queryItems = [
            .init(name: Queries.apiKey.rawValue, value: NetworkingConstants.apiKey.rawValue)
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
    func movieCastingRequest(movieID: String) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL.absoluteString)!
        urlComponents.path += Routing.movieDetails(movieID: movieID)
        urlComponents.path += Routing.movieCasting.rawValue
        urlComponents.queryItems = [
            .init(name: Queries.apiKey.rawValue, value: NetworkingConstants.apiKey.rawValue)
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
    func movieSearchRequest(query: String) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL.absoluteString)!
        urlComponents.path.append(Routing.movieSearch.rawValue)
        urlComponents.queryItems = [
            .init(name: Queries.apiKey.rawValue, value: NetworkingConstants.apiKey.rawValue),
            .init(name: Queries.searchQuery.rawValue, value: query)
        ]
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
    case castingImageSize = "/w200"
    case movieDetails = "/movie"
    case movieCasting = "/credits"
    case movieSearch = "/search/movie"
    
    static func movieDetails(movieID: String) -> String {
        return Routing.movieDetails.rawValue.appending("/\(movieID)")
    }
    
    static func movieVideos(movieID: String) -> String {
        return Self.movieDetails(movieID: movieID).appending("/videos")
    }
    
    static func movieImages(movieID: String) -> String {
        return Self.movieDetails(movieID: movieID).appending("/images")
    }
}

fileprivate enum Queries: String {
    case apiKey = "api_key"
    case page = "page"
    case searchQuery = "query"
}

