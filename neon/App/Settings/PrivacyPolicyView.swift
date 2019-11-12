//
//  PrivacyPolicyView.swift
//  neon
//
//  Created by James Saeed on 12/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct PrivacyPolicyView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    PrivacyPolicyItem(title: "Your personal data is safe 🔐", content: "Personal identifiers such as name and address aren't even asked for by Hour Blocks- we simply don't need that from you")
                    PrivacyPolicyItem(title: "On-device learning 📱", content: "Learning data for suggested blocks are generated on-device, meaning we're not spying on your habits in order to power suggestions")
                    PrivacyPolicyItem(title: "So what do we collect? 🤔", content: "In order to improve aspects of Hour Blocks such as icon generation, we collect just simply the 'category' of a block you add- and it's completely anonymized, so it can't be traced back to you")
                }
                Spacer()
                FullPolicyButton()
            }.padding(40)
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Done")
            }))
            .navigationBarTitle("Privacy Policy")
        }.accentColor(Color("primary"))
    }
}

struct PrivacyPolicyItem: View {
    
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

struct FullPolicyButton: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("primary"))
                .frame(height: 48)
            Text("View full privacy policy")
                .font(.system(size: 17, weight: .semibold, design: .default))
                .foregroundColor(.white)
        }.onTapGesture {
            if let url = URL(string: "https://app.termly.io/document/privacy-policy/0a585245-4a5e-415c-af29-adf25c1b031c") {
                UIApplication.shared.open(url)
            }
        }
    }
}
