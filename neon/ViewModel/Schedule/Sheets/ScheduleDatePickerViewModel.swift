//
//  ScheduleDatePickerViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 27/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import EventKit

class ScheduleDatePickerViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    let calendarGateway: CalendarGatewayProtocol
    
    @Published var selectedDate: Date
    @Published var hourBlocks = [HourBlockViewModel]()
    @Published var calendarBlocks = [EKEvent]()
    
    init(dataGateway: DataGateway, calendarGateway: CalendarGatewayProtocol, initialSelectedDate: Date) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        self.selectedDate = initialSelectedDate
    }
    
    convenience init(initialSelectedDate: Date) {
        self.init(dataGateway: DataGateway(),
                  calendarGateway: CalendarGateway(),
                  initialSelectedDate: initialSelectedDate)
        
        loadHourBlocks()
    }
    
    func loadHourBlocks() {
        hourBlocks = dataGateway.getHourBlocks(for: selectedDate)
            .sorted(by: { $0.hour < $1.hour })
            .map { HourBlockViewModel(for: $0) }
        
        calendarBlocks = calendarGateway.getEvents(for: selectedDate)
    }
}
