//
//  DataGateway.swift
//  neon3
//
//  Created by James Saeed on 16/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct DataGateway: DataInterface {
    
    static let shared = DataGateway(NSManagedObjectContext.current)
    
    var managedObjectContext: NSManagedObjectContext
    
    init(_ managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    let currentVersion = 5.1
}

// MARK: - Blocks

extension DataGateway {
    
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

// MARK: - User Calendars

extension DataGateway {
    
    func getUserCalendarEntities() -> [UserCalendarEntity] {
        var userCalendars = [UserCalendarEntity]()
        let request: NSFetchRequest<UserCalendarEntity> = UserCalendarEntity.fetchRequest()
        
        do {
            userCalendars = try managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return userCalendars
    }
    
    func saveUserCalendar(_ userCalendar: UserCalendar) {
        userCalendar.getEntity(context: self.managedObjectContext)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func modifyUserCalendar(userCalendar: UserCalendar) {
        let request: NSFetchRequest<UserCalendarEntity> = UserCalendarEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", userCalendar.identifier)
        
        do {
            let userCalendarEntities = try managedObjectContext.fetch(request)
            let userCalendarEntity = userCalendarEntities.first!
            
            userCalendarEntity.setValue(userCalendar.enabled, forKey: "enabled")
            
            try managedObjectContext.save()
        } catch {
            print("error")
        }
    }
}

// MARK: - Other Settings

extension DataGateway {
    
    func getOtherSettingsEntity() -> OtherSettingsEntity? {
        let request: NSFetchRequest<OtherSettingsEntity> = OtherSettingsEntity.fetchRequest()
        
        do {
            let otherSettingsEntities = try self.managedObjectContext.fetch(request)
            return otherSettingsEntities.first
        } catch {
            print("error")
            return nil
        }
    }
    
    func saveOtherSettings(_ defaultSettings: OtherSettings) {
        defaultSettings.getEntity(context: self.managedObjectContext)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("error")
        }
    }
    
    func modifyOtherSettings(set value: Any?, forKey key: String) {
        let request: NSFetchRequest<OtherSettingsEntity> = OtherSettingsEntity.fetchRequest()
        
        do {
            let otherSettingsEntities = try managedObjectContext.fetch(request)
            let otherSettingsEntity = otherSettingsEntities.first!
            
            otherSettingsEntity.setValue(value, forKey: key)
            
            try managedObjectContext.save()
        } catch {
            print("error")
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
    
    func getDayStartTime() -> Int {
        guard let otherSettingsEntity = getOtherSettingsEntity() else { return 2 }
        guard let dayStartSetting = OtherSettings(fromEntity: otherSettingsEntity)?.dayStart else { return 2 }
        
        return (dayStartSetting + 4)
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
