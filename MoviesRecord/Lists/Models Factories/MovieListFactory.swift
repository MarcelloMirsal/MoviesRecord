//
//  MovieListFactory.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import CoreData

struct MovieListFactory {
    let movieListEntity = MovieList.entity()
    var coreDataStack: CoreDataStack {
        return CoreDataStack.shared
    }
    
    @discardableResult
    func createNewMovieList(name: String) -> MovieList {
        let newMovieList = MovieList(entity: movieListEntity, insertInto: coreDataStack.viewContext)
        newMovieList.name = name
        newMovieList.createDate = .init()
        coreDataStack.saveContext()
        return newMovieList
    }
}
