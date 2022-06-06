//
//  ListsViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import Foundation
import CoreData
import Combine

class ListsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private var coreDataStackContext: NSManagedObjectContext {
        return CoreDataStack.shared.viewContext
    }
    private var fetchRequestController: NSFetchedResultsController<MovieList>!
    private var anyCancellable = Set<AnyCancellable>()
    @Published var movieLists = [MovieList]()
    @Published var shouldApplyUpdates = true
    
    override init() {
        super.init()
        let fetchRequest = MovieList.fetchRequest()
        fetchRequest.sortDescriptors = [.init(keyPath: \MovieList.createDate, ascending: false)]
        self.fetchRequestController = .init(fetchRequest: fetchRequest, managedObjectContext: coreDataStackContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchRequestController.delegate = self
        try? fetchRequestController.performFetch()
        movieLists = fetchRequestController.fetchedObjects ?? []
        $shouldApplyUpdates
            .sink(receiveValue: handleShouldApplyUpdates(newValue:))
            .store(in: &anyCancellable)
    }
    
    func handleShouldApplyUpdates(newValue: Bool) {
        if newValue == true {
            refreshMovieLists()
        }
    }
    
    private func refreshMovieLists() {
        let fetchRequest = MovieList.fetchRequest()
        fetchRequest.sortDescriptors = [.init(keyPath: \MovieList.createDate, ascending: false)]
        self.fetchRequestController = .init(fetchRequest: fetchRequest, managedObjectContext: coreDataStackContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchRequestController.delegate = self
        try? fetchRequestController.performFetch()
        movieLists = fetchRequestController.fetchedObjects ?? []
    }
    
    func createNewMovieList(name: String) {
        guard name.isValidAsInput() else {return}
        let movieListFactory = MovieListFactory()
        movieListFactory.createNewMovieList(name: name)
    }
    
    func delete(_ movieList: MovieList) {
        coreDataStackContext.delete(movieList)
    }
    
    func edit(_ movieList: MovieList, editedName: String) {
        guard editedName.isValidAsInput() else { return }
        movieList.name = editedName
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard shouldApplyUpdates else {return}
        switch type {
        case .insert:
            guard let movieListToInsert = anObject as? MovieList else {return}
            movieLists.insert(movieListToInsert, at: 0)
        case .delete:
            guard let movieListToDelete = anObject as? MovieList else {return}
            movieLists.removeAll(where: {$0.objectID == movieListToDelete.objectID})
        case .move:
            print(anObject)
        case .update:
            guard let indexPath = newIndexPath else {return}
            guard let movieListToUpdate = anObject as? MovieList else {return}
            movieLists[indexPath.row] = movieListToUpdate
        @unknown default:
            break
        }
    }
    
}
