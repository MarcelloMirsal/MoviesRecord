//
//  MovieList+CoreDataProperties.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//
//

import Foundation
import CoreData


extension MovieList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieList> {
        return NSFetchRequest<MovieList>(entityName: "MovieList")
    }

    @NSManaged public var createDate: Date
    @NSManaged public var name: String
    @NSManaged public var movieListItems: NSOrderedSet?

}

// MARK: Generated accessors for movieListItems
extension MovieList {

    @objc(insertObject:inMovieListItemsAtIndex:)
    @NSManaged public func insertIntoMovieListItems(_ value: MovieListItem, at idx: Int)

    @objc(removeObjectFromMovieListItemsAtIndex:)
    @NSManaged public func removeFromMovieListItems(at idx: Int)

    @objc(insertMovieListItems:atIndexes:)
    @NSManaged public func insertIntoMovieListItems(_ values: [MovieListItem], at indexes: NSIndexSet)

    @objc(removeMovieListItemsAtIndexes:)
    @NSManaged public func removeFromMovieListItems(at indexes: NSIndexSet)

    @objc(replaceObjectInMovieListItemsAtIndex:withObject:)
    @NSManaged public func replaceMovieListItems(at idx: Int, with value: MovieListItem)

    @objc(replaceMovieListItemsAtIndexes:withMovieListItems:)
    @NSManaged public func replaceMovieListItems(at indexes: NSIndexSet, with values: [MovieListItem])

    @objc(addMovieListItemsObject:)
    @NSManaged public func addToMovieListItems(_ value: MovieListItem)

    @objc(removeMovieListItemsObject:)
    @NSManaged public func removeFromMovieListItems(_ value: MovieListItem)

    @objc(addMovieListItems:)
    @NSManaged public func addToMovieListItems(_ values: NSOrderedSet)

    @objc(removeMovieListItems:)
    @NSManaged public func removeFromMovieListItems(_ values: NSOrderedSet)

}

extension MovieList : Identifiable {

}
