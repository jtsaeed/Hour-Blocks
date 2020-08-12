//
//  AcknowledgementsSheet.swift
//  Hour Blocks
//
//  Created by James Saeed on 11/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct AcknowledgementsSheet: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TextBlockView(title: "Icons 🖼",
                              content: "Hour Blocks uses Material Design Icons by Google for its block icons")
                TextBlockView(title: "Date Manipulation 🗓",
                              content: "Hour Blocks uses the SwiftDate library for a lot of its date manipulation work")
                TextBlockView(title: "Beta Testers 🐞",
                              content: "A big thank you to everyone who has beta tested and provided feedback for Hour Blocks!")
                Spacer()
            }.padding(40)
            .navigationBarTitle("Acknowledgements")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    func dismiss() {
        isPresented = false
    }
}

struct AcknowledgementsSheet_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgementsSheet(isPresented: .constant(true))
    }
}
