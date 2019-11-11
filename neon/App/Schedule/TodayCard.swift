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
    @EnvironmentObject var suggestions: SuggestionsStore
    @EnvironmentObject var settings: SettingsStore
    
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
                    if currentBlock.domain != DomainsGateway.shared.domains["calendar"] {
                    CardIcon(iconName: currentBlock.domain?.iconName ?? "default")
                        .contextMenu {
                            Button(action: {
                                self.blocks.currentTitle = self.currentBlock.title!
                                self.suggestions.load(for: self.currentBlock.hour)
                                self.isRenamePresented.toggle()
                            }) {
                                Text("Rename")
                                Image(systemName: "pencil")
                            }
                            .sheet(isPresented: $isRenamePresented, content: {
                                NewBlockView(isPresented: self.$isRenamePresented, title: self.$blocks.currentTitle, formattedTime: self.currentBlock.formattedTime, didAddBlock: { title in self.didAddBlock(title)
                                }).environmentObject(self.suggestions)
                            })
                            Button(action: {
                                self.isDuplicatePresented.toggle()
                            }) {
                                Text("Duplicate")
                                Image(systemName: "doc.on.doc")
                            }
                            .sheet(isPresented: $isDuplicatePresented, content: {
                                DuplicateBlockSheet(isPresented: self.$isDuplicatePresented, title: self.currentBlock.title!).environmentObject(self.blocks).environmentObject(self.settings)
                            })
                            Button(action: {
                                if self.currentBlock.hasReminder {
                                    NotificationsGateway.shared.removeNotification(for: self.currentBlock)
                                    DispatchQueue.main.async {
                                        self.blocks.setReminder(false, for: self.currentBlock)
                                    }
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                } else {
                                    NotificationsGateway.shared.addNotification(for: self.currentBlock, with: 5, completion: { success in
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
                        CardIcon(iconName: currentBlock.domain?.iconName ?? "default")
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
    
    @EnvironmentObject var suggestions: SuggestionsStore
    
    @State var isPresented = false
    @State var title = ""
    
    let block: HourBlock
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.suggestions.load(for: self.block.hour)
            self.isPresented.toggle()
        }, label: {
            Image("add_button")
        })
        .sheet(isPresented: $isPresented, content: {
            NewBlockView(isPresented: self.$isPresented, title: self.$title, formattedTime: self.block.formattedTime, didAddBlock: { title in self.didAddBlock(title)
            }).environmentObject(self.suggestions)
        })
    }
}

struct TodayCardLabels: View {
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                if currentBlock.hasReminder {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color("primary"))
                        .opacity(0.5)
                }
                Text(currentBlock.formattedTime.uppercased())
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(Color("subtitle"))
            }
            Text(currentBlock.title?.smartCapitalization() ?? "Empty")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(currentBlock.title != nil ? Color("title") : Color("subtitle"))
                .lineLimit(1)
        }
    }
}
