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
                    TextBlockView(title: AppStrings.Settings.personalDataPrivacyTitle,
                                  content: AppStrings.Settings.personalDataPrivacyContent)
                    TextBlockView(title: AppStrings.Settings.collectedDataPrivacyTitle,
                                  content: AppStrings.Settings.collectedDataPrivacyContent)
                }
                
                Spacer()
                
                ActionButton(AppStrings.Settings.viewFullPrivacyPolicyButton, action: viewFullPrivacyPolicy)
            }.padding(.vertical, 24)
            .padding(.horizontal, 32)
            .navigationBarTitle(AppStrings.Settings.privacyTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.Global.done, action: dismiss)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
    }
    
    /// Opens the URL for the full privacy policy.
    private func viewFullPrivacyPolicy() {
        if let url = URL(string: AppStrings.Settings.fullPrivacyPolicyURL) {
            UIApplication.shared.open(url)
        }
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}
