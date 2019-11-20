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
    
    var didAddToBlock: (String, Int) -> ()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(blocks.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }, id: \.self) { block in
                    AddToBlockCard(currentBlock: block, didAddToBlock: {
                        self.isPresented = false
                        self.blocks.setTodayBlock(for: block.hour, with: self.title)
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
                        self.blocks.setTodayBlock(for: block.hour, with: self.title)
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
}

// MARK: - New Future Block View

struct NewFutureBlockView: View {
    
    @Binding var isPresented: Bool
    
    @State var title = ""
    @State var date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    var didAddBlock: (String, Int, Date) -> ()
    
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
                NavigationLink(destination: AddFutureBlockView(title: title, date: date, didAddBlock: { title, hour, date in
                    self.didAddBlock(title, hour, date)
                    self.isPresented = false
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
    
    func fullDayBlocks() -> [HourBlock] {
        var blocks = [HourBlock]()
        
        for i in 0...23 {
            blocks.append(HourBlock(day: Date(), hour: i, title: nil))
        }
        
        return blocks
    }
}

struct AddFutureBlockView: View {
    
    let title: String
    let date: Date
    
    var didAddBlock: (String, Int, Date) -> ()
    
    var body: some View {
        List {
            ForEach(fullDayBlocks(), id: \.self) { block in
                AddToBlockCard(currentBlock: block, didAddToBlock: {
                    if self.title.isEmpty {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                    } else {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        AudioGateway.shared.playSFX(.addBlock)
                        self.didAddBlock(self.title, block.hour, self.date)
                    }
                })
            }
        }
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
