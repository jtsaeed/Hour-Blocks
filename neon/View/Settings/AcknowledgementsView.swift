//
//  AcknowledgementsSheet.swift
//  Hour Blocks
//
//  Created by James Saeed on 11/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view displaying the acknowledgements for Hour Blocks.
struct AcknowledgementsView: View {
    
    @Binding private var isPresented: Bool
    
    /// Creates an instance of the AcknowledgementsView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
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
            }.padding(.vertical, 24)
            .padding(.horizontal, 32)
            .navigationBarTitle("Acknowledgements")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

struct AcknowledgementsView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgementsView(isPresented: .constant(true))
    }
}
