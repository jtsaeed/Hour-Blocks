//
//  AddToBlockSheet.swift
//  neon3
//
//  Created by James Saeed on 01/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct AddToBlockSheet: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var settings: SettingsStore
    
    @Binding var isPresented: Bool
    
    let title: String
    
    var didAddToBlock: (String, Int, BlockMinute) -> ()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(blocks.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) && showQuarterBlocks(minute: $0.minute) }, id: \.self) { block in
                    AddToBlockCard(currentBlock: block, didAddToBlock: {
                        self.isPresented = false
                        self.blocks.setTodayBlock(for: block.hour, block.minute, with: self.title)
                    })
                }
            }
            .navigationBarTitle("Add to block")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func showQuarterBlocks(minute: BlockMinute) -> Bool {
        let scheduleBlocksStyle = settings.other[OtherSettingsKey.scheduleBlocksStyle.rawValue]!
        
        if scheduleBlocksStyle == 0 {
            return minute == .oclock
        } else if scheduleBlocksStyle == 1 {
            return minute == .oclock || minute == .halfPast
        } else if scheduleBlocksStyle == 2 {
            return true
        }
        
        return false
    }
}

struct DuplicateBlockSheet: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var settings: SettingsStore
    
    @Binding var isPresented: Bool
    
    let title: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(blocks.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) && showQuarterBlocks(minute: $0.minute) }, id: \.self) { block in
                    AddToBlockCard(currentBlock: block, didAddToBlock: {
                        self.blocks.setTodayBlock(for: block.hour, block.minute, with: self.title)
                    })
                }
            }
            .navigationBarTitle("Add to block")
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Done")
            }))
        }.accentColor(Color("primary"))
    }
    
    func showQuarterBlocks(minute: BlockMinute) -> Bool {
        let scheduleBlocksStyle = settings.other[OtherSettingsKey.scheduleBlocksStyle.rawValue]!
        
        if scheduleBlocksStyle == 0 {
            return minute == .oclock
        } else if scheduleBlocksStyle == 1 {
            return minute == .oclock || minute == .halfPast
        } else if scheduleBlocksStyle == 2 {
            return true
        }
        
        return false
    }
}

struct AddToBlockCard: View {
    
    let currentBlock: HourBlock
    
    var didAddToBlock: () -> ()
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: currentBlock.title ?? "Empty",
                           subtitle: currentBlock.formattedTime,
                           titleColor: currentBlock.title != nil ? Color("title") : Color("subtitle"))
                Spacer()
                if currentBlock.title != nil {
                    CardIcon(iconName: currentBlock.domain?.iconName ?? "default")
                } else {
                    AddToBlockAddButton(didAddToBlock: { self.didAddToBlock() })
                }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct AddToBlockAddButton: View {
    
    var didAddToBlock: () -> ()
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.didAddToBlock()
        }, label: {
            Image("add_button")
        })
    }
}
