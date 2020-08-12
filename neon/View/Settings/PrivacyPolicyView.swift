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
                    TextBlockView(title: "Your personal data is safe 🔐",
                                  content: "Personal identifiers such as name and phone number aren't even asked for by Hour Blocks- we simply don't need that from you")
                    TextBlockView(title: "So what do we collect? 🤔",
                                  content: "In order to improve certain aspects of Hour Blocks such as icon generation and suggestions, we collect just simply the 'category' of a block you add- and it's completely anonymized, so it can't be traced back to you")
                }
                Spacer()
                
                ActionButton(title: "View full privacy policy", action: viewFullPrivacyPolicy)
            }.padding(40)
            .navigationBarTitle("Privacy Policy")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    func viewFullPrivacyPolicy() {
        UIApplication.shared.open(URL(string: "https://app.termly.io/document/privacy-policy/0a585245-4a5e-415c-af29-adf25c1b031c")!)
    }
    
    func dismiss() {
        isPresented = false
    }
}
