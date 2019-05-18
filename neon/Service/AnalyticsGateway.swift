//
//  AnalyticsGateway.swift
//  neon
//
//  Created by James Saeed on 15/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Firebase
import CloudKit

class AnalyticsGateway {
	
	static let shared = AnalyticsGateway()
	
	func logHourBlock(for title: String) {
		Analytics.logEvent("hourBlock", parameters: ["title": title])
		
		let database = CKContainer.default().publicCloudDatabase
		let record = CKRecord(recordType: "AgendaAnalytic")
		record.setObject(title as CKRecordValue, forKey: "title")
		database.save(record) { (record, error) in }
	}
	
	func logFeedback(with text: String) {
		Analytics.logEvent("feedback", parameters: ["feedback": text])
		
		let database = CKContainer.default().publicCloudDatabase
		let record = CKRecord(recordType: "FeedbackAnalytic")
		record.setObject(text as CKRecordValue, forKey: "feedback")
		database.save(record) { (record, error) in }
	}
}
