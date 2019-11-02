//
//  ScheduleCard.swift
//  neon3
//
//  Created by James Saeed on 03/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct TodayCard: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    
    @State var isRenamePresented = false
    @State var isDuplicatePresented = false
    
    let currentBlock: HourBlock
    
    var didAddBlock: (String) -> ()
    var didRemoveBlock: () -> ()
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                TodayCardLabels(currentBlock: currentBlock)
                Spacer()
                if currentBlock.title != nil {
                    CardIcon(iconName: currentBlock.domain?.iconName ?? "default")
                        .contextMenu {
                            Button(action: {
                                self.isRenamePresented.toggle()
                            }) {
                                Text("Rename")
                                Image(systemName: "pencil")
                            }
                            .sheet(isPresented: $isRenamePresented, content: {
                                NewBlockView(isPresented: self.$isRenamePresented, formattedTime: self.currentBlock.formattedTime, didAddBlock: { title in self.didAddBlock(title)
                                })
                            })
                            Button(action: {
                                self.isDuplicatePresented.toggle()
                            }) {
                                Text("Duplicate")
                                Image(systemName: "doc.on.doc")
                            }
                            .sheet(isPresented: $isDuplicatePresented, content: {
                                DuplicateBlockSheet(isPresented: self.$isDuplicatePresented, title: self.currentBlock.title!).environmentObject(self.blocks)
                            })
                            Button(action: {
                                if self.currentBlock.hasReminder {
                                    NotificationsGateway.shared.removeNotification(for: self.currentBlock)
                                    DispatchQueue.main.async {
                                        self.blocks.setReminder(false, for: self.currentBlock)
                                    }
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                } else {
                                    NotificationsGateway.shared.addNotification(for: self.currentBlock, with: 15, completion: { success in
                                        if success {
                                            DispatchQueue.main.async {
                                                self.blocks.setReminder(true, for: self.currentBlock)
                                            }
                                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                                        } else {
                                            UINotificationFeedbackGenerator().notificationOccurred(.error)
                                        }
                                    })
                                }
                                
                                print(self.currentBlock.hasReminder)
                            }) {
                                Text(currentBlock.hasReminder ? "Remove Reminder" : "Set a Reminder")
                                Image(systemName: "alarm")
                            }
                            Button(action: {
                                self.didRemoveBlock()
                            }) {
                                Text("Clear")
                                Image(systemName: "trash")
                            }
                        }
                } else {
                    TodayCardAddButton(block: currentBlock, didAddBlock: { title in
                        self.blocks.setTodayBlock(for: self.currentBlock.hour, self.currentBlock.minute, with: title)
                    })
                }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct TodayCardAddButton: View {
    
    @State var isPresented = false
    
    let block: HourBlock
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.isPresented.toggle()
        }, label: {
            Image("add_button")
        })
        .sheet(isPresented: $isPresented, content: {
            NewBlockView(isPresented: self.$isPresented, formattedTime: self.block.formattedTime, didAddBlock: { title in self.didAddBlock(title)
            })
        })
    }
}

struct TodayCardLabels: View {
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
            Text(currentBlock.formattedTime.uppercased())
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(Color("subtitle"))
            }
            Text(currentBlock.title?.smartCapitalization() ?? "Empty")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(currentBlock.title != nil ? Color("title") : Color("subtitle"))
                .lineLimit(1)
        }
    }
}
