//
//  EmptyHourBlockView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

struct EmptyHourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
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
                           action: viewModel.presentAddHourBlockView)
            }
        }.padding(.horizontal, 24)
        .sheet(isPresented: $viewModel.isAddHourBlockViewPresented) {
            AddHourBlockView(isPresented: $viewModel.isAddHourBlockViewPresented,
                             hour: viewModel.hourBlock.hour,
                             day: viewModel.hourBlock.day,
                             onAdded: { self.onNewBlockAdded($0) })
        }
    }
}
