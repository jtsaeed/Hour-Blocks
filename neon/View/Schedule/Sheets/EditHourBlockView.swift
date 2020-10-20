//
//  EditHourBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view where an Hour Block can be edited.
struct EditHourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    @State var title: String
    @State var icon: SelectableIcon
    
    /// Creates an instance of EditHourBlockView.
    ///
    /// - Parameters:
    ///   - viewModel: The corresponding view model of the Hour Block to be edited.
    init(viewModel: HourBlockViewModel) {
        self.viewModel = viewModel
        self._title = State(initialValue: viewModel.hourBlock.title!)
        self._icon = State(initialValue: viewModel.icon)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    NeonTextField(text: $title)
                        .padding(24)
                    
                    IconPicker(currentSelection: $icon)
                    
                    Spacer()
                }
            }.navigationTitle("Edit Hour Block")
            .navigationBarItems(leading: Button("Cancel", action: viewModel.dismissEditBlockView),
                                trailing: Button("Save", action: { viewModel.saveChanges(newTitle: title, newIcon: icon) }))
        }.accentColor(Color("AccentColor"))
    }
}

struct EditHourBlockView_Previews: PreviewProvider {
    static var previews: some View {
        EditHourBlockView(viewModel: HourBlockViewModel(for: HourBlock(day: Date(),
                                                                       hour: 12,
                                                                       title: "Lunch")))
    }
}
