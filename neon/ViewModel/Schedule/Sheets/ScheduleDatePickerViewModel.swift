//
//  ScheduleDatePickerViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 27/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import UIKit
import EventKit

/// The view model for the ScheduleDatePickerView.
class ScheduleDatePickerViewModel: ObservableObject {
    
    private let dataGateway: DataGateway
    private let calendarGateway: CalendarGatewayProtocol
    
    @Published var selectedDate: Date
    @Published private(set) var hourBlocks = [HourBlockViewModel]()
    @Published private(set) var calendarBlocks = [EKEvent]()
    
    /// Creates an instance of the ScheduleDatePickerViewModel.
    ///
    /// - Parameters:
    ///   - dataGateway: The data gateway instance used to interface with Core Data. By default, this is set to an instance of DataGateway.
    ///   - calendarGateway: The calendar gateway instance used to interface with EventKit. By default, this is set to an instance of CalendarGateway.
    ///   - initialSelectedDate: The current date of the schedule; set as the initially selected date within the date picker.
    init(dataGateway: DataGateway = DataGateway(), calendarGateway: CalendarGatewayProtocol = CalendarGateway(), initialSelectedDate: Date) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        self.selectedDate = initialSelectedDate
    }
    
    /// Loads the selected day's hour blocks and calendar blocks.
    func loadHourBlocks() {
        hourBlocks = dataGateway.getHourBlocks(for: selectedDate)
            .sorted(by: { $0.hour < $1.hour })
            .map { HourBlockViewModel(for: $0) }
        
        calendarBlocks = calendarGateway.getEvents(for: selectedDate)
    }
}
