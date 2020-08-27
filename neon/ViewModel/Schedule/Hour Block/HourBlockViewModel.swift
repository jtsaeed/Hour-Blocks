//
//  HourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 26/06/2020.
//

import SwiftUI
import WidgetKit

class HourBlockViewModel: Identifiable, ObservableObject {
    
    private let dataGateway: DataGateway
    private let remindersGateway: RemindersGatewayProtocol
    
    private(set) var hourBlock: HourBlock
    
    @AppStorage("reminders") var remindersValue: Int = 0
    
    @Published var title: String
    @Published var icon: SelectableIcon
    @Published var subBlocks: [SubBlock]
    
    @Published var isSheetPresented = false
    @Published var selectedSheet: HourBlockSheet?
    
    @Published var isAddHourBlockViewPresented = false
    
    @Published var isClearBlockWarningPresented = false
    @Published var isReplaceBlockWarningPresented = false
    
    init(for hourBlock: HourBlock, and subBlocks: [SubBlock], dataGateway: DataGateway, remindersGateway: RemindersGatewayProtocol) {
        self.dataGateway = dataGateway
        self.remindersGateway = remindersGateway
        
        self.hourBlock = hourBlock
        self.title = hourBlock.title ?? "Empty"
        self.icon = hourBlock.icon
        self.subBlocks = subBlocks
    }
    
    convenience init(for hourBlock: HourBlock, and subBlocks: [SubBlock]) {
        self.init(for: hourBlock, and: subBlocks, dataGateway: DataGateway(), remindersGateway: RemindersGateway())
    }
    
    convenience init(for hourBlock: HourBlock) {
        self.init(for: hourBlock, and: [SubBlock](), dataGateway: DataGateway(), remindersGateway: RemindersGateway())
    }
    
    func saveChanges(title: String, icon: SelectableIcon?) {
        HapticsGateway.shared.triggerLightImpact()
        
        self.title = title
        hourBlock.changeTitle(to: title)
        dataGateway.edit(hourBlock: hourBlock, set: title, forKey: "title")
        
        if let icon = icon {
            self.icon = icon
            hourBlock.changeIcon(to: icon)
            dataGateway.edit(hourBlock: hourBlock, set: icon.rawValue, forKey: "iconOverride")
        }
        
        if remindersValue == 0 { remindersGateway.editReminder(for: hourBlock, with: title) }
        dismissEditBlockView()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func addSubBlock(_ subBlock: SubBlock) {
        HapticsGateway.shared.triggerLightImpact()
        
        dataGateway.save(subBlock: subBlock)
        
        withAnimation { subBlocks.append(subBlock) }
    }
    
    func clearSubBlock(_ subBlock: SubBlock) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(subBlock: subBlock)
        
        withAnimation { subBlocks.removeAll { $0.id == subBlock.id } }
    }
    
    func getFormattedTime() -> String {
        let timeFormatValue = UserDefaults.standard.integer(forKey: "timeFormat")
        
        if (timeFormatValue == 0 && !UtilGateway.shared.isSystemClock12h()) || timeFormatValue == 2 {
            return hourBlock.hour.get24hTime()
        } else {
            return hourBlock.hour.get12hTime()
        }
    }
}

// MARK: - Sheets

extension HourBlockViewModel {
    
    func presentAddHourBlockView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddHourBlockViewPresented = true
    }
    
    func presentEditBlockView() {
        isSheetPresented = true
        selectedSheet = .edit
    }
    
    func dismissEditBlockView() {
        isSheetPresented = false
        selectedSheet = nil
    }
    
    func presentManageSubBlocksView() {
        isSheetPresented = true
        selectedSheet = .subBlocks
    }
    
    func presentRescheduleBlockView() {
        isSheetPresented = true
        selectedSheet = .reschedule
    }
    
    func presentDuplicateBlockView() {
        isSheetPresented = true
        selectedSheet = .duplicate
    }
    
    func presentClearBlockWarning() {
        isClearBlockWarningPresented = true
    }
    
    func presentReplaceBlockWarning() {
        isReplaceBlockWarningPresented = true
    }
}

enum HourBlockSheet {
    
    case edit, subBlocks, reschedule, duplicate
}
