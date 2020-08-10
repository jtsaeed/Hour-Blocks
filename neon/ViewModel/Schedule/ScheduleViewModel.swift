//
//  NewScheduleViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import CoreData
import EventKit
import WidgetKit

class ScheduleViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    let calendarGateway: CalendarGateway
    let analyticsGateway: AnalyticsGateway
    let remindersGateway: RemindersGateway
    
    @Published var currentHour = Calendar.current.component(.hour, from: Date())
    @Published var currentDate = Calendar.current.startOfDay(for: Date())
    @Published var todaysHourBlocks = [HourBlockViewModel]()
    @Published var todaysCalendarBlocks = [EKEvent]()
    
    @Published var isFilterEnabled = true
    @Published var isDatePickerViewPresented = false
    
    init(dataGateway: DataGateway, calendarGateway: CalendarGateway, analyticsGateway: AnalyticsGateway, remindersGateway: RemindersGateway) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        self.analyticsGateway = analyticsGateway
        self.remindersGateway = remindersGateway
        
        loadHourBlocks()
    }
    
    convenience init() {
        self.init(dataGateway: DataGateway(),
                  calendarGateway: CalendarGateway(),
                  analyticsGateway: AnalyticsGateway(),
                  remindersGateway: RemindersGateway())
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
        
        dataGateway.save(hourBlock: hourBlock)
        remindersGateway.setReminder(for: hourBlock)
        analyticsGateway.log(hourBlock: hourBlock)
        
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: hourBlock)
        updateCurrentHour()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func clearBlock(_ hourBlock: HourBlock) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(hourBlock: hourBlock)
        dataGateway.deleteSubBlocks(of: hourBlock)
        remindersGateway.removeReminder(for: hourBlock)
        
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: HourBlock(day: hourBlock.day,
                                                                             hour: hourBlock.hour,
                                                                             title: nil))
        updateCurrentHour()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func toggleFilter() {
        HapticsGateway.shared.triggerLightImpact()
        withAnimation { isFilterEnabled.toggle() }
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
