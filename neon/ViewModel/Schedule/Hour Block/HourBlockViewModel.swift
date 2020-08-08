//
//  HourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 26/06/2020.
//

import Foundation

class HourBlockViewModel: Identifiable, ObservableObject {
    
    private let dataGateway: DataGateway
    
    let hourBlock: HourBlock
    
    @Published var title: String
    @Published var subBlocks: [SubBlock]
    
    @Published var isAddHourBlockViewPresented = false
    @Published var isEditHourBlockViewPresented = false
    @Published var isDuplicateHourBlockViewPresented = false
    @Published var isManageSubBlocksViewPresented = false
    
    init(for hourBlock: HourBlock, and subBlocks: [SubBlock], dataGateway: DataGateway) {
        self.dataGateway = dataGateway
        
        self.hourBlock = hourBlock
        self.title = hourBlock.title ?? "Empty"
        self.subBlocks = subBlocks
    }
    
    convenience init(for hourBlock: HourBlock) {
        self.init(for: hourBlock, and: [SubBlock](), dataGateway: DataGateway())
    }
    
    convenience init(for hourBlock: HourBlock, and subBlocks: [SubBlock]) {
        self.init(for: hourBlock, and: subBlocks, dataGateway: DataGateway())
    }
    
    func presentAddHourBlockView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddHourBlockViewPresented = true
    }
    
    func presentEditBlockView() {
        isEditHourBlockViewPresented = true
    }
    
    func dismissEditBlockView() {
        isEditHourBlockViewPresented = false
    }
    
    func saveChanges(title: String) {
        HapticsGateway.shared.triggerLightImpact()
        
        self.title = title
        dataGateway.edit(hourBlock: hourBlock, set: title, forKey: "title")
        
        dismissEditBlockView()
    }
    
    func presentManageSubBlocksView() {
        isManageSubBlocksViewPresented = true
    }
    
    func addSubBlock(_ subBlock: SubBlock) {
        HapticsGateway.shared.triggerLightImpact()
        
        dataGateway.save(subBlock: subBlock)
        
        subBlocks.append(subBlock)
    }
    
    func clearSubBlock(_ subBlock: SubBlock) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(subBlock: subBlock)
        
        subBlocks.removeAll { $0.id == subBlock.id }
    }
    
    func getFormattedTime() -> String {
        let timeFormatValue = UserDefaults.standard.integer(forKey: "timeFormat")
        
        if (timeFormatValue == 0 && !UtilGateway.shared.isSystemClock12h()) || timeFormatValue == 2 {
            return hourBlock.hour.get24hTime()
        } else {
            return hourBlock.hour.get12hTime()
        }
    }
    
    func getIconName() -> String {
        return DomainsGateway.shared.determineDomain(for: title)?.iconName ?? "default"
    }
}
