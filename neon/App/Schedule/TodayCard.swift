//
//  ScheduleCard.swift
//  neon3
//
//  Created by James Saeed on 03/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct TodayCard: View {
    
    let currentBlock: HourBlock
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                TodayCardLabels(currentBlock: currentBlock)
                Spacer()
                if currentBlock.title != nil {
                    if currentBlock.domain != DomainsGateway.shared.domains["calendar"] {
                        ZStack {
                            CardIcon(iconName: currentBlock.iconName)
                                .contextMenu { TodayCardContextMenu(currentBlock: currentBlock) }
                            NavigationLink(destination: SubBlocksView(currentHourBlock: currentBlock)) {
                                EmptyView()
                            }.frame(width: 0)
                        }
                    } else {
                        CardIcon(iconName: "calendar_item")
                    }
                } else {
                    TodayCardAddButton(block: currentBlock)
                }
            }.modifier(CardContentPadding())
        }.modifier(CardPadding())
    }
}

struct TodayCardContextMenu: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var suggestions: SuggestionsStore
    @EnvironmentObject var settings: SettingsStore
    
    @State var isRenamePresented = false
    @State var isIconPickerPresented = false
    @State var isDuplicatePresented = false
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack {
            Button(action: {
                self.rename()
            }) {
                Text("Rename")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isRenamePresented, content: {
                NewBlockView(isPresented: self.$isRenamePresented, title: self.$blocks.currentTitle, currentBlock: self.currentBlock)
                    .environmentObject(self.blocks)
                    .environmentObject(self.suggestions)
            })
            Button(action: {
                self.changeIcon()
            }) {
                Text("Change Icon")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isIconPickerPresented, content: {
                IconPicker(isPresented: self.$isIconPickerPresented, currentBlock: self.currentBlock)
                    .environmentObject(self.blocks)
            })
            Button(action: {
                self.duplicate()
            }) {
                Text("Duplicate")
                Image(systemName: "doc.on.doc")
            }
            .sheet(isPresented: $isDuplicatePresented, content: {
                DuplicateBlockSheet(isPresented: self.$isDuplicatePresented, title: self.currentBlock.title!)
                    .environmentObject(self.blocks)
                    .environmentObject(self.settings)
            })
            Button(action: {
                self.reminderAction()
            }) {
                Text(currentBlock.hasReminder ? "Remove Reminder" : "Set a Reminder")
                Image(systemName: "alarm")
            }
            Button(action: {
                self.blocks.removeTodayBlock(for: self.currentBlock.hour)
            }) {
                Text("Clear")
                Image(systemName: "trash")
            }
        }
    }
    
    func rename() {
        blocks.currentTitle = currentBlock.title!
        suggestions.load(for: currentBlock.hour)
        isRenamePresented.toggle()
    }
    
    func changeIcon() {
        isIconPickerPresented.toggle()
    }
    
    func duplicate() {
        isDuplicatePresented.toggle()
    }
    
    func reminderAction() {
        if currentBlock.hasReminder {
            NotificationsGateway.shared.removeNotification(for: currentBlock)
            DispatchQueue.main.async { self.blocks.setReminder(false, for: self.currentBlock) }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            NotificationsGateway.shared.addNotification(for: currentBlock, completion: { success in
                if success {
                    DispatchQueue.main.async { self.blocks.setReminder(true, for: self.currentBlock) }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            })
        }
    }
}

struct TodayCardAddButton: View {
    
    @EnvironmentObject var blocksStore: HourBlocksStore
    @EnvironmentObject var suggestionsStore: SuggestionsStore
    
    @State var isPresented = false
    @State var title = ""
    
    let block: HourBlock
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.suggestionsStore.load(for: self.block.hour)
            self.isPresented.toggle()
        }, label: {
            Image("add_button")
        })
        .sheet(isPresented: $isPresented, content: {
            NewBlockView(isPresented: self.$isPresented, title: self.$title, currentBlock: self.block)
                .environmentObject(self.blocksStore)
                .environmentObject(self.suggestionsStore)
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
                    .modifier(CardSubtitleLabel())
                    .foregroundColor(Color("subtitle"))
            }
            Text(currentBlock.title?.smartCapitalization() ?? "Empty")
                .modifier(CardTitleLabel())
                .foregroundColor(currentBlock.title != nil ? Color("title") : Color("subtitle"))
        }
    }
}
