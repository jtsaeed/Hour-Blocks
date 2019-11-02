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
            WhatsNewHeader(title: "What's new in Hour Blocks 3.0B2")
                .padding(.bottom, 40)
            
            VStack(alignment: .leading, spacing: 16) {
                WhatsNewItem(title: "Reminders are back  ⏰", content: "With a sexy indicator too. Just bare in mind that the default atm is 10 mins, will add a global setting later.")
                WhatsNewItem(title: "Calendar tweaks  🗓", content: "All day events work again and you can once again select specific calendars in settings")
            }
            
            Spacer()
            WhatsNewDismissButton()
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

struct WhatsNewDismissButton: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("primary"))
                .frame(height: 48)
            Text("Let's go!")
                .font(.system(size: 17, weight: .semibold, design: .default))
                .foregroundColor(.white)
        }
    }
}
