//
//  IntentHandler.swift
//  neonSiri
//
//  Created by James Saeed on 29/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Intents
import CloudKit

class IntentHandler: INExtension, AddAgendaCardIntentHandling {
    
    func handle(intent: AddAgendaCardIntent, completion: @escaping (AddAgendaCardIntentResponse) -> Void) {
        save(title: intent.title!, for: intent.hourRaw as! Int) { (success) in
            if success {
                completion(AddAgendaCardIntentResponse(code: .success, userActivity: nil))
            } else {
                completion(AddAgendaCardIntentResponse(code: .failure, userActivity: nil))
            }
        }
        
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func save(title: String, for hour: Int, completion: @escaping (_ success: Bool) -> ()) {
        let database = CKContainer(identifier: "iCloud.com.evh98.neon").privateCloudDatabase
        
        let record = CKRecord(recordType: "AgendaRecord")
        record.setObject(Date() as CKRecordValue, forKey: "day")
        record.setObject(UUID().uuidString as CKRecordValue, forKey: "id")
        record.setObject(title as CKRecordValue, forKey: "title")
        record.setObject(hour as CKRecordValue, forKey: "hour")
        
        database.save(record) { (record, error) in
            completion(error == nil)
        }
    }
}
