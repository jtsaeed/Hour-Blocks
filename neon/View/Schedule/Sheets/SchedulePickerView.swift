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
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(viewModel.todaysHourBlocks) { hourBlockViewModel in
                        if hourBlockViewModel.title != "Empty" {
                            CompactHourBlockView(viewModel: hourBlockViewModel)
                        } else {
                            EmptyHourBlockView(viewModel: hourBlockViewModel,
                                               onNewBlockAdded: { viewModel.addBlock($0) })
                        }
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }.navigationTitle(title)
            .navigationBarItems(leading: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    func dismiss() {
        isPresented = false
    }
}

struct SchedulePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePickerView()
    }
}
