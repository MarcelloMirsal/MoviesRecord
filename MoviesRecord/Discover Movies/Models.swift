//
//  Models.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 22/04/2022.
//

import Foundation

// MARK: - Movie
struct Movie: Codable, Equatable, Hashable {
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let posterPath: String?
    let releaseDate: String
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
