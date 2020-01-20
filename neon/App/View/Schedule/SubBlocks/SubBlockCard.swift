//
//  SubBlockCard.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SubBlockCard: View {
    
    let currentHourBlock: HourBlock
    let currentSubBlock: HourBlock
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.currentSubBlock.title!,
                           subtitle: self.currentHourBlock.title!)
                Spacer()
                CardIcon(iconName: self.currentSubBlock.iconName)
            }
        }.contextMenu { SubBlockCardContextMenu(currentBlock: currentSubBlock) }
        
    }
}

struct SubBlockCardContextMenu: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    
    @State var isRenamePresented = false
    @State var isIconPickerPresented = false
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack {
            Button(action: rename) {
                Text("Rename")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isRenamePresented, content: {
                RenameBlockView(isPresented: self.$isRenamePresented,
                                currentBlock: self.currentBlock,
                                blockType: .sub)
                    .environmentObject(self.viewModel)
            })
            Button(action: {
                self.changeIcon()
            }) {
                Text("Change Icon")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isIconPickerPresented, content: {
                IconPicker(isPresented: self.$isIconPickerPresented, currentBlock: self.currentBlock, blockType: .sub)
                    .environmentObject(self.viewModel)
            })
            Button(action: clear) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
    
    func rename() {
        isRenamePresented.toggle()
    }
    
    func changeIcon() {
        isIconPickerPresented.toggle()
    }
    
    func clear() {
        HapticsGateway.shared.triggerClearBlockHaptic()
        viewModel.removeSubBlock(for: currentBlock)
    }
}

struct EmptySubBlockCard: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    
    @State var title = ""
    
    @State var isPresented = false
    
    let currentHourBlock: HourBlock
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "Sub Block",
                            subtitle: "Add a new",
                            titleColor: Color("subtitle"))
                Spacer()
                Image("pro_add_button")
                    .sheet(isPresented: self.$isPresented, content: {
                    if DataGateway.shared.isPro() {
                        NewBlockView(isPresented: self.$isPresented, currentBlock: self.currentHourBlock, isSubBlock: true)
                        .environmentObject(self.viewModel)
                        .environmentObject(self.suggestionsViewModel)
                    } else {
                        ProPurchaseView(showPurchasePro: self.$isPresented)
                    }
                    
                })
            }
        }.onTapGesture(perform: present)
    }
    
    func present() {
        HapticsGateway.shared.triggerLightImpact()
        isPresented = true
    }
}
