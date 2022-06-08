//
//  CastingViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 08/05/2022.
//

import SwiftUI
import TheMovieDBService

class CastingViewModel: ObservableObject {
    private let movieID: Int
    private let movieDBService: TheMovieDBServiceProtocol
    @Published private var movieCastingResponse: MovieCastingResponse?
    @Published private var feedStates = FeedRequestState.success
    @Published var errorMessage: String?
    
    init(movieDBService: TheMovieDBServiceProtocol = TheMovieDBService(), movieID: Int) {
        self.movieDBService = movieDBService
        self.movieID = movieID
        Task { [weak self] in
            await self?.requestCasting()
        }
    }
    
    var movieCasts: [MovieCast] {
        return movieCastingResponse?.cast ?? []
    }
    
    var isInitialFeedLoading: Bool {
        return movieCastingResponse == nil && feedStates == .loading
    }
    
    var isInitialFeedFailedToLoad: Bool {
        return movieCastingResponse == nil && feedStates == .error
    }
    
    func castImageRequest(movieCast: MovieCast) -> URLRequest? {
        let router = TheMovieDBServiceRouter()
        guard let posterPath = movieCast.profilePath else {return nil}
        return router.castImageRequest(forImageId: posterPath)
    }
    
    @MainActor
    func requestCasting() async {
        guard feedStates != .loading else {return}
        feedStates = .loading
        let result = await movieDBService.requestMovieCasting(movieID: movieID.description, decodingType: MovieCastingResponse.self)
        handle(result)
    }
    
    // MARK: Handlers
    @MainActor
    private func handle(_ requestResult: Result<MovieCastingResponse, Error>) {
        switch requestResult {
        case .success(let feedResponse):
            movieCastingResponse = feedResponse
            feedStates = .success
        case .failure(let error):
            feedStates = .error
            errorMessage = error.localizedDescription
        }
    }
}


// MARK: - MovieCastingResponse
fileprivate struct MovieCastingResponse: Codable {
    let id: Int
    let cast: [MovieCast]
}

// MARK: - Cast
struct MovieCast: Codable {
    let id: Int
    let originalName: String
    let profilePath: String?
    let character: String?

    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case profilePath = "profile_path"
        case character
    }
}
