//
//  WhatsNewView.swift
//  neon
//
//  Created by James Saeed on 02/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

/// A view displaying the changelog for the latest version of Hour Blocks.
struct WhatsNewView: View {
    
    @Binding private var isPresented: Bool
    
    /// Creates an instance of WhatsNewView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            Text(AppStrings.WhatsNew.header)
                .font(.system(size: 34, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextBlockView(title: "To Do List History 🕖",
                                  content: "After being such a popular request for so long, you can now finally view your completed To Do List items in one convenient sheet!")
                    TextBlockView(title: "Small Improvements ✨",
                                  content: "Minor UI tweaks in various places")
                }
            }.padding(.top, 24)
            
            ActionButton(AppStrings.WhatsNew.dismissButtonTitle, action: dismiss)
        }.padding(.vertical, 24)
        .padding(.horizontal, 32)
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        HapticsGateway.shared.triggerLightImpact()
        isPresented = false
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView(isPresented: .constant(true))
    }
}
