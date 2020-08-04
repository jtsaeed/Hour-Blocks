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

class ScheduleViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    let calendarGateway: CalendarGateway
    
    @Published var currentHour = Calendar.current.component(.hour, from: Date())
    @Published var currentDate = Calendar.current.startOfDay(for: Date())
    @Published var todaysHourBlocks = [HourBlockViewModel]()
    @Published var todaysCalendarBlocks = [EKEvent]()
    
    @Published var isFilterEnabled = true
    @Published var isDatePickerViewPresented = false
    
    init(dataGateway: DataGateway, calendarGateway: CalendarGateway) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        
        loadHourBlocks()
    }
    
    convenience init() {
        self.init(dataGateway: DataGateway(), calendarGateway: CalendarGateway())
    }
    
    func loadHourBlocks() {
        var hourBlockViewModels = (0 ..< 24).map { hour in
            HourBlockViewModel(for: HourBlock(day: currentDate,
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
    
    func handleCalendarPermissions() {
        calendarGateway.handlePermissions {
            DispatchQueue.main.async { self.loadHourBlocks() }
        }
    }
    
    func addBlock(_ hourBlock: HourBlock) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        dataGateway.saveHourBlock(block: hourBlock)
        
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: hourBlock)
        updateCurrentHour()
    }
    
    func clearBlock(_ hourBlock: HourBlock) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.deleteHourBlock(block: hourBlock)
        dataGateway.deleteSubBlocks(of: hourBlock)
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: HourBlock(day: hourBlock.day,
                                                                             hour: hourBlock.hour,
                                                                             title: nil))
        
        updateCurrentHour()
    }
    
    func toggleFilter() {
        HapticsGateway.shared.triggerLightImpact()
        isFilterEnabled.toggle()
        updateCurrentHour()
    }
    
    func presentDatePickerView() {
        HapticsGateway.shared.triggerLightImpact()
        isDatePickerViewPresented = true
    }
    
    func dismissDatePickerView() {
        isDatePickerViewPresented = false
        updateCurrentHour()
    }
    
    private func updateCurrentHour() {
        currentHour = Calendar.current.component(.hour, from: Date())
    }
}
