//
//  CloudGateway.swift
//  neon
//
//  Created by James Saeed on 17/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import CloudKit

class CloudGateway {
    
    static let shared = CloudGateway()
    
    func fetchTodaysAgendaRecords(completion: @escaping (_ agendItems: [Int: AgendaItem]) -> ()) {
        var agendaItems = [Int: AgendaItem]()
        
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            records?.forEach({ (record) in
                guard let title = record.value(forKey: "title") as? String else { return }
                guard let hour = record.value(forKey: "hour") as? Int else { return }
                guard let day = record.value(forKey: "day") as? Date else { return }
                
                // Only pull the tasks that are in today, delete any others still laying around
                // except tomorrow
                if Calendar.current.isDateInToday(day) {
                    agendaItems[hour] = AgendaItem(title: title)
                } else if Calendar.current.isDateInTomorrow(day) {
                    
                } else {
                    database.delete(withRecordID: record.recordID, completionHandler: { (record, error) in
                        
                    })
                }
            })
            
            completion(agendaItems)
        }
    }
    
    func saveAgendaRecord(_ agendaItem: AgendaItem, for hour: Int, today: Bool) {
        let database = CKContainer.default().privateCloudDatabase
        
        let record = CKRecord(recordType: "AgendaRecord")
        record.setObject(agendaItem.title as CKRecordValue, forKey: "title")
        record.setObject(hour as CKRecordValue, forKey: "hour")
        record.setObject((today ? Date() : Calendar.current.date(byAdding: .day, value: 1, to: Date())!) as CKRecordValue, forKey: "day")
        
        database.save(record) { (record, error) in
            
        }
    }
}
