//
//  CoreDataStack.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import CoreData
class CoreDataStack {
    static let cloudKitToggleStorageKey = "CloudKitToggleKey"
    static let modelName = "MoviesRecordPersistentModel"
    private var persistentContainer: NSPersistentCloudKitContainer!
    private var managedObjectModel: NSManagedObjectModel!
    
    static var shared: CoreDataStack = .init()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    private init() {
        let cloudKitSyncDefault = checkCloudKitSyncDefault()
        setupContainer(withSync: cloudKitSyncDefault)
    }
    func saveContext() {
        guard viewContext.hasChanges else {return}
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func checkCloudKitSyncDefault() -> Bool {
        if let cloudKitSyncDefault = UserDefaults.standard.object(forKey: Self.cloudKitToggleStorageKey) as? Bool {
            return cloudKitSyncDefault
        } else {
            UserDefaults.standard.set(true, forKey: Self.cloudKitToggleStorageKey)
            return true
        }
    }
    
    func setupContainer(withSync cloudKitSync: Bool) {
        let container: NSPersistentCloudKitContainer
        if let currentModel = self.managedObjectModel {
            container = .init(name: Self.modelName, managedObjectModel: currentModel)
        } else {
            container = NSPersistentCloudKitContainer(name: Self.modelName)
            self.managedObjectModel = container.managedObjectModel
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        description.setOption(true as NSNumber,
                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        
        // if "cloud_sync" boolean key isn't set or isn't set to true, don't sync to iCloud
        if(!cloudKitSync) {
            description.cloudKitContainerOptions = nil
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentContainer = container
    }
    
}

