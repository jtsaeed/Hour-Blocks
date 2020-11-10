//
//  AnalyticsGateway.swift
//  neon
//
//  Created by James Saeed on 15/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Amplitude

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
        Amplitude.instance().logEvent("hour_block_added", withEventProperties: ["domain": DomainsGateway.shared.determineDomain(for: hourBlock.title!)?.rawValue ?? "Default"])
    }
    
    /// Log a newly added suggestion.
    ///
    /// - Parameters:
    ///   - hourBlock: The Suggestion to be logged.
    func log(suggestion: Suggestion) {
        Amplitude.instance().logEvent("suggestion_added", withEventProperties: ["domain": suggestion.domain.rawValue,
                                                                                "reason": suggestion.reason])
    }
    
    /// Log a newly added To Do item.
    func logToDoItem() {
        Amplitude.instance().logEvent("to_do_item_added")
    }
}
