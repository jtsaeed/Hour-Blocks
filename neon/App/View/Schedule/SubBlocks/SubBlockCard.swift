//
//  SubBlockCard.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SubBlockCard: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @State var offset: CGFloat = 0
    @State var isSwiped = false
    
    @State var isSheetPresented = false
    @State var activeSheet = 0
    
    let currentHourBlock: HourBlock
    let currentSubBlock: HourBlock
    
    var body: some View {
        SwipeableSubBlockCard(offset: $offset, swiped: $isSwiped, hourBlock: currentHourBlock, subBlock: currentSubBlock) {
            HStack(spacing: 28) {
                SwipeOption(iconName: "paintbrush",
                            primaryColor: Color("primary"),
                            secondaryColor: Color("primaryLight"),
                            action: self.changeIcon)
                SwipeOption(iconName: "pencil",
                            primaryColor: Color("primary"),
                            secondaryColor: Color("primaryLight"),
                            weight: .bold,
                            action: self.rename)
                SwipeOption(iconName: "trash",
                            primaryColor: Color("urgent"),
                            secondaryColor: Color("urgentLight"),
                            action: self.clear)
            }
        }.contextMenu {
            if !isSwiped {
                Button(action: rename) {
                    Text("Rename")
                    Image(systemName: "pencil")
                }
                Button(action: changeIcon) {
                    Text("Change Icon")
                    Image(systemName: "pencil")
                }
                Button(action: clear) {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
        }
        .sheet(isPresented: $isSheetPresented, content: {
            if self.activeSheet == 0 {
                RenameBlockView(isPresented: self.$isSheetPresented,
                                currentBlock: self.currentSubBlock)
                    .environmentObject(self.viewModel)
            } else if self.activeSheet == 1 {
                IconPicker(isPresented: self.$isSheetPresented,
                           currentBlock: self.currentSubBlock)
                    .environmentObject(self.viewModel)
            }
        })
    }
    
    func rename() {
        HapticsGateway.shared.triggerLightImpact()
        isSheetPresented = true
        activeSheet = 0
        unSwipe()
    }
    
    func changeIcon() {
        HapticsGateway.shared.triggerLightImpact()
        isSheetPresented = true
        activeSheet = 1
        unSwipe()
    }
    
    func clear() {
        HapticsGateway.shared.triggerClearBlockHaptic()
        viewModel.remove(hourBlock: currentSubBlock)
    }
    
    func unSwipe() {
        isSwiped = false
        offset = 0
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
                IconButton(iconName: "add_icon", action: self.present)
                    .sheet(isPresented: self.$isPresented, content: {
                        AddHourBlockView(isPresented: self.$isPresented,
                                         hour: self.currentHourBlock.hour,
                                         time: self.currentHourBlock.formattedTime,
                                         day: self.currentHourBlock.day,
                                         isSubBlock: true)
                        .environmentObject(self.viewModel)
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
