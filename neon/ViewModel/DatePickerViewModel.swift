//
//  DatePickerViewModel.swift
//  neon
//
//  Created by James Saeed on 11/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import SwiftDate

class DatePickerViewModel: ObservableObject {
    
    @Published var browsingDate = Date()
    @Published var browsingMonth = [Date]()
    @Published var previousMonth = ""
    @Published var nextMonth = ""
    
    init() {
        loadMonth()
    }
    
    func loadMonth() {
        let increment = DateComponents.create { $0.day = 1 }
        let startOfMonth = browsingDate.dateAtStartOf(.month)
        let endOfMonth = browsingDate.dateAtEndOf(.month)
        let dates = Date.enumerateDates(from: startOfMonth, to: endOfMonth, increment: increment)
        
        browsingMonth = dates
        
        previousMonth = (browsingDate - 1.months).monthName(.default)
        nextMonth = (browsingDate + 1.months).monthName(.default)
    }
    
    func browsePreviousMonth() {
        browsingDate = browsingDate - 1.months
        loadMonth()
    }
    
    func browseNextMonth() {
        browsingDate = browsingDate + 1.months
        loadMonth()
    }
}
