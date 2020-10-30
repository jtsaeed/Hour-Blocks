//
//  AnalyticsGateway.swift
//  neon
//
//  Created by James Saeed on 15/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Firebase
import Mixpanel

protocol AnalyticsGatewayProtocol {
    
    func log(hourBlock: HourBlock)
    func log(suggestion: Suggestion)
    func logToDoItem()
}

/// The analytics gateway service used to interface with Firebase Analytics.
struct AnalyticsGateway: AnalyticsGatewayProtocol {
    
    /// Log a newly added Hour Block.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be logged.
    func log(hourBlock: HourBlock) {
        Analytics.logEvent("hourBlock5", parameters: ["domain": DomainsGateway.shared.determineDomain(for: hourBlock.title!)?.rawValue ?? "Default"])
        
        Mixpanel.mainInstance().track(event: "hour_block_added", properties: ["domain": DomainsGateway.shared.determineDomain(for: hourBlock.title!)?.rawValue ?? "Default"])
    }
    
    /// Log a newly added suggestion.
    ///
    /// - Parameters:
    ///   - hourBlock: The Suggestion to be logged.
    func log(suggestion: Suggestion) {
        Analytics.logEvent("suggestion", parameters: ["domain": suggestion.domain.rawValue,
                                                      "reason": suggestion.reason])
        
        Mixpanel.mainInstance().track(event: "suggestion_added",
                                      properties: ["domain": suggestion.domain.rawValue,
                                                   "reason": suggestion.reason])
    }
    
    /// Log a newly added To Do item.
    func logToDoItem() {
        Analytics.logEvent("toDo", parameters: nil)
        
        Mixpanel.mainInstance().track(event: "to_do_item_added")
    }
}
