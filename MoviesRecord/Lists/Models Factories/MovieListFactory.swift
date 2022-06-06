//
//  MovieListFactory.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import CoreData

struct MovieListFactory {
    let movieListEntity = MovieList.entity()
    let context: NSManagedObjectContext = CoreDataStack.shared.viewContext
    
    @discardableResult
    func createNewMovieList(name: String) -> MovieList {
        let newMovieList = MovieList(entity: movieListEntity, insertInto: context)
        newMovieList.name = name
        newMovieList.createDate = .init()
        return newMovieList
    }
}
