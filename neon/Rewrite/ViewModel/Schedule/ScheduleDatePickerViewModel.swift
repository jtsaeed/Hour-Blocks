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
    
    let dataGateway: NewDataGateway
    let calendarGateway: NewCalendarGateway
    
    @Published var selectedDate: Date
    @Published var hourBlocks = [HourBlockViewModel]()
    @Published var calendarBlocks = [EKEvent]()
    
    init(dataGateway: NewDataGateway, calendarGateway: NewCalendarGateway, initialSelectedDate: Date) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        self.selectedDate = initialSelectedDate
        
        loadHourBlocks()
    }
    
    convenience init(initialSelectedDate: Date) {
        self.init(dataGateway: NewDataGateway(),
                  calendarGateway: NewCalendarGateway(),
                  initialSelectedDate: initialSelectedDate)
    }
    
    func loadHourBlocks() {
        var hourBlockViewModels = (0 ..< 24).map { hour in
            HourBlockViewModel(for: NewHourBlock(day: selectedDate,
                                                 hour: hour,
                                                 title: nil))
        }
        
        for hourBlock in dataGateway.getHourBlocks(for: selectedDate) {
            hourBlockViewModels[hourBlock.hour] = HourBlockViewModel(for: hourBlock)
        }
        
        hourBlocks = hourBlockViewModels
        calendarBlocks = calendarGateway.getEvents(for: selectedDate)
    }
}
