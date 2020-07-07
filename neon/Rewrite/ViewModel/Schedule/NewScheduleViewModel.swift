//
//  NewScheduleViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class NewScheduleViewModel: ObservableObject {
    
    let dataGateway: NewDataGateway
    let calendarGateway: NewCalendarGateway
    
    @Published var currentHour = Calendar.current.component(.hour, from: Date())
    @Published var currentDate = Calendar.current.startOfDay(for: Date())
    @Published var todaysHourBlocks = [HourBlockViewModel]()
    @Published var todaysCalendarBlocks = [EKEvent]()
    
    @Published var isFilterEnabled = true
    @Published var isDatePickerViewPresented = false
    
    init(dataGateway: NewDataGateway, calendarGateway: NewCalendarGateway) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        
        loadHourBlocks()
    }
    
    convenience init() {
        self.init(dataGateway: NewDataGateway(), calendarGateway: NewCalendarGateway())
    }
    
    func loadHourBlocks() {
        var hourBlockViewModels = (0 ..< 24).map { hour in
            HourBlockViewModel(for: NewHourBlock(day: currentDate,
                                                 hour: hour,
                                                 title: nil))
        }
        
        for hourBlock in dataGateway.getHourBlocks(for: currentDate) {
            let subBlocks = dataGateway.getSubBlocks(for: hourBlock)
            hourBlockViewModels[hourBlock.hour] = HourBlockViewModel(for: hourBlock, and: subBlocks)
        }
        
        todaysHourBlocks = hourBlockViewModels
        todaysCalendarBlocks = calendarGateway.getEvents(for: currentDate)
    }
    
    func addBlock(_ hourBlock: NewHourBlock) {
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: hourBlock)
    }
    
    func refreshBlock(_ hourBlockViewModel: HourBlockViewModel) {
        todaysHourBlocks[hourBlockViewModel.hourBlock.hour] = hourBlockViewModel
    }
    
    func clearBlock(_ hourBlock: NewHourBlock) {
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: NewHourBlock(day: hourBlock.day,
                                                                                hour: hourBlock.hour,
                                                                                title: nil))
    }
    
    func toggleFilter() {
        isFilterEnabled.toggle()
    }
    
    func presentDatePickerView() {
        isDatePickerViewPresented = true
    }
    
    func dismissDatePickerView() {
        isDatePickerViewPresented = false
    }
}
