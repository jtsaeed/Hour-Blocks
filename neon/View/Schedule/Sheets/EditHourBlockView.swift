//
//  EditHourBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct EditHourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    @State var title: String
    @State var icon: SelectableIcon
    
    init(viewModel: HourBlockViewModel) {
        self.viewModel = viewModel
        self._title = State(initialValue: viewModel.hourBlock.title!)
        self._icon = State(initialValue: viewModel.icon)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
            VStack(alignment: .leading) {
                NeonTextField(input: $title, didReturn: {})
                    .padding(24)
                
                IconPicker(selection: $icon)
                
                Spacer()
            }
                
            }.navigationTitle("Edit Hour Block")
            .navigationBarItems(leading: Button("Cancel", action: viewModel.dismissEditBlockView),
                                trailing: Button("Save", action: save))
        }
        .accentColor(Color("AccentColor"))
    }
    
    func save() {
        viewModel.saveChanges(title: title, icon: icon)
    }
}

/*
struct EditHourBlockView_Previews: PreviewProvider {
    static var previews: some View {
        EditHourBlockView(isPresented: .constant(true), hourBlock: NewHourBlock(day: Date(),
                                                                                hour: 12,
                                                                                title: "Lunch"))
    }
}
*/
