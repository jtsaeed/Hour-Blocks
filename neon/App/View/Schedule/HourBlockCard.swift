//
//  HourBlockCard.swift
//  neon
//
//  Created by James Saeed on 10/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct HourBlockCard: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    let hourBlock: HourBlock
    
    @State var isAddBlockViewPresented = false
    @State var isSubBlockViewPresented = false
    
    var body: some View {
        Card {
            HStack {
                HourBlockCardLabels(currentBlock: self.hourBlock)
                Spacer()
                if self.hourBlock.title != nil {
                    ZStack {
                        CardIcon(iconName: self.hourBlock.iconName)
                            .contextMenu { HourBlockCardContextMenu(viewModel: self.viewModel, currentBlock: self.hourBlock) }
                            .sheet(isPresented: self.$isSubBlockViewPresented) {
                                SubBlocksView(viewModel: self.viewModel, hourBlock: self.hourBlock)
                            }
                    }.padding(.leading, 8)
                } else {
                    IconButton(iconName: "add_icon", action: self.presentAddBlockView)
                        .sheet(isPresented: self.$isAddBlockViewPresented) {
                            NewAddHourBlockView(isPresented: self.$isAddBlockViewPresented,
                                                viewModel: self.viewModel,
                                                hour: self.hourBlock.hour,
                                                time: self.hourBlock.formattedTime.lowercased())
                        }
                }
            }
        }
    }
    
    func presentAddBlockView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddBlockViewPresented = true
    }
}

struct HourBlockCardLabels: View {
    
    var currentBlock: HourBlock
    
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

struct HourBlockCardContextMenu: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack {
            Button(action: clear) {
                Text("Clear")
                Image(systemName: "trash")
            }
        }
    }
    
    func clear() {
        HapticsGateway.shared.triggerClearBlockHaptic()
        viewModel.remove(hourBlock: currentBlock)
    }
}

struct NewAddHourBlockView: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    let hour: Int
    let time: String
    
    @State var title = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title, didReturn: addBlock)
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                Spacer()
            }
            .navigationBarTitle(time)
            .navigationBarItems(leading: Button(action: dismiss, label: {
                Text("Cancel")
            }), trailing: Button(action: addBlock, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
    }
    
    func dismiss() {
        isPresented = false
    }
    
    func addBlock() {
        if self.title.isEmpty {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            
            let hourBlock = HourBlock(day: viewModel.currentDate,
                                      hour: hour,
                                      title: title)
            viewModel.add(hourBlock: hourBlock)
            
            dismiss()
        }
    }
}
