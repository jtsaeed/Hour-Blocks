//
//  EKEvent+Ext.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import EventKit

extension EKEvent {
    
    func startsAt(hour: Int) -> Bool {
        return self.startDate.hour == hour
    }
}
