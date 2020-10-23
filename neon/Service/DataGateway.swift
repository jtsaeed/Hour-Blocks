//
//  NewDataGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftDate

/// The gateway service used to interface with Core Data.
struct DataGateway {
    
    let managedObjectContext: NSManagedObjectContext
    
    /// Creates an instance of the DataGateway with the managed object context from the AppDelegate.
    init() {
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.managedObjectContext.automaticallyMergesChangesFromParent = true
    }
    
    /// Creates an instance of the DataGateway.
    ///
    /// - Parameters:
    ///   - managedObjectContext: The managed object context to be used.
    init(for managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}

// MARK: - Create Operations

extension DataGateway {
    
    /// Saves a given Hour Block to the Core Data store.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be saved.
    func save(hourBlock: HourBlock) {
        hourBlock.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Saves a given Sub Block to the Core Data store.
    ///
    /// - Parameters:
    ///   - subBlock: The Sub Block to be saved.
    func save(subBlock: SubBlock) {
        subBlock.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Saves a given array of Sub Blocks to the Core Data store.
    ///
    /// - Parameters:
    ///   - subBlocks: The array of Sub Blocks to be saved.
    func save(subBlocks: [SubBlock]) {
        for subBlock in subBlocks {
            subBlock.getEntity(context: managedObjectContext)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Saves a given To Do item to the Core Data store.
    ///
    /// - Parameters:
    ///   - hourBlock: The To Do item to be saved.
    func save(toDoItem: ToDoItem) {
        toDoItem.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Retrieve Operations

extension DataGateway {
    
    /// Retrieves all Hour Blocks for a given day from the Core Data store.
    ///
    /// - Parameters:
    ///   - day: The day to match when querying Hour Blocks from the Core Data store.
    ///
    /// - Returns:
    /// An array of saved Hour Blocks.
    func getHourBlocks(for day: Date) -> [HourBlock] {
        var hourBlocks = [HourBlockEntity]()
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "day == %@", Calendar.current.startOfDay(for: day) as NSDate)
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return hourBlocks.compactMap { HourBlock(fromEntity: $0) }
    }
    
    /// Retrieves all Hour Blocks within a month prior for a given day and matching a given hour from the Core Data store.
    /// This function is purely used to determine frequently added Hour Blocks to generate suggestions within the SuggestionsGateway.
    ///
    /// - Parameters:
    ///   - day: The day from which the previous month's Hour Blocks are to be queried from the Core Data store.
    ///   - hour: The hour to match when querying Hour Blocks from the Core Data store.
    ///
    /// - Returns:
    /// An array of saved Hour Blocks.
    func getLastMonthsHourBlocks(from day: Date, for hour: Int) -> [HourBlock] {
        var hourBlocks = [HourBlockEntity]()
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        let startOfDateRange = Calendar.current.startOfDay(for: day - 28.days) as NSDate
        let endOfDateRange = Calendar.current.startOfDay(for: day) as NSDate
        request.predicate = NSPredicate(format: "(day >= %@) AND (day <= %@) AND (hour == %d)", startOfDateRange, endOfDateRange, hour)
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return hourBlocks.compactMap({ HourBlock(fromEntity: $0) })
    }
    
    /// Retrieves all Sub Blocks corresponding to a given Hour Block from the Core Data store.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to match when querying Sub Blocks from the Core Data store.
    ///
    /// - Returns:
    /// An array of saved Sub Blocks.
    func getSubBlocks(for hourBlock: HourBlock) -> [SubBlock] {
        var subBlocks = [SubBlockEntity]()
        
        let request = NSFetchRequest<SubBlockEntity>(entityName: "SubBlockEntity")
        request.predicate = NSPredicate(format: "hourBlockIdentifier == %@", hourBlock.id)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            subBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return subBlocks.compactMap { SubBlock(fromEntity: $0) }
    }
    
    /// Retrieves all incomplete To Do items from the Core Data store.
    ///
    /// - Returns:
    /// An array of incomplete To Do items.
    func getIncompleteToDoItems() -> [ToDoItem] {
        var toDoEntities = [ToDoEntity]()
        
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        request.predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
        
        do {
            toDoEntities = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return toDoEntities.compactMap { ToDoItem(fromEntity: $0) }
    }
    
    /// Retrieves all completed To Do items from the Core Data store.
    ///
    /// - Returns:
    /// An array of completed To Do items.
    func getCompletedToDoItems() -> [ToDoItem] {
        var toDoEntities = [ToDoEntity]()
        
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        request.predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
        
        do {
            toDoEntities = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return toDoEntities.compactMap { ToDoItem(fromEntity: $0) }
    }
}

// MARK: - Update Operations

extension DataGateway {
    
    /// Updates a given property for a given Hour Block within the Core Data store.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be updated.
    ///   - value: The new value to be set.
    ///   - key: The key of the property to be updated.
    func edit(hourBlock: HourBlock, set value: Any?, forKey key: String) {
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "identifier == %@", hourBlock.id)
        
        do {
            let hourBlockEntities = try managedObjectContext.fetch(request)
            
            if let hourBlockEntity = hourBlockEntities.first {
                hourBlockEntity.setValue(value, forKey: key)
            }
            
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Updates a given property for a given To Do item within the Core Data store.
    ///
    /// - Parameters:
    ///   - toDoItem: The To Do item to be updated.
    ///   - value: The new value to be set.
    ///   - key: The key of the property to be updated.
    func edit(toDoItem: ToDoItem, set value: Any?, forKey key: String) {
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        request.predicate = NSPredicate(format: "identifier == %@", toDoItem.id)
        
        do {
            let toDoEntities = try managedObjectContext.fetch(request)
            
            if let toDoEntity = toDoEntities.first{
                toDoEntity.setValue(value, forKey: key)
            }
            
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Delete Operations

extension DataGateway {
    
    /// Deletes a given Hour Block from the Core Data store.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be deleted.
    func delete(hourBlock: HourBlock) {
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "identifier == %@", hourBlock.id)
        
        do {
            let hourBlockEntities = try managedObjectContext.fetch(request)
            
            if let hourBlock = hourBlockEntities.first {
                managedObjectContext.delete(hourBlock)
            }
            
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Deletes all Sub Blocks corresponding to a given Hour Block from the Core Data store.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to match when querying Sub Blocks from the Core Data store.
    func deleteSubBlocks(of hourBlock: HourBlock) {
        let request = NSFetchRequest<SubBlockEntity>(entityName: "SubBlockEntity")
        request.predicate = NSPredicate(format: "hourBlockIdentifier == %@", hourBlock.id)
        
        do {
            let subBlockEntities = try managedObjectContext.fetch(request)
            
            for subBlockEntity in subBlockEntities {
                managedObjectContext.delete(subBlockEntity)
            }
            
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Deletes a given Sub Block from the Core Data store.
    ///
    /// - Parameters:
    ///   - subBlock: The Sub Block to be deleted.
    func delete(subBlock: SubBlock) {
        let request = NSFetchRequest<SubBlockEntity>(entityName: "SubBlockEntity")
        request.predicate = NSPredicate(format: "identifier == %@", subBlock.id)
        
        do {
            let subBlockEntities = try managedObjectContext.fetch(request)
            
            if let subBlock = subBlockEntities.first {
                managedObjectContext.delete(subBlock)
            }
            
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Deletes a given To Do item from the Core Data store.
    ///
    /// - Parameters:
    ///   - toDoItem: The To Do item to be deleted.
    func delete(toDoItem: ToDoItem) {
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        request.predicate = NSPredicate(format: "identifier == %@", toDoItem.id)
        
        do {
            let toDoEntities = try managedObjectContext.fetch(request)
            
            if let toDoEntity = toDoEntities.first {
                managedObjectContext.delete(toDoEntity)
            }
            
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
