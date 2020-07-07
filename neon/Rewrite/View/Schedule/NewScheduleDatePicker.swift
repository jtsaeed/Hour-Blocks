//
//  NewScheduleDatePicker.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewScheduleDatePicker: View {
    
    @ObservedObject var viewModel: NewScheduleViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    DatePicker("Picker", selection: $viewModel.currentDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: geometry.size.width)
                        .accentColor(Color("AccentColor"))
                        .onChange(of: viewModel.currentDate) { _ in
                            viewModel.loadHourBlocks()
                        }
                }.padding(.horizontal, 24)
                .padding(.top, 24)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        if viewModel.todaysHourBlocks.count > 0 {
                            ForEach(viewModel.todaysHourBlocks.filter({ $0.title != "Empty" })) { hourBlockViewModel in
                                HourBlockView(viewModel: hourBlockViewModel,
                                              onBlockCleared: { viewModel.clearBlock(hourBlockViewModel.hourBlock) })
                            }
                        } else {
                            NoHourBlocksView()
                        }
                    }.padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }.navigationBarTitle("Date Picker", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done", action: viewModel.dismissDatePickerView))
        }.accentColor(Color("AccentColor"))
    }
}
/*
struct NewScheduleDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        NewScheduleDatePicker(isPresented: .constant(true), date: .constant(Date()))
    }
}
*/
