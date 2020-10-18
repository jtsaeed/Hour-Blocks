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
            Text("What's new in\nHour Blocks \(VersionGateway.shared.fullCurrentVersion)")
                .font(.system(size: 34, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextBlockView(title: "To Do List Widget 📱",
                                  content: "Get a snapshot of your To Do List without even leaving your home screen!")
                    TextBlockView(title: "More Alternative Icons 🎨",
                                  content: "Have your pick from a total of 6 alternative app icons for Hour Blocks")
                    TextBlockView(title: "Small Improvements ✨",
                                  content: "Fixed a bug that would sometimes cause a crash on launch + other small fixes & tweaks")
                }
            }.padding(.top, 24)
            
            ActionButton("Let's go!", action: dismiss)
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
