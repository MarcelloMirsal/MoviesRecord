//
//  DiscoverMoviesViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 12/04/2022.
//

import TheMovieDBService
import Combine

class DiscoverMoviesViewModel: ObservableObject {
    
    private let movieDBService: TheMovieDBServiceProtocol
    
    @Published
    private var feedResponse: DiscoverMoviesResponse = .init(page: 0, movies: [], totalPages: 0)
    private(set) var errorMessage: String?
    
    @Published
    private var feedRequestState: FeedRequestState = .success
    
    init(movieDBService: TheMovieDBServiceProtocol = TheMovieDBService() ) {
        self.movieDBService = movieDBService
        Task {
            await requestFeed()
        }
    }
    
    // MARK: Accessors
    var isFeedLoadingData: Bool {
        return feedRequestState == .loading
    }
    
    var isInitialFeedFailedToLoad: Bool {
        return feedRequestState == .error && feedResponse.totalPages == 0
    }
    
    var movies: [Movie] {
        return feedResponse.movies
    }
    
    func imageURL(forImageID imageID: String) -> URLRequest {
        let theMovieDBServiceRouter = TheMovieDBServiceRouter()
        return theMovieDBServiceRouter.imageRequest(forImageId: imageID)
    }
    
    @MainActor
    private func set(_ feedResponse: DiscoverMoviesResponse) {
        self.feedResponse = feedResponse
    }
    
    @MainActor
    private func set(errorMessage: String?) {
        self.errorMessage = errorMessage
    }
    
    @MainActor
    private func set(feedRequestState: FeedRequestState) {
        self.feedRequestState = feedRequestState
    }
    
    // MARK: UI calls
    func requestFeed() async {
        guard isFeedLoadingData == false else {
            return
        }
        await set(feedRequestState: .loading)
        let requestResult = await movieDBService.requestDiscoverMovies(page: 1, decodingType: DiscoverMoviesResponse.self)
        await handle(requestResult)
    }
    
    // MARK: Handlers
    @MainActor
    private func handle(_ requestResult: Result<DiscoverMoviesResponse, Error>) {
        switch requestResult {
        case .success(let feedResponse):
            set(feedResponse)
            set(feedRequestState: .success)
        case .failure(let error):
            set(errorMessage: error.localizedDescription)
            set(feedRequestState: .error)
        }
    }
}

struct DiscoverMoviesResponse: Codable {
    let page: Int
    let movies: [Movie]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let posterPath, releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

fileprivate enum FeedRequestState {
    case loading
    case success
    case error
}
