//
//  CoreDataStack.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import CoreData
class CoreDataStack {
    private let persistentContainer = NSPersistentContainer(name: "MoviesRecordPersistentModel")
    
    static var shared: CoreDataStack = .init()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    private init() {
        persistentContainer.loadPersistentStores { [weak self] store, error in
            self?.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    func saveContext() {
        guard viewContext.hasChanges else {return}
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

