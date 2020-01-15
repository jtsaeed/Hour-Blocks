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
            WhatsNewHeader(title: "What's new in Hour Blocks 4.0")
                .padding(.bottom, 32)
            
            VStack(alignment: .leading, spacing: 16) {
                WhatsNewItem(title: "Habits 🔥",
                             content: "Keep track of your habits and get some streaks going with the brand new Habits tab!")
                WhatsNewItem(title: "Alternate App Icons 🎨",
                             content: "Pro users now have the ability to choose from 3 different app icons to display on their homescreen")
                WhatsNewItem(title: "Minor Changes ✨",
                             content: "Minor improvements all round and fixed some crash related issues, however I am aware that iPhone XR & 11 users are still experiencing crashes and these are being worked on")
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
