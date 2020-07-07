//
//  HourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 26/06/2020.
//

import Foundation

class HourBlockViewModel: Identifiable, ObservableObject {
    
    private let dataGateway: NewDataGateway
    
    let hourBlock: NewHourBlock
    
    @Published var title: String
    @Published var time: String
    @Published var subBlocks: [SubBlock]
    
    @Published var isAddHourBlockViewPresented = false
    @Published var isRenameHourBlockViewPresented = false
    @Published var isDuplicateHourBlockViewPresented = false
    @Published var isIconPickerViewPresented = false
    @Published var isManageSubBlocksViewPresented = false
    
    init(for hourBlock: NewHourBlock, and subBlocks: [SubBlock], dataGateway: NewDataGateway) {
        self.dataGateway = dataGateway
        
        self.hourBlock = hourBlock
        self.title = hourBlock.title ?? "Empty"
        self.time = hourBlock.hour.get12hTime()
        self.subBlocks = subBlocks
    }
    
    convenience init(for hourBlock: NewHourBlock) {
        self.init(for: hourBlock, and: [SubBlock](), dataGateway: NewDataGateway())
    }
    
    convenience init(for hourBlock: NewHourBlock, and subBlocks: [SubBlock]) {
        self.init(for: hourBlock, and: subBlocks, dataGateway: NewDataGateway())
    }
    
    func presentAddHourBlockView() {
        isAddHourBlockViewPresented = true
    }
    
    func presentManageSubBlocksView() {
        isManageSubBlocksViewPresented = true
    }
    
    func clearBlock() {
        dataGateway.deleteHourBlock(block: hourBlock)
        dataGateway.deleteSubBlocks(of: hourBlock)
    }
    
    func addSubBlock(_ subBlock: SubBlock) {
        dataGateway.saveSubBlock(block: subBlock)
        subBlocks.append(subBlock)
    }
    
    func getIconName() -> String {
        return DomainsGateway.shared.determineDomain(for: title)?.iconName ?? "default"
    }
}