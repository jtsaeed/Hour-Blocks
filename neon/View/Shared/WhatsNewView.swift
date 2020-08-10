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
                    WhatsNewItem(title: "Redesigned Schedule 🖌",
                                 content: "See your Sub Blocks directly in the schedule, preview your days with the new date picker, take a peek at blocks from earlier in the day + so much more!")
                    WhatsNewItem(title: "Homescreen Widget 📱",
                                 content: "Get a snapshot of your upcoming schedule without even leaving your homescreen!")
                    WhatsNewItem(title: "Small Improvements ✨",
                                 content: "Hour Blocks 6.0 has been rewritten from the ground up, so expect to see plenty of small improvements and bug fixes all around")
                }
            }.padding(.vertical, 32)
            
            ActionButton(title: "Let's go!", action: dismiss)
        }.padding(40)
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

private struct WhatsNewItem: View {
    
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            Text(content)
                .font(.system(size: 17, weight: .regular, design: .default))
        }
    }
}
