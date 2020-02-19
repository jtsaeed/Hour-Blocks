//
//  AddToBlockSheet.swift
//  neon3
//
//  Created by James Saeed on 01/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct AddToBlockSheet: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @Binding var isPresented: Bool
    
    let title: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.currentHourBlocks.filter { $0.hour >=  viewModel.currentHour }) { block in
                    AddToBlockCard(currentBlock: block, didAddToBlock: {
                        self.addBlock(for: block.hour)
                    }, didAddToSubBlock: {
                        self.addSubBlock(for: block.hour)
                    })
                }
            }
            .navigationBarTitle("Add to block")
            .navigationBarItems(leading: Button(action: dismissSheet, label: {
                Text("Cancel")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        let newBlock = HourBlock(day: viewModel.currentDate, hour: hour, title: title)
        viewModel.add(hourBlock: newBlock)
        
        dismissSheet()
    }
    
    func addSubBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        var newBlock = HourBlock(day: viewModel.currentDate, hour: hour, title: title)
        newBlock.isSubBlock = true
        viewModel.add(hourBlock: newBlock)
        
        dismissSheet()
    }
    
    func dismissSheet() {
        isPresented = false
    }
}

struct DuplicateBlockSheet: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @Binding var isPresented: Bool
    
    var currentBlock: HourBlock
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.currentHourBlocks.filter { $0.hour >=  viewModel.currentHour }) { block in
                    AddToBlockCard(currentBlock: block, didAddToBlock: {
                        self.addBlock(for: block.hour)
                    }, didAddToSubBlock: {
                        self.addSubBlock(for: block.hour)
                    })
                }
            }
            .navigationBarTitle("Add to block")
            .navigationBarItems(trailing: Button(action: dismissSheet, label: {
                Text("Done")
            }))
        }.accentColor(Color("primary"))
    }
    
    func addBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        var newBlock = HourBlock(day: viewModel.currentDate, hour: hour, title: currentBlock.title!)
        newBlock.iconOverride = currentBlock.iconOverride
        
        viewModel.add(hourBlock: newBlock)
    }
    
    func addSubBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        var newBlock = HourBlock(day: viewModel.currentDate, hour: hour, title: currentBlock.title!)
        newBlock.iconOverride = currentBlock.iconOverride
        newBlock.isSubBlock = true
        
        viewModel.add(hourBlock: newBlock)
    }
    
    func dismissSheet() {
        self.isPresented = false
    }
}

struct AddToBlockCard: View {
    
    let currentBlock: HourBlock
    
    var didAddToBlock: () -> ()
    var didAddToSubBlock: () -> ()
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.currentBlock.title ?? "Empty",
                           subtitle: self.currentBlock.formattedTime,
                           titleColor: self.currentBlock.title != nil ? Color("title") : Color("subtitle"))
                Spacer()
                AddToBlockAddButton(subBlock: self.currentBlock.title != nil,
                                    didAddToBlock: self.didAddToBlock,
                                    didAddToSubBlock: self.didAddToSubBlock)
            }
        }
    }
}

private struct AddToBlockAddButton: View {
    
    let subBlock: Bool
    var didAddToBlock: () -> ()
    var didAddToSubBlock: () -> ()
    
    @State var isPresented = false
    
    var body: some View {
        IconButton(iconName: "add_icon", pro: subBlock, action: add)
            .sheet(isPresented: $isPresented) {
                ProPurchaseView(showPurchasePro: self.$isPresented)
            }
    }
    
    func add() {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        if subBlock {
            if DataGateway.shared.isPro() {
                self.didAddToSubBlock()
            } else {
                isPresented = true
            }
        } else {
            self.didAddToBlock()
        }
    }
}
