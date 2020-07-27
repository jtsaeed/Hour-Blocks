//
//  EmptyHourBlockView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

struct EmptyHourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    let onNewBlockAdded: (NewHourBlock) -> Void
    
    var body: some View {
        NewCard {
            HStack {
                NewCardLabels(title: "Empty",
                           subtitle: viewModel.time,
                           titleOpacity: 0.4)
                Spacer()
                NewIconButton(iconName: "plus",
                           iconWeight: .bold,
                           action: viewModel.presentAddHourBlockView)
            }
        }.padding(.horizontal, 24)
        .padding(.vertical, 6)
        .sheet(isPresented: $viewModel.isAddHourBlockViewPresented) {
            NewAddHourBlockView(isPresented: $viewModel.isAddHourBlockViewPresented,
                             hour: viewModel.hourBlock.hour,
                             day: viewModel.hourBlock.day,
                             onAdded: { self.onNewBlockAdded($0) })
        }
    }
}
