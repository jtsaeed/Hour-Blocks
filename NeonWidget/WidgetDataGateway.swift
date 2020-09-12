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
}
