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
    
    func initSubscription(_ key: String, forType type: CKQuerySubscription.Options) {
        let subscription = CKQuerySubscription(recordType: "AgendaRecord", predicate: NSPredicate(format: "TRUEPREDICATE"), options: type)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertLocalizationKey = key
        subscription.notificationInfo = notificationInfo
        
        let database = CKContainer.default().privateCloudDatabase
        database.save(subscription) { (subscription, error) in }
    }
    
    func fetchTodaysNewAgendaItems(checkAgainst agendaIds: [String], completion: @escaping (_ agendaItems: [Int: AgendaItem]) -> ()) {
        var agendaItems = [Int: AgendaItem]()
        
        let database = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            records?.forEach({ (record) in
                guard let title = record.value(forKey: "title") as? String else { return }
                guard let hour = record.value(forKey: "hour") as? Int else { return }
                guard let day = record.value(forKey: "day") as? Date else { return }
                
                // Only pull the tasks that are in today and aren't already on device
                if Calendar.current.isDateInToday(day) {
                    agendaItems[hour] = AgendaItem(title: title)
                }
            })
            
            completion(agendaItems)
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
}
