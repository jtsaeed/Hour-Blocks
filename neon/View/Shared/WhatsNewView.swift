//
//  WhatsNewView.swift
//  neon
//
//  Created by James Saeed on 02/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct WhatsNewView: View {
    
    @Binding var showWhatsNew: Bool
    
    var body: some View {
        VStack {
            WhatsNewHeader(title: "What's new in\nHour Blocks \(VersionGateway.shared.currentVersion)")
                .padding(.top, 24)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextBlockView(title: "To Do List Widget 📱",
                                  content: "Get a snapshot of your To Do List without even leaving your home screen!")
                    TextBlockView(title: "More Alternative Icons 🎨",
                                  content: "Have your pick from a total of 6 alternative app icons for Hour Blocks")
                    TextBlockView(title: "Small Improvements ✨",
                                  content: "Fixed a bug that would sometimes cause a crash on launch + other small fixes & tweks")
                }
            }.padding(.top, 24)
            
            ActionButton(title: "Let's go!", action: dismiss)
        }.padding(.vertical, 24)
        .padding(.horizontal, 32)
    }
    
    func dismiss() {
        HapticsGateway.shared.triggerLightImpact()
        showWhatsNew = false
    }
}

private struct WhatsNewHeader: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 34, weight: .bold, design: .default))
            .multilineTextAlignment(.center)
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView(showWhatsNew: .constant(true))
    }
}
