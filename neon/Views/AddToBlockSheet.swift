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
    
    @Binding var isPresented: Bool
    
    let title: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(blocks.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }, id: \.self) { block in
                    AddToBlockCard(currentBlock: block, didAddToBlock: {
                        self.addBlock(for: block.hour)
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
    
    func addBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        blocks.setTodayBlock(for: hour, with: self.title)
        
        isPresented = false
    }
}

struct DuplicateBlockSheet: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    
    @Binding var isPresented: Bool
    
    let title: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(blocks.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }, id: \.self) { block in
                    AddToBlockCard(currentBlock: block, didAddToBlock: {
                        self.addBlock(for: block.hour)
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
    
    func addBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        blocks.setTodayBlock(for: hour, with: self.title)
    }
}

// MARK: - New Future Block View

struct NewFutureBlockView: View {
    
    @EnvironmentObject var store: HourBlocksStore
    
    @Binding var isPresented: Bool
    
    @State var title = ""
    @State var date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let max = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        return min...max
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                NewTextField(title: $title, didReturn: { title in })
                DatePicker("Choose a date", selection: $date, in: dateClosedRange, displayedComponents: .date)
                    .labelsHidden()
                NavigationLink(destination: AddFutureBlockView(didAddBlock: { hour in
                    self.addFutureBlock(at: hour)
                }), label: {
                    ActionButton(title: "Choose an hour").padding(32)
                })
                Spacer()
            }
            .navigationBarTitle("What's in the future?")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addFutureBlock(at hour: Int) {
        if self.title.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            store.addFutureBlock(for: date, hour, with: title)
            
            self.isPresented = false
        }
    }
}

struct AddFutureBlockView: View {
    
    var didAddBlock: (Int) -> ()
    
    var body: some View {
        List {
            ForEach(fullDayBlocks(), id: \.self) { block in
                AddToBlockCard(currentBlock: block, didAddToBlock: {
                    self.didAddBlock(block.hour)
                })
            }
        }.navigationBarTitle("Choose an hour")
    }
    
    func fullDayBlocks() -> [HourBlock] {
        var blocks = [HourBlock]()
        
        for i in 0...23 {
            blocks.append(HourBlock(day: Date(), hour: i, title: nil))
        }
        
        return blocks
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
            }.modifier(CardContentPadding())
        }.modifier(CardPadding())
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
