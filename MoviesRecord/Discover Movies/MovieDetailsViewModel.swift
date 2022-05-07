//
//  MovieDetailsViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 22/04/2022.
//

import Foundation

import TheMovieDBService
class MovieDetailsViewModel: ObservableObject {
    let movieDBService: TheMovieDBServiceProtocol
    let movie: Movie
    let router = TheMovieDBServiceRouter()
    @Published var trailerVideoURL: URL? = nil
    
    init(movieDBService: TheMovieDBServiceProtocol = TheMovieDBService(), movie: Movie) {
        self.movieDBService = movieDBService
        self.movie = movie
        Task { [weak self] in
            await self?.requestMovieVideos()
        }
    }
    
    var numberOfStars: Int {
        return 5
    }
    var posterURL: URL? {
        guard let posterId = movie.posterPath else { return nil}
        return router.imageRequest(forImageId: posterId).url
    }
    var title: String {
        movie.originalTitle
    }
    var genres: String {
        let movieGenres = movie.genreIDS.map({ MovieGenres(rawValue: $0) }).compactMap({$0}).map({$0.name}).joined(separator: ", ")
        return movieGenres
    }
    var rating: Double {
        return floor(movie.voteAverage / 2)
    }
    var overview: String {
        movie.overview
    }
    var releaseDate: String {
        return DateFormatter.sharedFormattedDate(stringDate: movie.releaseDate)
    }
    
    
    private func requestMovieVideos() async {
        let result = await movieDBService.requestMovieVideos(movieID: movie.id.description, decodingType: MovieVideosResponse.self)
        switch result {
        case .success(let response):
            await setOfficialTrailerURL(from: response)
        case .failure:
            break
        }
    }
    
    @MainActor
    private func setOfficialTrailerURL(from movieVideosResponse: MovieVideosResponse) {
        guard let youtubeTrailerVideo = movieVideosResponse.results
                .filter({$0.official})
                .filter({$0.type == .trailer})
                .filter({$0.site == .youTube})
                .first else {return}
        trailerVideoURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeTrailerVideo.key)")
    }
    
    
}


fileprivate struct MovieVideosResponse: Codable {
    let results: [MovieVideo]
    
    struct MovieVideo: Codable {
        let key: String
        let official: Bool
        let type: VideoType
        let site: VideoSite?
        
        enum VideoType: String, Codable {
            case trailer = "Trailer"
            case unspecified
            
            init(from decoder: Decoder) throws {
                do {
                    let container = try decoder.singleValueContainer()
                    let decodedObject = try container.decode(String.self)
                    self = .init(rawValue: decodedObject) ?? .unspecified
                } catch {
                    self = .unspecified
                }
            }
        }
        
        enum VideoSite: String, Codable {
            case youTube = "YouTube"
            case unspecified
            
            init(from decoder: Decoder) throws {
                do {
                    let container = try decoder.singleValueContainer()
                    let decodedObject = try container.decode(String.self)
                    self = .init(rawValue: decodedObject) ?? .unspecified
                } catch {
                    self = .unspecified
                }
            }
        }
    }
}
