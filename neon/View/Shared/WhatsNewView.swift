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
            WhatsNewHeader(title: "What's new in Hour Blocks \(VersionGateway.shared.currentVersion)")
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextBlockView(title: "Redesigned Schedule 🖌",
                                  content: "See your Sub Blocks directly in the schedule, preview your days with the new date picker, reschedule blocks, along with so much more!")
                    TextBlockView(title: "Homescreen Widget 📱",
                                  content: "Get a snapshot of your upcoming schedule without even leaving your homescreen!")
                    TextBlockView(title: "Siri Support 🎤",
                                  content: "You can now ask Siri to add an item to your To Do List in Hour Blocks")
                    TextBlockView(title: "Small Improvements ✨",
                                  content: "Hour Blocks 6.0 has been rewritten from the ground up, so expect to see plenty of small improvements and bug fixes all around")
                }
            }.padding(.vertical, 32)
            
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
