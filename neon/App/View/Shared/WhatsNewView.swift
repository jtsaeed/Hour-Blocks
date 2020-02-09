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
            WhatsNewHeader(title: "What's new in Hour Blocks \(DataGateway.shared.currentVersion)")
                .padding(.bottom, 32)
            
            VStack(alignment: .leading, spacing: 16) {
                WhatsNewItem(title: "Episode 4.3: Return of The To Do List ☑️",
                             content: "As a result of an overwhelming amount of votes, an overhauled version of the To Do List comes back to Hour Blocks!")
                WhatsNewItem(title: "Minor Changes ✨",
                             content: "Stability & aesthetic improvements here and there")
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
