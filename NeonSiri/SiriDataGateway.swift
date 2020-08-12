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
        let storeURL = URL.storeURL(for: "group.com.evh98.neon", databaseName: "neon")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
