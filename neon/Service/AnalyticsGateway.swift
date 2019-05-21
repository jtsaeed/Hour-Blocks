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
	}
	
	func logFeedback(with text: String) {
		Analytics.logEvent("feedback", parameters: ["feedback": text])
	}
}
