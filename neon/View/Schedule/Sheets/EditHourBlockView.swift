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
    
    init(viewModel: HourBlockViewModel) {
        self.viewModel = viewModel
        self._title = State(initialValue: viewModel.title)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(input: $title, didReturn: {})
                    .padding(24)
                
                Spacer()
            }.navigationTitle("Edit Hour Block")
            .navigationBarItems(leading: Button("Cancel", action: viewModel.dismissEditBlockView),
                                trailing: Button("Save", action: save))
        }
        .accentColor(Color("AccentColor"))
    }
    
    func save() {
        viewModel.saveChanges(title: title)
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
