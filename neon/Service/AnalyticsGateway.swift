//
//  AnalyticsGateway.swift
//  neon
//
//  Created by James Saeed on 15/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Firebase

protocol AnalyticsGatewayProtocol {
    
    func log(hourBlock: HourBlock)
    func log(suggestion: Suggestion)
    func logToDoItem()
}

class AnalyticsGateway: AnalyticsGatewayProtocol {
    
    func log(hourBlock: HourBlock) {
        Analytics.logEvent("hourBlock5", parameters: ["domain": DomainsGateway.shared.determineDomain(for: hourBlock.title!)?.rawValue ?? "Default"])
    }
    
    func log(suggestion: Suggestion) {
        Analytics.logEvent("suggestion", parameters: ["domain": suggestion.domain.rawValue,
                                                      "reason": suggestion.reason])
    }
    
    func logToDoItem() {
        Analytics.logEvent("toDo", parameters: nil)
    }
}
