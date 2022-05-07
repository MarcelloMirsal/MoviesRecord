//
//  Network Constants.swift
//  TheMovieDBService
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import Foundation

enum NetworkingConstants: String {
    case apiKey = "6203d05815ada391f8b581d00ebbdbd5"
}

public enum MovieGenres: Int, CaseIterable {
    case action = 28, adventure = 12, animation = 16, comedy = 35, crime = 80, documentary = 99, drama = 18, family = 10751, fantasy = 14, history = 36, horror = 27, music = 10402, mystery = 9648, romance = 10749, scienceFiction = 878, tvMovie = 10770, thriller = 53, war = 10752, western = 37
    
    public var name: String {
        switch self {
        case .action:
            return "Action"
        case .adventure:
            return "Adventure"
        case .animation:
            return "Animation"
        case .comedy:
            return "Comedy"
        case .crime:
            return "Crime"
        case .documentary:
            return "Documentary"
        case .drama:
            return "Drama"
        case .family:
            return "Family"
        case .fantasy:
            return "Fantasy"
        case .history:
            return "History"
        case .horror:
            return "Horror"
        case .music:
            return "Music"
        case .mystery:
            return "Mystery"
        case .romance:
            return "Romance"
        case .scienceFiction:
            return "Science Fiction"
        case .tvMovie:
            return "TV Movie"
        case .thriller:
            return "Thriller"
        case .war:
            return "War"
        case .western:
            return "Western"
        }
        
    }
}
