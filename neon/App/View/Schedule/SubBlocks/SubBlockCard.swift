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
                CardIcon(iconName: self.currentSubBlock.iconName).padding(.leading, 8)
            }
        }.contextMenu { SubBlockCardContextMenu(currentBlock: currentSubBlock) }
        
    }
}

struct SubBlockCardContextMenu: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
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
                                currentBlock: self.currentBlock)
                    .environmentObject(self.viewModel)
            })
            Button(action: {
                self.changeIcon()
            }) {
                Text("Change Icon")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isIconPickerPresented, content: {
                IconPicker(isPresented: self.$isIconPickerPresented, currentBlock: self.currentBlock)
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
        viewModel.remove(hourBlock: currentBlock)
    }
}

struct EmptySubBlockCard: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @State var title = ""
    
    @State var isPresented = false
    
    let currentHourBlock: HourBlock
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "Sub Block",
                           subtitle: NSLocalizedString("Add a new", comment: ""),
                           titleColor: Color("subtitle"))
                Spacer()
                IconButton(iconName: "add_icon", pro: true, action: self.present)
                    .sheet(isPresented: self.$isPresented, content: {
                        if DataGateway.shared.isPro() {
                            AddHourBlockView(isPresented: self.$isPresented,
                                             hour: self.currentHourBlock.hour,
                                             time: self.currentHourBlock.formattedTime,
                                             day: self.currentHourBlock.day,
                                             isSubBlock: true)
                            .environmentObject(self.viewModel)
                        } else {
                            ProPurchaseView(showPurchasePro: self.$isPresented)
                        }
                    })
            }
        }
    }
    
    func present() {
        HapticsGateway.shared.triggerLightImpact()
        AnalyticsGateway.shared.logShowAddBlock()
        isPresented = true
    }
}
