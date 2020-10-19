//
//  PrivacyPolicyView.swift
//  neon
//
//  Created by James Saeed on 12/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

/// A view displaying a summary of the Hour Blocks privacy policy.
struct PrivacyPolicyView: View {
    
    @Binding private var isPresented: Bool
    
    /// Creates an instance of PrivacyPolicyView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
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
                
                ActionButton("View full privacy policy", action: viewFullPrivacyPolicy)
            }.padding(.vertical, 24)
            .padding(.horizontal, 32)
            .navigationBarTitle("Privacy Policy")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    /// Opens the URL for the full privacy policy.
    private func viewFullPrivacyPolicy() {
        UIApplication.shared.open(URL(string: "https://app.termly.io/document/privacy-policy/0a585245-4a5e-415c-af29-adf25c1b031c")!)
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}
