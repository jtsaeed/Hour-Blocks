//
//  SchedulePickerSheet.swift
//  Hour Blocks
//
//  Created by James Saeed on 09/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct SchedulePickerView: View {
    
    @StateObject var viewModel = ScheduleViewModel()
    
    @Binding var isPresented: Bool
    
    let title: String
    let hourBlock: HourBlock
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(viewModel.todaysHourBlocks) { hourBlockViewModel in
                        if hourBlockViewModel.title != "Empty" {
                            CompactHourBlockView(viewModel: hourBlockViewModel)
                        } else {
                            PickerEmptyBlockView(viewModel: hourBlockViewModel,
                                                 hourBlock: hourBlock,
                                                 onNewBlockAdded: { self.add(hourBlock: $0) })
                        }
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }.navigationTitle(title)
            .navigationBarItems(trailing: Button("Save", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    func add(hourBlock: HourBlock) {
        viewModel.addBlock(hourBlock)
    }
    
    func dismiss() {
        NotificationCenter.default.post(name: Notification.Name("RefreshSchedule"), object: nil)
        isPresented = false
    }
}

private struct PickerEmptyBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    let hourBlock: HourBlock
    let onNewBlockAdded: (HourBlock) -> Void
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "Empty",
                           subtitle: viewModel.getFormattedTime(),
                           titleOpacity: 0.4)
                Spacer()
                IconButton(iconName: "plus",
                           iconWeight: .bold,
                           action: addNewHourBlock)
            }
        }.padding(.horizontal, 24)
    }
    
    func addNewHourBlock() {
        let newHourBlock = HourBlock(day: viewModel.hourBlock.day,
                                     hour: viewModel.hourBlock.hour,
                                     title: hourBlock.title,
                                     iconOverride: hourBlock.iconOverride)
        
        onNewBlockAdded(newHourBlock)
    }
}

struct SchedulePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePickerView(isPresented: .constant(true),
                           title: "Picker",
                           hourBlock: HourBlock(day: Date(), hour: 17, title: "Dinner"))
    }
}
