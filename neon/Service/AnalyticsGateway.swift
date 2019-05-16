//
//  AnalyticsGateway.swift
//  neon
//
//  Created by James Saeed on 15/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsGateway {
	
	static let shared = AnalyticsGateway()
	
	func logNewHourBlock(for title: String, and icon: String) {
		Analytics.logEvent("newHourBlock", parameters: ["title": title, "icon": icon])
	}
	
	func logCloudError(for error: String) {
		Analytics.logEvent("cloudError", parameters: ["error": error])
	}
	
	func logFeedback(with text: String) {
		Analytics.logEvent("feedback", parameters: ["feedback": text])
	}
}
