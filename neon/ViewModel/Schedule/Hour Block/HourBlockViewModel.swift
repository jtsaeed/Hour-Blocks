//
//  HourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 26/06/2020.
//

import SwiftUI
import WidgetKit

/// The view model for the HourBlockView.
class HourBlockViewModel: Identifiable, ObservableObject {
    
    private let dataGateway: DataGateway
    private let remindersGateway: RemindersGatewayProtocol
    
    private(set) var hourBlock: HourBlock
    
    /// A UserDefaults property determining whether or not a reminder should be set with the creation of an Hour Block.
    @AppStorage("reminders") private var remindersValue: Int = 0
    /// A UserDefaults property determining what hour format to use when displaying times.
    @AppStorage("timeFormat") private var timeFormatValue: Int = 1
    /// A UserDefaults property determining whether or not to automatically capitalize Hour Blocks and To Do items.
    @AppStorage("autoCaps") private var autoCapsValue: Int = 0
    
    @Published var icon: SelectableIcon
    @Published var subBlocks: [SubBlock]
    
    @Published var isSheetPresented = false
    @Published private(set) var selectedSheet: HourBlockSheet?
    
    @Published var isAddHourBlockViewPresented = false
    @Published var isClearBlockWarningPresented = false
    @Published var isReplaceBlockWarningPresented = false
    
    /// Creates an instance of the HourBlockViewModel.
    ///
    /// - Parameters:
    ///   - hourBlock: The corresponding Hour Block for the view model.
    ///   - subBlocks: The array of corresponding Sub Blocks for the view model. By default, this is set to an empty array.
    ///   - dataGateway: The data gateway instance used to interface with Core Data. By default, this is set to an instance of DataGateway.
    ///   - remindersGateway: The reminders gateway instance used to interface with UNUserNotificationCenter. By default, this is set to an instance of RemindersGateway.
    init(for hourBlock: HourBlock, and subBlocks: [SubBlock] = [SubBlock](), dataGateway: DataGateway = DataGateway(), remindersGateway: RemindersGatewayProtocol = RemindersGateway()) {
        self.dataGateway = dataGateway
        self.remindersGateway = remindersGateway
        self.hourBlock = hourBlock
        self.icon = hourBlock.icon
        self.subBlocks = subBlocks
    }
    
    /// Determines whether or not to format the time as 12h or 24h, based on user preferences.
    ///
    /// - Returns:
    /// The formatted time of the corresponding view model's Hour Block.
    func getFormattedTime() -> String {
        if (timeFormatValue == 0 && !UtilGateway.shared.isSystemClock12h()) || timeFormatValue == 2 {
            return hourBlock.hour.get24hTime()
        } else {
            return hourBlock.hour.get12hTime()
        }
    }
    
    /// Applies capitalisation to the Hour Blocks title if need be, based on user preferences.
    ///
    /// - Returns:
    /// The formatted title of the view model's Hour Block.
    func getTitle() -> String {
        guard let title = hourBlock.title else { return "Empty" }
        
        return autoCapsValue == 0 ? title.smartCapitalization() : title
    }
}

// MARK: - Functionality

extension HourBlockViewModel {
    
    /// Saves any title and icon changes to the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    ///   - newIcon: The new icon to be updated.
    func saveChanges(newTitle: String, newIcon: SelectableIcon?) {
        HapticsGateway.shared.triggerLightImpact()
        
        hourBlock.changeTitle(to: newTitle)
        dataGateway.edit(hourBlock: hourBlock, set: newTitle, forKey: "title")
        
        if let newIcon = newIcon {
            icon = newIcon
            hourBlock.changeIcon(to: newIcon)
            dataGateway.edit(hourBlock: hourBlock, set: icon.rawValue, forKey: "iconOverride")
        }
        
        if remindersValue == 0 { remindersGateway.editReminder(for: hourBlock, with: newTitle) }
        dismissEditBlockView()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Adds a given Sub Block to the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - subBlock: The new Sub Block to be added.
    func addSubBlock(_ subBlock: SubBlock) {
        HapticsGateway.shared.triggerLightImpact()
        
        dataGateway.save(subBlock: subBlock)
        withAnimation { subBlocks.append(subBlock) }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Removes a given new Sub Block from the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - subBlock: The new Sub Block to be added.
    func clearSubBlock(_ subBlock: SubBlock) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(subBlock: subBlock)
        withAnimation { subBlocks.removeAll { $0.id == subBlock.id } }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: - Sheets

extension HourBlockViewModel {
    
    /// Presents the AddHourBlockView.
    func presentAddHourBlockView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddHourBlockViewPresented = true
    }
    
    /// Presents the EditHourBlockView.
    func presentEditBlockView() {
        isSheetPresented = true
        selectedSheet = .edit
    }
    
    /// Dismisses the EditHourBlockView.
    func dismissEditBlockView() {
        isSheetPresented = false
        selectedSheet = nil
    }
    
    /// Presents the ManageSubBlocksView.
    func presentManageSubBlocksView() {
        isSheetPresented = true
        selectedSheet = .subBlocks
    }
    
    /// Dismisses the ManageSubBlocksView.
    func dismissManageSubBlocksView() {
        isSheetPresented = false
        selectedSheet = nil
    }
    
    /// Presents the RescheduleBlockView.
    func presentRescheduleBlockView() {
        isSheetPresented = true
        selectedSheet = .reschedule
    }
    
    /// Presents the SchedulePickerView.
    func presentDuplicateBlockView() {
        isSheetPresented = true
        selectedSheet = .duplicate
    }
    
    /// Presents a warning alert for clearing the view model's corresponding Hour Block.
    func presentClearBlockWarning() {
        isClearBlockWarningPresented = true
    }
    
    /// Presents a warning alert for replacing the view model's corresponding Hour Block.
    func presentReplaceBlockWarning() {
        isReplaceBlockWarningPresented = true
    }
}

enum HourBlockSheet {
    
    case edit, subBlocks, reschedule, duplicate
}
