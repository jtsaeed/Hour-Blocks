//
//  FutureCard.swift
//  neon3
//
//  Created by James Saeed on 03/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct FutureCard: View {
    
    let currentBlock: HourBlock
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.currentBlock.title!,
                           subtitle: self.currentBlock.day.getFormattedDate())
                Spacer()
                if self.currentBlock.domain != DomainsGateway.shared.domains["calendar"] {
                    CardIcon(iconName: self.currentBlock.domain?.iconName ?? "default")
                        .contextMenu { FutureCardContextMenu(currentBlock: self.currentBlock) }
                } else {
                    CardIcon(iconName: "calendar_item")
                }
            }
        }
    }
}

struct FutureCardContextMenu: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
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
        viewModel.removeFutureBlock(for: currentBlock)
    }
}

struct EmptyFutureCard: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @State var title = ""
    
    @State var isPresented = false
    
    var body: some View {
        EmptyListCard()
            .onTapGesture(perform: present)
            .sheet(isPresented: $isPresented, content: {
                NewFutureBlockView(isPresented: self.$isPresented)
                    .environmentObject(self.viewModel)
            })
    }
    
    func present() {
        HapticsGateway.shared.triggerLightImpact()
        isPresented.toggle()
    }
}
