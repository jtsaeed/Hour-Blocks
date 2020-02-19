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
    
    let currentVersion = 5.0
}

// MARK: - Blocks

extension DataGateway {
    
    func getHourBlockEntities() -> [HourBlockEntity] {
        var hourBlocks = [HourBlockEntity]()
        let request: NSFetchRequest<HourBlockEntity> = HourBlockEntity.fetchRequest()
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch {
            print("error")
        }
        
        return hourBlocks
    }
    
    func getHourBlockEntities(for day: Date) -> [HourBlockEntity] {
        var hourBlocks = [HourBlockEntity]()
        let request: NSFetchRequest<HourBlockEntity> = HourBlockEntity.fetchRequest()
        request.predicate = NSPredicate(format: "day == %@", Calendar.current.startOfDay(for: day) as NSDate)
        
        do {
            hourBlocks = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return hourBlocks
    }
    
    func saveHourBlock(block: HourBlock) {
        block.getEntity(context: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func editHourBlock(block: HourBlock, set value: Any?, forKey key: String) {
        let request: NSFetchRequest<HourBlockEntity> = HourBlockEntity.fetchRequest()
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
    
    func deleteHourBlock(block: HourBlock) {
        let request: NSFetchRequest<HourBlockEntity> = HourBlockEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", block.id)
        
        do {
            let hourBlockEntities = try managedObjectContext.fetch(request)
            managedObjectContext.delete(hourBlockEntities.first!)
            
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
}

// MARK: - Suggestions

extension DataGateway {
    
    func getSuggestionEntities() -> [SuggestionEntity] {
        var suggestions = [SuggestionEntity]()
        let request: NSFetchRequest<SuggestionEntity> = SuggestionEntity.fetchRequest()
        
        do {
            suggestions = try self.managedObjectContext.fetch(request)
        } catch {
            print("error")
        }
        
        return suggestions
    }
    
    func saveSuggestion(for domainKey: String, at hour: Int) {
        let entity = SuggestionEntity(context: self.managedObjectContext)
        entity.domainKey = domainKey
        entity.hour = Int64(hour)
        entity.date = Date()
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("error")
        }
    }
}

// MARK: - To Do

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
    
    func editToDo(toDo: ToDoItem, set value: Any?, forKey key: String) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", toDo.id)
        
        do {
            let toDoEntities = try managedObjectContext.fetch(request)
            let toDoEntity = toDoEntities.first!
            
            toDoEntity.setValue(value, forKey: key)
            
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func deleteToDo(toDo: ToDoItem) {
        for entity in getToDoEntities() {
            guard let identifier = entity.identifier else {
                continue
            }
            
            if toDo.id == identifier {
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
        if let _ = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String {
            UserDefaults.standard.removeObject(forKey: "VersionOfLastRun")
            
            return true
        }
        
        guard let userVersion = UserDefaults.standard.object(forKey: "currentVersion") as? Double else {
            UserDefaults.standard.set(currentVersion, forKey: "currentVersion")
            return false
        }
        
        UserDefaults.standard.set(currentVersion, forKey: "currentVersion")
        UserDefaults.standard.synchronize()
        
        return userVersion < currentVersion
    }
    
    func isPro() -> Bool {
        guard let isPro = UserDefaults.standard.object(forKey: "isPro") as? Bool else {
            UserDefaults.standard.set(false, forKey: "isPro")
            return false
        }
        
        return isPro
    }
    
    func disablePro() {
        UserDefaults.standard.set(false, forKey: "isPro")
        UserDefaults.standard.synchronize()
    }
    
    func enablePro() {
        UserDefaults.standard.set(true, forKey: "isPro")
        UserDefaults.standard.synchronize()
    }
    
    func getTotalBlockCount() -> Int {
        guard let totalAgendaCount = UserDefaults.standard.object(forKey: "totalBlockCount") as? Int else {
            return 0
        }
        return totalAgendaCount
    }
    
    func incrementTotalBlockCount() {
        let totalAgendaCount = UserDefaults.standard.object(forKey: "totalBlockCount") as? Int
        
        if totalAgendaCount == nil {
            UserDefaults.standard.set(1, forKey: "totalBlockCount")
        } else {
            UserDefaults.standard.set(totalAgendaCount! + 1, forKey: "totalBlockCount")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func loadEnabledCalendars() -> [String: Bool] {
        if let enabledCalendars = UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool] {
            return enabledCalendars
        } else {
            var calendars = [String: Bool]()
                
            for calendar in CalendarGateway.shared.getAllCalendars() {
                calendars[calendar.calendarIdentifier] = true
            }
            
            return calendars
        }
    }
    
    func loadOtherSettings() -> [String: Int] {
        if var otherSettings = UserDefaults.standard.dictionary(forKey: "otherSettings") as? [String: Int] {
            if otherSettings[OtherSettingsKey.timeFormat.rawValue] == nil {
                otherSettings[OtherSettingsKey.timeFormat.rawValue] = 1
            }
            
            if otherSettings[OtherSettingsKey.reminderTimer.rawValue] == nil {
                otherSettings[OtherSettingsKey.reminderTimer.rawValue] = 1
            }
            
            if otherSettings[OtherSettingsKey.autoCaps.rawValue] == nil {
                otherSettings[OtherSettingsKey.autoCaps.rawValue] = 0
            }
            
            return otherSettings
        } else {
            return [
                OtherSettingsKey.timeFormat.rawValue: 1,
                OtherSettingsKey.reminderTimer.rawValue: 1,
                OtherSettingsKey.autoCaps.rawValue: 0,
            ]
        }
    }
    
    func isSystemClock12h() -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        let dateString = formatter.string(from: Date())
        let amRange = dateString.range(of: formatter.amSymbol)
        let pmRange = dateString.range(of: formatter.pmSymbol)

        return !(pmRange == nil && amRange == nil)
    }
}
