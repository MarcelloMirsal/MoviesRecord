//
//  MovieListItem+CoreDataProperties.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//
//

import Foundation
import CoreData


extension MovieListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieListItem> {
        return NSFetchRequest<MovieListItem>(entityName: "MovieListItem")
    }

    @NSManaged public var apiID: Int64
    @NSManaged public var date: Date
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String
    @NSManaged public var movieList: MovieList?

}

extension MovieListItem : Identifiable {

}
