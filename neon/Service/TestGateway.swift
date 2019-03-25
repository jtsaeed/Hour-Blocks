//
//  TestGateway.swift
//  neon
//
//  Created by James Saeed on 25/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import CloudKit

class TestGateway {
    
    static let shared = TestGateway()
    
    func fetchAgendaItems(completion: @escaping (_ todaysAgendaItems: [Int: AgendaItem], _ tomorrowsAgendaItems: [Int: AgendaItem]) -> ()) {
        var todaysAgendaItems = [Int: AgendaItem]()
        var tomorrowsAgendaItems = [Int: AgendaItem]()
        
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
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
            
            completion(todaysAgendaItems, tomorrowsAgendaItems)
        }
    }
    
    func save(_ agendaItem: AgendaItem, for hour: Int, today: Bool) {
        let database = CKContainer.default().privateCloudDatabase
        
        let record = CKRecord(recordType: "AgendaRecord")
        record.setObject((today ? Date() : Calendar.current.date(byAdding: .day, value: 1, to: Date())!) as CKRecordValue, forKey: "day")
        record.setObject(agendaItem.id as CKRecordValue, forKey: "id")
        record.setObject(agendaItem.title as CKRecordValue, forKey: "title")
        record.setObject(hour as CKRecordValue, forKey: "hour")
        
        database.save(record) { (record, error) in }
    }
    
    func delete(_ agendaItem: AgendaItem) {
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(format: "id == %@", agendaItem.id))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            records?.forEach({ (record) in
                database.delete(withRecordID: record.recordID, completionHandler: { (recordID, error) in })
            })
        }
    }
    
    func deletePastAgendaRecords(_ completion: @escaping () -> ()) {
        print("I'm being called!")
        
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(format: "day < %@", NSDate()))
        print("Running query for \(NSDate())")
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            print("Performing the query")
            records?.forEach({ (record) in
                print("Found something to delete")
                database.delete(withRecordID: record.recordID, completionHandler: { (recordID, error) in
                    print("Deleting")
                })
            })
        }
    }
}
