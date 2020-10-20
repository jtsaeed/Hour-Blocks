//
//  NewScheduleViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import EventKit
import WidgetKit
import StoreKit
import SwiftDate

/// The view model for the ScheduleView; governs most of the core Hour Blocks functionality.
class ScheduleViewModel: ObservableObject {
    
    private let dataGateway: DataGateway
    private let calendarGateway: CalendarGatewayProtocol
    private let analyticsGateway: AnalyticsGatewayProtocol
    private let remindersGateway: RemindersGatewayProtocol
    
    /// A UserDefaults property of the total count of Hour Blocks the user has added.
    @AppStorage("totalBlockCount") private var totalBlockCount = 0
    /// A UserDefaults property determining whether or not a reminder should be set with the creation of an Hour Block.
    @AppStorage("reminders") private var remindersValue: Int = 0
    /// A UserDefaults property determining what time the schedule starts.
    @AppStorage("dayStart") private var dayStartValue = 0
    
    @Published var currentDate: Date
    @Published private(set) var currentHour = Calendar.current.component(.hour, from: Date())
    @Published private(set) var todaysHourBlocks = [HourBlockViewModel]()
    @Published private(set) var todaysCalendarBlocks = [EKEvent]()
    @Published private(set) var currentTip: Tip?
    
    @Published var isDatePickerViewPresented = false
    
    /// Creates an instance of the ScheduleViewModel and then loads the Hour Blocks for that day.
    ///
    /// - Parameters:
    ///   - dataGateway: The data gateway instance used to interface with Core Data. By default, this is set to an instance of DataGateway.
    ///   - calendarGateway: The calendar gateway instance used to interface with EventKit. By default, this is set to an instance of CalendarGateway.
    ///   - analyticsGateway: The analytics gateway instance used to interface with Firebase Analytics. By default, this is set to an instance of AnalyticsGateway.
    ///   - remindersGateway: The reminders gateway instance used to interface with UNUserNotificationCenter. By default, this is set to an instance of RemindersGateway.
    ///   - currentDate: The date to be used for the schedule. By default, this is set to today's date.
    init(dataGateway: DataGateway = DataGateway(), calendarGateway: CalendarGatewayProtocol = CalendarGateway(), analyticsGateway: AnalyticsGatewayProtocol = AnalyticsGateway(), remindersGateway: RemindersGatewayProtocol = RemindersGateway(), currentDate: Date = Date()) {
        self.dataGateway = dataGateway
        self.calendarGateway = calendarGateway
        self.analyticsGateway = analyticsGateway
        self.remindersGateway = remindersGateway
        
        self.currentDate = currentDate
        
        loadHourBlocks()
    }
}

// MARK: - Hour Block Operations

extension ScheduleViewModel {
    
    /// Loads the current day's hour blocks and calendar blocks.
    func loadHourBlocks() {
        // Create empty hour block view models for all 24 hours in the day
        var hourBlockViewModels = (0 ..< 24).map { hour in
            HourBlockViewModel(for: HourBlock(day: currentDate,
                                              hour: hour,
                                              title: nil,
                                              icon: .blocks))
        }
        
        // Replace empty hour block view models with any hour blocks loaded from Core Data
        for hourBlock in dataGateway.getHourBlocks(for: currentDate) {
            let subBlocks = dataGateway.getSubBlocks(for: hourBlock)
            hourBlockViewModels[hourBlock.hour] = HourBlockViewModel(for: hourBlock, and: subBlocks)
        }
        
        todaysHourBlocks = hourBlockViewModels
        todaysCalendarBlocks = calendarGateway.getEvents(for: currentDate)
    }
    
