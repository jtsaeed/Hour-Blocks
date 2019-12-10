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
            WhatsNewHeader(title: "What's new in Hour Blocks 3.2")
                .padding(.bottom, 24)
            
            VStack(alignment: .leading, spacing: 16) {
                WhatsNewItem(title: "Sub Blocks 💪",
                             content: "With Hour Blocks Pro, you can add as many Sub Blocks as you want to an Hour Block for maximum productivity!")
                WhatsNewItem(title: "iCloud Sync ☁️",
                             content: "Now all of your Hour Blocks data automatically syncs across all of your devices through iCloud")
                WhatsNewItem(title: "Minor Changes ✨",
                             content: "Touched up some stuff here and there & fixed some bugs")
            }
            
            Spacer()
            
            ActionButton(title: "Let's go!")
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
