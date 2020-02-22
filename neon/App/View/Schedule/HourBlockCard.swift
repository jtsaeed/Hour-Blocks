//
//  HourBlockCard.swift
//  neon
//
//  Created by James Saeed on 10/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct HourBlockCard: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    let hourBlock: HourBlock
    
    @State var isSubBlocksViewPresented = false
    
    var body: some View {
        Card {
            HStack {
                HourBlockCardLabels(currentBlock: self.hourBlock)
                Spacer()
                CardIcon(iconName: self.hourBlock.iconName)
                    .padding(.leading, 8)
            }
        }.onTapGesture(perform: presentSubBlocksView)
        .sheet(isPresented: $isSubBlocksViewPresented) {
            SubBlocksView(isPresented: self.$isSubBlocksViewPresented,
                          hourBlock: self.hourBlock)
                .environmentObject(self.viewModel)
        }
        .contextMenu { HourBlockCardContextMenu(currentBlock: self.hourBlock) }
    }
    
    func presentSubBlocksView() {
        if hourBlock.domain != .calendar {
            HapticsGateway.shared.triggerLightImpact()
            isSubBlocksViewPresented = true
        }
    }
}

struct EmptyHourBlockCard: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    let hourBlock: HourBlock
    
    @State var isAddBlockViewPresented = false
    
    var body: some View {
        Card {
            HStack {
                HourBlockCardLabels(currentBlock: self.hourBlock)
                Spacer()
                IconButton(iconName: "add_icon", action: self.presentAddBlockView)
            }
        }.sheet(isPresented: self.$isAddBlockViewPresented) {
            AddHourBlockView(isPresented: self.$isAddBlockViewPresented,
                             hour: self.hourBlock.hour,
                             time: self.hourBlock.formattedTime.lowercased(),
                             day: self.hourBlock.day,
                             isSubBlock: false)
                .environmentObject(self.viewModel)
        }
    }
    
    func presentAddBlockView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddBlockViewPresented = true
    }
}

private struct HourBlockCardLabels: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    var currentBlock: HourBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                if currentBlock.hasReminder {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color("primary"))
                        .opacity(colorScheme == .light ? 0.5 : 0.8)
                }
                if viewModel.currentSubBlocks.filter({ $0.hour == currentBlock.hour }).count > 0 {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color("secondary"))
                        .opacity(colorScheme == .light ? 0.5 : 0.8)
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

private struct HourBlockCardContextMenu: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @EnvironmentObject var settingsViewModel: ScheduleViewModel
    
    let currentBlock: HourBlock
    
    @State var isAddSubBlockPresented = false
    @State var isRenamePresented = false
    @State var isIconPickerPresented = false
    @State var isDuplicatePresented = false
    
    @State var isClearWarningPresented = false
    @State var clearWarningMessage = ""
    
    var body: some View {
        VStack {
            if currentBlock.domain != .calendar {
                Button(action: addSubBlock) {
                    Text("Add Sub Block")
                    Image(systemName: "plus.square")
                }
                .sheet(isPresented: self.$isAddSubBlockPresented, content: {
                    if DataGateway.shared.isPro() {
                        AddHourBlockView(isPresented: self.$isAddSubBlockPresented,
                                         hour: self.currentBlock.hour,
                                         time: self.currentBlock.formattedTime,
                                         day: self.currentBlock.day,
                                         isSubBlock: true)
                        .environmentObject(self.viewModel)
                    } else {
                        ProPurchaseView(showPurchasePro: self.$isAddSubBlockPresented)
                    }
                })
            }
            Button(action: rename) {
                Text("Rename")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isRenamePresented) {
                RenameBlockView(isPresented: self.$isRenamePresented,
                                currentBlock: self.currentBlock)
                .environmentObject(self.viewModel)
            }
            if currentBlock.domain != .calendar {
                Button(action: changeIcon) {
                    Text("Change Icon")
                    Image(systemName: "pencil")
                }
                .sheet(isPresented: $isIconPickerPresented, content: {
                    IconPicker(isPresented: self.$isIconPickerPresented,
                               currentBlock: self.currentBlock)
                        .environmentObject(self.viewModel)
                })
                Button(action: duplicate) {
                    Text("Duplicate")
                    Image(systemName: "doc.on.doc")
                }
                .sheet(isPresented: $isDuplicatePresented, content: {
                    DuplicateBlockSheet(isPresented: self.$isDuplicatePresented,
                                        currentBlock: self.currentBlock)
                        .environmentObject(self.viewModel)
                        .environmentObject(self.settingsViewModel)
                })
            }
            if (currentBlock.day == viewModel.currentDate && currentBlock.hour != viewModel.currentHour) ||
                (currentBlock.day < viewModel.currentDate){
                Button(action: reminderAction) {
                    Text(currentBlock.hasReminder ? "Remove Reminder" : "Set a Reminder")
                    Image(systemName: "alarm")
                }
            }
            Button(action: attemptClear) {
                Text("Clear")
                Image(systemName: "trash")
            }
            .alert(isPresented: $isClearWarningPresented) {
                Alert(title: Text("Clear Confirmation"),
                      message: Text(clearWarningMessage),
                      primaryButton: .destructive(Text("Confirm"), action: self.clear),
                      secondaryButton: .cancel())
            }
        }
    }
    
    func addSubBlock() {
        isAddSubBlockPresented = true
    }
    
    func rename() {
        isRenamePresented = true
    }
    
    func changeIcon() {
        isIconPickerPresented = true
    }
    
    func duplicate() {
        isDuplicatePresented = true
    }
    
    func reminderAction() {
        if currentBlock.hasReminder {
            NotificationsGateway.shared.removeNotification(for: currentBlock)
            DispatchQueue.main.async { self.viewModel.setReminder(false, for: self.currentBlock) }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            NotificationsGateway.shared.addNotification(for: currentBlock, on: viewModel.currentDate, completion: { success in
                if success {
                    DispatchQueue.main.async { self.viewModel.setReminder(true, for: self.currentBlock) }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            })
        }
    }
    
    func attemptClear() {
        if viewModel.currentSubBlocks.filter({ $0.hour == currentBlock.hour }).count > 0 {
            isClearWarningPresented = true
            clearWarningMessage = "Clearing this Hour Block will also clear any Sub Blocks it contains"
        } else if currentBlock.domain == .calendar {
            isClearWarningPresented = true
            clearWarningMessage = "Clearing this Hour Block will also delete the associated Calendar event"
        } else {
            clear()
        }
    }
    
    func clear() {
        HapticsGateway.shared.triggerClearBlockHaptic()
        viewModel.remove(hourBlock: currentBlock)
    }
}
