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
        Card {
            HStack {
                TodayCardLabels(currentBlock: self.currentBlock)
                Spacer()
                if self.currentBlock.title != nil {
                    if self.currentBlock.domain != DomainsGateway.shared.domains["calendar"] {
                        ZStack {
                            CardIcon(iconName: self.currentBlock.iconName)
                                .contextMenu { TodayCardContextMenu(currentBlock: self.currentBlock) }
                            
                            NavigationLink(destination: SubBlocksView(currentHourBlock: self.currentBlock)) {
                                EmptyView()
                            }.frame(width: 0)
                            
                        }
                    } else {
                        CardIcon(iconName: "calendar_item")
                    }
                } else {
                    TodayCardAddButton(block: self.currentBlock)
                }
            }
        }
    }
}

struct TodayCardContextMenu: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @EnvironmentObject var settings: SettingsStore
    
    @State var isRenamePresented = false
    @State var isIconPickerPresented = false
    @State var isDuplicatePresented = false
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack {
            Button(action: rename) {
                Text("Rename")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isRenamePresented, content: {
                NewBlockView(isPresented: self.$isRenamePresented, title: self.$viewModel.currentTitle, currentBlock: self.currentBlock)
                    .environmentObject(self.viewModel)
                    .environmentObject(self.suggestionsViewModel)
            })
            Button(action: changeIcon) {
                Text("Change Icon")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isIconPickerPresented, content: {
                IconPicker(isPresented: self.$isIconPickerPresented, currentBlock: self.currentBlock)
                    .environmentObject(self.viewModel)
            })
            Button(action: duplicate) {
                Text("Duplicate")
                Image(systemName: "doc.on.doc")
            }
            .sheet(isPresented: $isDuplicatePresented, content: {
                DuplicateBlockSheet(isPresented: self.$isDuplicatePresented, title: self.currentBlock.title!)
                    .environmentObject(self.viewModel)
                    .environmentObject(self.settings)
            })
            Button(action: reminderAction) {
                Text(currentBlock.hasReminder ? "Remove Reminder" : "Set a Reminder")
                Image(systemName: "alarm")
            }
            Button(action: clear) {
                Text("Clear")
                Image(systemName: "trash")
            }
        }
    }
    
    func rename() {
        viewModel.currentTitle = currentBlock.title!
        suggestionsViewModel.load(for: currentBlock.hour)
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
            DispatchQueue.main.async { self.viewModel.setReminder(false, for: self.currentBlock) }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            NotificationsGateway.shared.addNotification(for: currentBlock, completion: { success in
                if success {
                    DispatchQueue.main.async { self.viewModel.setReminder(true, for: self.currentBlock) }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            })
        }
    }
    
    func clear() {
        viewModel.removeTodayBlock(for: currentBlock.hour)
    }
}

struct TodayCardAddButton: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    
    @State var isPresented = false
    @State var title = ""
    
    let block: HourBlock
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.suggestionsViewModel.load(for: self.block.hour)
            self.isPresented.toggle()
        }, label: {
            Image("add_button")
        })
        .sheet(isPresented: $isPresented, content: {
            NewBlockView(isPresented: self.$isPresented, title: self.$title, currentBlock: self.block)
                .environmentObject(self.viewModel)
                .environmentObject(self.suggestionsViewModel)
        })
    }
}

struct TodayCardLabels: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
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
                if (viewModel.subBlocks[currentBlock.hour]?.count ?? 0) > 0 {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color("secondary"))
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
