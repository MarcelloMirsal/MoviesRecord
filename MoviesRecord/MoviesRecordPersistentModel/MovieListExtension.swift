//
//  MovieList+CoreDataClass.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 05/06/2022.
//
//

import Foundation
import CoreData

extension MovieList {
    var creationStringDate: String {
        guard let createDate = createDate else {return ""}
        return DateFormatter.stringDate(fromSharedFormattedDate: createDate)
    }
    
    var listName: String {
        return name ?? ""
    }
    
    
    var listItems: [MovieListItem] {
        guard let movieListItems = movieListItems else { return [] }
        return movieListItems.allObjects as? [MovieListItem] ?? []
    }
    
}
