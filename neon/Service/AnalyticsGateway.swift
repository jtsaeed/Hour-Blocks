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
	
    func logHourBlock(for domainKey: String, at time: String, isSuggestion: String) {
        Analytics.logEvent("hourBlock3", parameters: ["domain": domainKey,
                                                      "time": time,
                                                      "suggestion": isSuggestion])
	}
    
    func log(hourBlock: HourBlock) {
        Analytics.logEvent("hourBlock5", parameters: ["domain": hourBlock.domain?.rawValue ?? "default"])
    }
    
    func logToDo() {
        Analytics.logEvent("toDo", parameters: nil)
    }
}
