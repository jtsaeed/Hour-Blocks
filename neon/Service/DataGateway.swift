//
//  DataGateway.swift
//  neon3
//
//  Created by James Saeed on 16/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import CoreData

class DataGateway {
    
    static let shared = DataGateway(NSManagedObjectContext.current)
    
    var managedObjectContext: NSManagedObjectContext
    
    init(_ managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    let currentVersion = 3.07
}

// MARK: - Blocks

extension DataGateway {
    
    func getHourBlockEntities() -> [HourBlockEntity] {
        var hourBlocks = [HourBlockEntity]()
        let request: NSFetchRequest<HourBlockEntity> = HourBlockEntity.fetchRequest()
        
        do {
            hourBlocks = try self.managedObjectContext.fetch(request)
        } catch {
            print("error")
        }
        
        return hourBlocks
    }
    
    func saveHourBlock(block: HourBlock) {
        block.getEntity(context: self.managedObjectContext)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func deleteHourBlock(block: HourBlock) {
        for entity in getHourBlockEntities() {
            guard let identifier = entity.identifier else {
                continue
            }
            
            if block.identifier == identifier {
                managedObjectContext.delete(entity)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("error")
                }
                
                return
            }
        }
    }
}

// MARK: - To DO

extension DataGateway {
    
    func getToDoEntities() -> [ToDoEntity] {
        var toDos = [ToDoEntity]()
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        do {
            toDos = try self.managedObjectContext.fetch(request)
        } catch {
            print("error")
        }
        
        return toDos
    }
    
    func saveToDo(toDo: ToDoItem) {
        toDo.getEntity(context: self.managedObjectContext)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func deleteToDo(toDo: ToDoItem) {
        for entity in getToDoEntities() {
            guard let identifier = entity.identifier else {
                continue
            }
            
            if toDo.identifier == identifier {
                managedObjectContext.delete(entity)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("error")
                }
                
                return
            }
        }
    }
}

// MARK: - Misc

extension DataGateway {
    
    func isNewVersion() -> Bool {
        let userVersion = UserDefaults.standard.double(forKey: "currentVersion")
        
        UserDefaults.standard.set(currentVersion, forKey: "currentVersion")
        UserDefaults.standard.synchronize()
        
        return userVersion < currentVersion
    }
    
    func saveEnabledCalendars(_ calendars: [String: Bool]) {
        UserDefaults.standard.set(calendars, forKey: "enabledCalendars")
        UserDefaults.standard.synchronize()
    }
    
    func loadEnabledCalendars() -> [String: Bool]? {
        return UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool]
    }
}
