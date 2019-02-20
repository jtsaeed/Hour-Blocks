//
//  DataGateway.swift
//  neon
//
//  Created by James Saeed on 14/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import CoreData

class DataGateway {
    
    static let shared = DataGateway()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "neon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension DataGateway {
    
    /// Returns the agenda items for today
    public func loadTodaysAgendaItems() -> [Int: AgendaItem] {
        var agendaItems = [Int: AgendaItem]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AgendaEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                guard let day = data.value(forKey: "day") as? Date else { return agendaItems }
                guard let hour = data.value(forKey: "hour") as? Int else { return agendaItems }
                guard let title = data.value(forKey: "title") as? String else { return agendaItems }
                
                // Only pull the tasks that are in today, delete any others still laying around
                if Calendar.current.isDateInToday(day) {
                    agendaItems[hour] = AgendaItem(title: title)
                } else {
                    persistentContainer.viewContext.delete(data)
                }
            }
        } catch {
            print("Failed loading")
        }
        
        return agendaItems
    }
    
    /// Saves a given task if it doesn't already exist
    public func saveAgendaItem(_ agendaItem: AgendaItem, for hour: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "AgendaEntity", in: persistentContainer.viewContext)
        let newAgendaItem = NSManagedObject(entity: entity!, insertInto: persistentContainer.viewContext)
        
        newAgendaItem.setValue(Date(), forKey: "day")
        newAgendaItem.setValue(hour, forKey: "hour")
        newAgendaItem.setValue(agendaItem.icon, forKey: "icon")
        newAgendaItem.setValue(agendaItem.title, forKey: "title")
        
        saveContext()
    }
}
