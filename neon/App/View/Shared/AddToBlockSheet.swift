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
                ForEach(viewModel.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }) { block in
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
        viewModel.setTodayBlock(for: hour, with: self.title)
        
        dismissSheet()
    }
    
    func addSubBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        viewModel.addSubBlock(for: hour, with: self.title)
        
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
                ForEach(viewModel.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }) { block in
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
        
        var newBlock = HourBlock(day: Date(), hour: hour, title: currentBlock.title!)
        newBlock.iconOverride = currentBlock.iconOverride
        viewModel.setTodayBlock(newBlock)
    }
    
    func addSubBlock(for hour: Int) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        viewModel.addSubBlock(for: hour, with: currentBlock.title!)
    }
    
    func dismissSheet() {
        self.isPresented = false
    }
}

// MARK: - New Future Block View

struct NewFutureBlockView: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
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
                NeonTextField(title: $title, didReturn: { title in })
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
            viewModel.addFutureBlock(for: date, hour, with: title)
            
            self.isPresented = false
        }
    }
}

struct AddFutureBlockView: View {
    
    var didAddBlock: (Int) -> ()
    
    var body: some View {
        List {
            ForEach(fullDayBlocks()) { block in
                AddToBlockCard(currentBlock: block, didAddToBlock: {
                    self.didAddBlock(block.hour)
                }, didAddToSubBlock: {})
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
        Button(action: add, label: {
            Image(subBlock ? "pro_add_button" : "add_button")
        })
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
