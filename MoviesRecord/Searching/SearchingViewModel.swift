//
//  SearchingViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 11/05/2022.
//

import TheMovieDBService
import Foundation

class SearchingViewModel: ObservableObject {
    let movieDBService: TheMovieDBServiceProtocol
    @Published private var feedResponse: MovieSearchingResponse?
    @Published var errorMessage: String?
    @Published private var feedRequestState: FeedRequestState = .success
    
    init(movieDBService: TheMovieDBServiceProtocol = TheMovieDBService() ) {
        self.movieDBService = movieDBService
    }
    
    // MARK: Accessors
    var isFeedLoadingData: Bool {
        return feedRequestState == .loading
    }
    
    var isInitialFeedFailedToLoad: Bool {
        return feedRequestState == .error && feedResponse == nil
    }
    
    var isInitialFeedLoading: Bool {
        return isFeedLoadingData && feedResponse == nil
    }
    
    var movies: [Movie] {
        return feedResponse?.movies ?? []
    }
    
    func searchForMovie(query: String) async {
        guard feedRequestState != .loading else {return}
        feedRequestState = .loading
        let result = await movieDBService.requestMovieSearch(query: query, decodingType: MovieSearchingResponse.self)
        await handle(result)
    }
    
    func imageURL(imagePath: String?) -> URLRequest? {
        guard let imagePath = imagePath else { return nil }
        let router = TheMovieDBServiceRouter()
        return router.imageRequest(forImageId: imagePath)
    }
    
    @MainActor
    private func handle(_ requestResult: Result<MovieSearchingResponse, Error>) {
        switch requestResult {
        case .success(let response):
            feedResponse = response
            feedRequestState = .success
        case .failure(let error):
            errorMessage = error.localizedDescription
            feedRequestState = .error
        }
    }
}

fileprivate struct MovieSearchingResponse: Codable {
    var page: Int
    var movies: [Movie]
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
    }
}
