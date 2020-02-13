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
    
    var body: some View {
        Card {
            HStack {
                HourBlockCardLabels(currentBlock: self.hourBlock)
                Spacer()
                if self.hourBlock.title != nil {
                    ZStack {
                        CardIcon(iconName: self.hourBlock.iconName)
                            .contextMenu { HourBlockCardContextMenu(viewModel: self.viewModel, currentBlock: self.hourBlock) }
                        
                        NavigationLink(destination: SubBlocksView(viewModel: self.viewModel, hourBlock: self.hourBlock)) {
                            EmptyView()
                        }.frame(width: 0)
                    }.padding(.leading, 8)
                } else {
                    IconButton(iconName: "add_icon", action: self.presentAddBlockView)
                }
            }
        }.sheet(isPresented: self.$isAddBlockViewPresented) {
            AddHourBlockView(isPresented: self.$isAddBlockViewPresented,
                             viewModel: self.viewModel,
                             hour: self.hourBlock.hour,
                             time: self.hourBlock.formattedTime.lowercased(),
                             day: self.hourBlock.day)
        }
    }
    
    func presentAddBlockView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddBlockViewPresented = true
    }
}

private struct HourBlockCardLabels: View {
    
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

private struct HourBlockCardContextMenu: View {
    
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