    /// Adds a given Hour Block to the Core Data store and the Schedule view.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be added.
    ///   - subBlocks: The array of corresponding Sub Blocks to be added as part of the Hour Block. By default, this is set to nil.
    func addBlock(_ hourBlock: HourBlock, _ subBlocks: [SubBlock]? = nil) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        dataGateway.save(hourBlock: hourBlock)
        if let subBlocks = subBlocks { dataGateway.save(subBlocks: subBlocks) }
        withAnimation { todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: hourBlock) }
        
        if remindersValue == 0 { remindersGateway.setReminder(for: hourBlock, with: hourBlock.title!) }
        
        analyticsGateway.log(hourBlock: hourBlock)
        handleBlockCountEvents()
        WidgetCenter.shared.reloadTimelines(ofKind: "ScheduleWidget")
    }
    
    
    /// Removes a given Hour Block from the Core Data store and the Schedule view.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be added.
    ///   - subBlocks: The array of corresponding Sub Blocks to be added as part of the Hour Block. By default, this is set to nil.
    func clearBlock(_ hourBlock: HourBlock) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(hourBlock: hourBlock)
        dataGateway.deleteSubBlocks(of: hourBlock)
        remindersGateway.removeReminder(for: hourBlock)
        
        todaysHourBlocks[hourBlock.hour] = HourBlockViewModel(for: HourBlock(day: hourBlock.day,
                                                                             hour: hourBlock.hour,
                                                                             title: nil,
                                                                             icon: .blocks))
        
        WidgetCenter.shared.reloadTimelines(ofKind: "ScheduleWidget")
    }
    
    /// Reschedules a given Hour Block within the Core Data store and the Schedule view.
    ///
    /// - Parameters:
    ///   - originalBlock: The original Hour Block that is set to be rescheduled.
    ///   - rescheduledBlock: The newly rescheduled Hour Block.
    ///   - replacedBlock: The Hour Block to be replaced, which may be empty.
    ///   - swappedBlock: The Hour Block being swapped, if there is one.
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
        
        WidgetCenter.shared.reloadTimelines(ofKind: "ScheduleWidget")
    }
}

// MARK: - Date Picker Functionality

extension ScheduleViewModel {
    
    /// Presents the ScheduleDatePickerView.
    func presentDatePickerView() {
        HapticsGateway.shared.triggerLightImpact()
        isDatePickerViewPresented = true
    }
    
    /// Advances the schedule's current day by 1 then reloads the Hour Blocks for the new date.
    func advanceCurentDay() {
        HapticsGateway.shared.triggerSoftImpact()
        
        withAnimation {
            currentDate = currentDate + 1.days
            loadHourBlocks()
        }
    }
    
    /// Regresses the schedule's current day by 1 then reloads the Hour Blocks for the new date.
    func regressCurrentDay() {
        HapticsGateway.shared.triggerSoftImpact()
        
        withAnimation {
            currentDate = currentDate - 1.days
            loadHourBlocks()
        }
    }
    
    /// Sets the schedule's current day to today then reloads the Hour Blocks for the new date.
    func returnToToday() {
        HapticsGateway.shared.triggerLightImpact()
        
        withAnimation {
            currentDate = Date()
            loadHourBlocks()
        }
    }
}

// MARK: - Miscellaneous Functionality

extension ScheduleViewModel {
    
    /// Requests permission to access user calendars, then reloads hour blocks if permission is granted
    func handleCalendarPermissions() {
        calendarGateway.handlePermissions { granted in
            if granted {
                DispatchQueue.main.async { self.loadHourBlocks() }
            }
        }
    }
    
    /// Sets the current tip to be nil, resulting in the current tip card being dismissed from the schedule.
    func dismissTip() {
        HapticsGateway.shared.triggerLightImpact()
        setCurrentTip(as: nil)
    }
    
    /// Refreshes the current date and hour, then reloads the Hour Blocks for the schedule.
    func refreshCurrentDate() {
        currentDate = Date()
        currentHour = Calendar.current.component(.hour, from: Date())
        
        loadHourBlocks()
        WidgetCenter.shared.reloadTimelines(ofKind: "ScheduleWidget")
    }
}

// MARK: - Private Functionality

extension ScheduleViewModel {
    
    /// Increases the total count of Hour Blocks added by 1, then performs any block count related events.
    private func handleBlockCountEvents() {
        totalBlockCount = totalBlockCount + 1
        
        switch totalBlockCount {
        case 1: setCurrentTip(as: .blockOptions)
        case 5: setCurrentTip(as: .headerSwipe)
        case 10: SKStoreReviewController.requestReview()
        default: break
        }
    }
    
    
    /// Sets the current tip to a given tip.
    ///
    /// - Parameters:
    ///   - tip: The tip to be set as the current tip.
    private func setCurrentTip(as tip: Tip?) {
        withAnimation { currentTip = tip }
    }
}
