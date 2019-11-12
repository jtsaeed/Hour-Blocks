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
	
    func logHourBlock(for domainKey: String, at time: String, isSuggestion: Bool) {
        Analytics.logEvent("hourBlock3", parameters: ["domain": domainKey,
                                                      "time": time,
                                                      "suggestion": isSuggestion])
	}
    
    func logToDo() {
        Analytics.logEvent("toDo", parameters: nil)
    }
}
