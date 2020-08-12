//
//  MockAnalyticsGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 12/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

struct MockAnalyticsGateway: AnalyticsGatewayProtocol {
    
    func log(hourBlock: HourBlock) { }
    
    func log(suggestion: Suggestion) { }
    
    func logToDoItem() { }
}
