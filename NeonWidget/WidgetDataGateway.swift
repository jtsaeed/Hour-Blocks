//
//  WidgetDataGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 09/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

class WidgetDataGateway {
    
    static let shared = WidgetDataGateway()
    
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
    
    func getHourBlocks(for day: Date) -> [HourBlock] {
        var hourBlocks = [HourBlockEntity]()
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "day == %@", Calendar.current.startOfDay(for: day) as NSDate)
        
        do {
            hourBlocks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return hourBlocks.compactMap { HourBlock(fromEntity: $0) }
    }
    
    func getSubBlocks(for hourBlock: HourBlock) -> [SubBlock] {
        var subBlocks = [SubBlockEntity]()
        
        let request = NSFetchRequest<SubBlockEntity>(entityName: "SubBlockEntity")
        request.predicate = NSPredicate(format: "hourBlockIdentifier == %@", hourBlock.id)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            subBlocks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return subBlocks.compactMap { SubBlock(fromEntity: $0) }
    }
    
    func getToDoItems() -> [ToDoItem] {
        var toDoItems = [ToDoEntity]()
        
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        request.predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
        
        do {
            toDoItems = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return toDoItems.compactMap { ToDoItem(fromEntity: $0) }
    }
}
