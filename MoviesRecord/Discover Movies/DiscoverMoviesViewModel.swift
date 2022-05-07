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
    private var feedResponse = DiscoverMoviesResponse(page: 0, movies: [], totalPages: 0)
    
    
    private(set) var errorMessage: String?
    
    @Published
    private var feedRequestState: FeedRequestState = .success
    
    init(movieDBService: TheMovieDBServiceProtocol = TheMovieDBService() ) {
        self.movieDBService = movieDBService
        Task {
            await requestFeed()
        }
    }
    
    
    var canShowNextPageLoadingProgress: Bool {
        return canLoadFeedNextPage && feedRequestState != .error
    }
    
    var canShowNextPageLoadingError: Bool {
        return canLoadFeedNextPage && feedRequestState == .error
    }
    
    // MARK: Accessors
    var isFeedLoadingData: Bool {
        return feedRequestState == .loading
    }
    
    var isInitialFeedFailedToLoad: Bool {
        return feedRequestState == .error && feedResponse.totalPages == 0
    }
    
    var isInitialFeedLoading: Bool {
        return feedRequestState == .loading && feedResponse.totalPages == 0
    }
    
    var canLoadFeedNextPage: Bool {
        let totalPages = feedResponse.totalPages
        let nextPage = feedResponse.page + 1
        return nextPage <= totalPages
    }
    
    
    func imageURL(forImageID imageID: String?) -> URLRequest? {
        guard let imageID = imageID else { return nil }
        let theMovieDBServiceRouter = TheMovieDBServiceRouter()
        return theMovieDBServiceRouter.imageRequest(forImageId: imageID)
    }
    
    func posterDate(stringDate: String) -> String {
        return DateFormatter.sharedFormattedDate(stringDate: stringDate)
    }
    
    func headerDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    var movies: [Movie] {
        return feedResponse.movies
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
    private func append(_ newFeedResponse: DiscoverMoviesResponse) {
        let configuredFeedResponse = DiscoverMoviesResponse(page: newFeedResponse.page, movies: feedResponse.movies + newFeedResponse.movies, totalPages: newFeedResponse.totalPages)
        set(configuredFeedResponse)
    }
    
    @MainActor
    private func set(feedRequestState: FeedRequestState) {
        self.feedRequestState = feedRequestState
    }
    
    func requestFeed() async {
        guard isFeedLoadingData == false else {
            return
        }
        await set(feedRequestState: .loading)
        let requestResult = await movieDBService.requestDiscoverMovies(page: 1, decodingType: DiscoverMoviesResponse.self)
        await handle(requestResult)
    }
    
    func requestFeedNextPage() async {
        guard isFeedLoadingData == false, canLoadFeedNextPage else {
            return
        }
        await set(feedRequestState: .loading)
        let nextPage = feedResponse.page + 1
        let requestResult = await movieDBService.requestDiscoverMovies(page: nextPage, decodingType: DiscoverMoviesResponse.self)
        await handleNextPage(requestResult)
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
    
    @MainActor
    private func handleNextPage(_ requestResult: Result<DiscoverMoviesResponse, Error>) {
        switch requestResult {
        case .success(let nextPageFeedResponse):
            append(nextPageFeedResponse)
            set(feedRequestState: .success)
        case .failure(let error):
            set(errorMessage: error.localizedDescription)
            set(feedRequestState: .error)
        }
    }
}

fileprivate struct DiscoverMoviesResponse: Codable {
    var page: Int
    var movies: [Movie]
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
    }
}

fileprivate enum FeedRequestState {
    case loading
    case success
    case error
}
