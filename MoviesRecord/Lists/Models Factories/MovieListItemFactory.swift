//
//  MovieListItemFactory.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import CoreData
struct MovieListItemFactory {
    
    let context: NSManagedObjectContext
    
    @discardableResult
    func createMovieListItem(apiID: Int, title: String, posterPath: String?, date: Date, movieList: MovieList) -> MovieListItem {
        let newMovieListItem = MovieListItem(entity: MovieListItem.entity(), insertInto: context)
        newMovieListItem.apiID = Int64(apiID)
        newMovieListItem.title = title
        newMovieListItem.date = date
        newMovieListItem.posterPath = posterPath
        newMovieListItem.movieList = movieList
        return newMovieListItem
    }
}
