//
//  MovieListItemFactory.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import CoreData
struct MovieListItemFactory {
    
    var coreDataStack: CoreDataStack {
        CoreDataStack.shared
    }
    
    @discardableResult
    func createMovieListItem(apiID: Int, title: String, posterPath: String?, date: Date, movieList: MovieList) -> MovieListItem {
        let newMovieListItem = MovieListItem(entity: MovieListItem.entity(), insertInto: coreDataStack.viewContext)
        newMovieListItem.apiID = Int64(apiID)
        newMovieListItem.title = title
        newMovieListItem.date = date
        newMovieListItem.posterPath = posterPath
        newMovieListItem.movieList = movieList
        coreDataStack.saveContext()
        return newMovieListItem
    }
}
