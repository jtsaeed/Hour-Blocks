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

struct DataGateway {
    
    let managedObjectContext: NSManagedObjectContext
    
    init() {
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.managedObjectContext.automaticallyMergesChangesFromParent = true
    }
    
    init(for managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}

// MARK: - Create

extension DataGateway {
    
    func save(hourBlock: HourBlock) {
        hourBlock.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func save(subBlock: SubBlock) {
        subBlock.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func save(toDoItem: ToDoItem) {
        toDoItem.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
}

// MARK: - Retrieve

extension DataGateway {
    
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
    
    func getHourBlock(for hour: Int, on day: Date) -> HourBlock? {
        var hourBlocks = [HourBlockEntity]()
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "day == %@ && hour == %d", Calendar.current.startOfDay(for: day) as NSDate, hour)
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let firstBlock = hourBlocks.first {
            return HourBlock(fromEntity: firstBlock)
        } else {
            return nil
        }
    }
    
    func getLastMonthsHourBlocks(from day: Date, for hour: Int) -> [HourBlock] {
        var hourBlocks = [HourBlockEntity]()
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        let startOfDateRange = Calendar.current.startOfDay(for: day - 30.days) as NSDate
        let endOfDateRange = Calendar.current.startOfDay(for: day) as NSDate
        request.predicate = NSPredicate(format: "(day >= %@) AND (day <= %@) AND (hour == %d)", startOfDateRange, endOfDateRange, hour)
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return hourBlocks.compactMap({ HourBlock(fromEntity: $0) })
    }
    
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
    
    func getToDoItems() -> [ToDoItem] {
        var toDoEntities = [ToDoEntity]()
        
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        
        do {
            toDoEntities = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return toDoEntities.compactMap { ToDoItem(fromEntity: $0) }
    }
}

// MARK: - Update

extension DataGateway {
    
    func edit(hourBlock: HourBlock, set value: Any?, forKey key: String) {
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "identifier == %@", hourBlock.id)
        
        do {
            let hourBlockEntities = try managedObjectContext.fetch(request)
            let hourBlockEntity = hourBlockEntities.first!
            
            hourBlockEntity.setValue(value, forKey: key)
            
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
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
            print("error")
        }
    }
}

// MARK: - Delete

extension DataGateway {
    
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
            print("error")
        }
    }
    
    func deleteAllHourBlocks() {
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        
        do {
            let hourBlockEntities = try managedObjectContext.fetch(request)
            
            for hourBlockEntity in hourBlockEntities {
                managedObjectContext.delete(hourBlockEntity)
                deleteSubBlocks(of: HourBlock(fromEntity: hourBlockEntity)!)
            }
            
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
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
            print("error")
        }
    }
    
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
            print("error")
        }
    }
    
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
            print("error")
        }
    }
    
    func deleteAllToDoItems() {
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        
        do {
            let toDoEntities = try managedObjectContext.fetch(request)
            
            for toDoEntity in toDoEntities {
                managedObjectContext.delete(toDoEntity)
            }
            
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
}
