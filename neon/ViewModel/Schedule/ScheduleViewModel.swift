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
import StoreKit
import SwiftDate

class ScheduleViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    let calendarGateway: CalendarGatewayProtocol
    let analyticsGateway: AnalyticsGatewayProtocol
    let remindersGateway: RemindersGatewayProtocol
    
    @AppStorage("totalBlockCount") var totalBlockCount = 0
    @AppStorage("dayStart") var dayStartValue = 0
    @AppStorage("reminders") var remindersValue: Int = 0
    
    @Published var currentDate: Date
    @Published var currentHour = Calendar.current.component(.hour, from: Date())
    @Published var todaysHourBlocks = [HourBlockViewModel]()
    @Published var todaysCalendarBlocks = [EKEvent]()
    
    @Published var currentTip: Tip?
    
    @Published var isFilterEnabled = true
    @Published var isDatePickerViewPresented = false
    
    init(dataGateway: DataGateway, calendarGateway: CalendarGatewayProtocol, analyticsGateway: AnalyticsGatewayProtocol, remindersGateway: RemindersGatewayProtocol, currentDate: Date = Date()) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        self.analyticsGateway = analyticsGateway
        self.remindersGateway = remindersGateway
        
        self.currentDate = Calendar.current.startOfDay(for: currentDate)
        
        loadHourBlocks()
    }
    
    convenience init(currentDate: Date = Date()) {
        self.init(dataGateway: DataGateway(),
                  calendarGateway: CalendarGateway(),
                  analyticsGateway: AnalyticsGateway(),
                  remindersGateway: RemindersGateway(),
                  currentDate: currentDate)
    }
    
    func loadHourBlocks() {
        var hourBlockViewModels = (0 ..< 24).map { hour in
            HourBlockViewModel(for: HourBlock(day: currentDate,
                                              hour: hour,
                                              title: nil,
                                              icon: .blocks))
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
    
    func addBlock(_ hourBlock: HourBlock, _ subBlocks: [SubBlock]? = nil) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        dataGateway.save(hourBlock: hourBlock)
        if let subBlocks = subBlocks { dataGateway.save(subBlocks: subBlocks) }
        analyticsGateway.log(hourBlock: hourBlock)
        if remindersValue == 0 { remindersGateway.setReminder(for: hourBlock, with: hourBlock.title!) }
        
        withAnimation { todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: hourBlock) }
        
        handleBlockCountEvents()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func handleBlockCountEvents() {
        totalBlockCount = totalBlockCount + 1
        if totalBlockCount == 1 { withAnimation { currentTip = .blockOptions } }
        if totalBlockCount == 5 { withAnimation { currentTip = .headerSwipe } }
        if totalBlockCount == 10 { SKStoreReviewController.requestReview() }
    }
    
    func clearBlock(_ hourBlock: HourBlock) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(hourBlock: hourBlock)
        dataGateway.deleteSubBlocks(of: hourBlock)
        remindersGateway.removeReminder(for: hourBlock)
        
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: HourBlock(day: hourBlock.day,
                                                                             hour: hourBlock.hour,
                                                                             title: nil,
                                                                             icon: .blocks))
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func rescheduleBlock(originalBlock: HourBlock, rescheduledBlock: HourBlock, replacedBlock: HourBlock, swappedBlock: HourBlock?) {
        HapticsGateway.shared.triggerLightImpact()
        
        dataGateway.delete(hourBlock: originalBlock)
        dataGateway.delete(hourBlock: replacedBlock)
        remindersGateway.removeReminder(for: originalBlock)
        remindersGateway.removeReminder(for: replacedBlock)
        
        dataGateway.save(hourBlock: rescheduledBlock)
        remindersGateway.setReminder(for: rescheduledBlock, with: rescheduledBlock.title!)
        
        if let swappedBlock = swappedBlock {
            dataGateway.save(hourBlock: swappedBlock)
            remindersGateway.setReminder(for: swappedBlock, with: swappedBlock.title!)
        }
    }
    
    func dismissTip() {
        HapticsGateway.shared.triggerLightImpact()
        withAnimation { currentTip = nil }
    }
    
    func toggleFilter() {
        HapticsGateway.shared.triggerLightImpact()
        withAnimation { isFilterEnabled.toggle() }
    }
    
    func presentDatePickerView() {
        HapticsGateway.shared.triggerLightImpact()
        isDatePickerViewPresented = true
    }
    
    func dismissDatePickerView() {
        isDatePickerViewPresented = false
    }
    
    func advanceDate() {
        HapticsGateway.shared.triggerSoftImpact()
        
        withAnimation {
            currentDate = currentDate + 1.days
            loadHourBlocks()
        }
    }
    
    func regressDate() {
        HapticsGateway.shared.triggerSoftImpact()
        
        withAnimation {
            currentDate = currentDate - 1.days
            loadHourBlocks()
        }
    }
    
    func isCurrentDayToday() -> Bool {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfCurrentDate = Calendar.current.startOfDay(for: currentDate)
        
        return startOfCurrentDate == startOfToday
    }
    
    func returnToToday() {
        HapticsGateway.shared.triggerLightImpact()
        
        withAnimation {
            currentDate = Calendar.current.startOfDay(for: Date())
            loadHourBlocks()
        }
    }
    
    func updateCurrentHour() {
        currentHour = Calendar.current.component(.hour, from: Date())
        WidgetCenter.shared.reloadAllTimelines()
    }
}
