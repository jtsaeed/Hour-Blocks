//
//  TestGateway.swift
//  neon
//
//  Created by James Saeed on 25/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import CloudKit
import Firebase

class DataGateway {
    
    static let shared = DataGateway()
    
    func fetchAgendaItems(completion: @escaping (_ todaysAgendaItems: [Int: AgendaItem], _ tomorrowsAgendaItems: [Int: AgendaItem], _ success: Bool) -> ()) {
        var todaysAgendaItems = [Int: AgendaItem]()
        var tomorrowsAgendaItems = [Int: AgendaItem]()
        
        if CalendarGateway.shared.hasPermission() {
            for event in CalendarGateway.shared.importTodaysEvents() {
                for i in event.startTime...event.endTime {
                    var agendaItem = AgendaItem(title: event.title)
                    agendaItem.icon = "calendar"
                    todaysAgendaItems[i] = agendaItem
                }
            }
            
            for event in CalendarGateway.shared.importTomorrowsEvents() {
                for i in event.startTime...event.endTime {
                    var agendaItem = AgendaItem(title: event.title)
                    agendaItem.icon = "calendar"
                    tomorrowsAgendaItems[i] = agendaItem
                }
            }
        }
        
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if error == nil {
                records?.forEach({ (record) in
                    guard let id = record.value(forKey: "id") as? String else { return }
                    guard let title = record.value(forKey: "title") as? String else { return }
                    guard let hour = record.value(forKey: "hour") as? Int else { return }
                    guard let day = record.value(forKey: "day") as? Date else { return }
                    
                    // Only pull the tasks that are in today and aren't already on device
                    if Calendar.current.isDateInToday(day) {
                        todaysAgendaItems[hour] = AgendaItem(with: id, and: title)
                    } else if Calendar.current.isDateInTomorrow(day) {
                        tomorrowsAgendaItems[hour] = AgendaItem(with: id, and: title)
                    }
                })
                
                completion(todaysAgendaItems, tomorrowsAgendaItems, true)
            } else {
                completion(todaysAgendaItems, tomorrowsAgendaItems, false)
				print(error?.localizedDescription)
            }
        }
    }
    
    func save(_ agendaItem: AgendaItem, for hour: Int, today: Bool) {
        let database = CKContainer.default().privateCloudDatabase
        
        let record = CKRecord(recordType: "AgendaRecord")
        record.setObject((today ? Date() : Calendar.current.date(byAdding: .day, value: 1, to: Date())!) as CKRecordValue, forKey: "day")
        record.setObject(agendaItem.id as CKRecordValue, forKey: "id")
        record.setObject(agendaItem.title as CKRecordValue, forKey: "title")
        record.setObject(hour as CKRecordValue, forKey: "hour")
        
        database.save(record) { (record, error) in
            if error == nil {
				self.logHourBlock(with: agendaItem.title)
				self.incrementTotalAgendaCount()
			}
        }
    }
    
    func delete(_ agendaItem: AgendaItem) {
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            records?.forEach({ (record) in
                guard let id = record.value(forKey: "id") as? String else { return }
                if id == agendaItem.id {
                    database.delete(withRecordID: record.recordID, completionHandler: { (recordID, error) in })
                }
            })
        }
    }
    
    func deletePastAgendaRecords() {
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            records?.forEach({ (record) in
                guard let day = record.value(forKey: "day") as? Date else { return }
                
                if (!Calendar.current.isDateInToday(day) && !Calendar.current.isDateInTomorrow(day)) {
                    database.delete(withRecordID: record.recordID, completionHandler: { (recordID, error) in })
                }
            })
        }
    }
    
    func getTotalAgendaCount() -> Int {
        guard let totalAgendaCount = UserDefaults.standard.object(forKey: "totalAgendaCount") as? Int else {
            return 0
        }
        return totalAgendaCount
    }
    
    private func incrementTotalAgendaCount() {
        let totalAgendaCount = UserDefaults.standard.object(forKey: "totalAgendaCount") as? Int
        
        if totalAgendaCount == nil {
            UserDefaults.standard.set(1, forKey: "totalAgendaCount")
        } else {
            UserDefaults.standard.set(totalAgendaCount! + 1, forKey: "totalAgendaCount")
        }
        
        UserDefaults.standard.synchronize()
    }
	
	private func logHourBlock(with title: String) {
		Analytics.logEvent("hourBlock", parameters: ["title": title])
	}
}
