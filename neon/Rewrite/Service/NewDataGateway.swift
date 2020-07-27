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

struct NewDataGateway {
    
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

extension NewDataGateway {
    
    func saveHourBlock(block: NewHourBlock) {
        block.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func saveSubBlock(block: SubBlock) {
        block.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func saveToDoItem(toDoItem: ToDoItem) {
        toDoItem.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
}

// MARK: - Retrieve

extension NewDataGateway {
    
    func getHourBlocks(for day: Date) -> [NewHourBlock] {
        var hourBlocks = [HourBlockEntity]()
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "day == %@", Calendar.current.startOfDay(for: day) as NSDate)
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return hourBlocks.compactMap { NewHourBlock(fromEntity: $0) }
    }
    
    func getHourBlock(for hour: Int, on day: Date) -> NewHourBlock? {
        var hourBlocks = [HourBlockEntity]()
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "day == %@ && hour == %d", Calendar.current.startOfDay(for: day) as NSDate, hour)
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let firstBlock = hourBlocks.first {
            return NewHourBlock(fromEntity: firstBlock)
        } else {
            return nil
        }
    }
    
    func getSubBlocks(for hourBlock: NewHourBlock) -> [SubBlock] {
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

extension NewDataGateway {
    
    func editHourBlock(block: NewHourBlock, set value: Any?, forKey key: String) {
        let request = NSFetchRequest<HourBlockEntity>(entityName: "HourBlockEntity")
        request.predicate = NSPredicate(format: "identifier == %@", block.id)
        
        do {
            let hourBlockEntities = try managedObjectContext.fetch(request)
            let hourBlockEntity = hourBlockEntities.first!
            
            hourBlockEntity.setValue(value, forKey: key)
            
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
}

// MARK: - Delete

extension NewDataGateway {
    
    func deleteHourBlock(block: NewHourBlock) {
        let request = NSFetchRequest<SubBlockEntity>(entityName: "SubBlockEntity")
        request.predicate = NSPredicate(format: "identifier == %@", block.id)
        
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
    
    func deleteSubBlocks(of hourBlock: NewHourBlock) {
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
    
    func deleteSubBlock(block: SubBlock) {
        let request = NSFetchRequest<SubBlockEntity>(entityName: "SubBlockEntity")
        request.predicate = NSPredicate(format: "identifier == %@", block.id)
        
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
    
    func deleteToDoItem(toDoItem: ToDoItem) {
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
}

// MARK: - MISC

extension NewDataGateway {
    
}
