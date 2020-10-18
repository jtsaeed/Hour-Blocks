//
//  EmptyHourBlockView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

/// A Card based view for displaying an empty Hour Block.
struct EmptyHourBlockView: View {
    
    @ObservedObject private var viewModel: HourBlockViewModel
    
    private let onNewBlockAdded: (HourBlock) -> Void
    
    /// Creates an instance of EmptyHourBlockView.
    ///
    /// - Parameters:
    ///   - viewModel: The corresponding view model for the given Hour Block.
    ///   - onNewBlockAdded: The callback function to be triggered when the user chooses to add to the corresponding Hour Block.
    init(viewModel: HourBlockViewModel, onNewBlockAdded: @escaping (HourBlock) -> Void) {
        self.viewModel = viewModel
        self.onNewBlockAdded = onNewBlockAdded
    }
    
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
                             for: viewModel.hourBlock.day, viewModel.hourBlock.hour,
                             onNewBlockAdded: { onNewBlockAdded($0) })
        }
    }
}
