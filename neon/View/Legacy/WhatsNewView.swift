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
            WhatsNewHeader(title: "What's new in Hour Blocks \(MetaGateway.shared.currentVersion)")
                .padding(.bottom, 32)
            
            VStack(alignment: .leading, spacing: 16) {
                WhatsNewItem(title: "macOS App 💻",
                             content: "Effortlessly take control of your day from your lap and your desk, with Hour Blocks on macOS")
                WhatsNewItem(title: "Minor Improvements ✨",
                             content: "You can now set your day to start from 12am within Settings")
            }
            
            Spacer()
            
            ActionButton(title: "Let's go!")
                .onTapGesture {
                    HapticsGateway.shared.triggerLightImpact()
                    self.showWhatsNew = false
                }
        }.padding(40)
    }
}

struct WhatsNewHeader: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 34, weight: .bold, design: .default))
            .multilineTextAlignment(.center)
    }
}

struct WhatsNewItem: View {
    
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
