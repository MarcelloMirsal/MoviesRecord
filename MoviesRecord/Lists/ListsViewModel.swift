//
//  ListsViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import Foundation

class ListsViewModel: ObservableObject {
    private let coreDataStackContext = CoreDataStack.shared.viewContext
    
    func createNewMovieList(name: String) {
        guard name.isValidAsInput() else {return}
        let movieListFactory = MovieListFactory(context: coreDataStackContext)
        movieListFactory.createNewMovieList(name: name)
    }
    
    func delete(_ movieList: MovieList) {
        coreDataStackContext.delete(movieList)
    }
    
    func edit(_ movieList: MovieList, editedName: String) {
        guard editedName.isValidAsInput() else { return }
        movieList.name = editedName
        coreDataStackContext.refresh(movieList, mergeChanges: true)
    }
}
