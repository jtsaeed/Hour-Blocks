//
//  SiriDataGateway.swift
//  NeonSiri
//
//  Created by James Saeed on 11/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

class SiriDataGateway {
    
    static let shared = SiriDataGateway()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "neon")
        let coordinator = container.persistentStoreCoordinator

        let storeURL = URL.storeURL(for: "group.com.evh98.neon", databaseName: "neon")
        
        var defaultURL: URL?
        if let storeDescription = container.persistentStoreDescriptions.first, let url = storeDescription.url {
            defaultURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
            storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.evh98.neon")
        }
        
        if defaultURL == nil {
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.evh98.neon")
            
            container.persistentStoreDescriptions = [storeDescription]
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            if let url = defaultURL, url.absoluteString != storeURL.absoluteString {
                let coordinator = container.persistentStoreCoordinator
                
                // attempt migration if necessary
                if let oldStore = coordinator.persistentStore(for: url) {
                    do {
                        try coordinator.migratePersistentStore(oldStore, to: storeURL, options: nil, withType: NSSQLiteStoreType)
                    } catch {
                        print(error.localizedDescription)
                    }

                    // delete old store
                    let fileCoordinator = NSFileCoordinator(filePresenter: nil)
                    fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: { url in
                        do {
                            try FileManager.default.removeItem(at: url)
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
            }
        })
        
        return container
    }()
    
    func save(toDoItem: ToDoItem) {
        toDoItem.getEntity(context: persistentContainer.viewContext)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("error")
        }
    }
}
