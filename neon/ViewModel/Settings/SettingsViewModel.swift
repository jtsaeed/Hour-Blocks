//
//  NewSettingsViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewModel: ObservableObject {
    
    @Published var isCalendarOptionsViewPresented = false
    @Published var isOtherSettingsViewPresented = false
    @Published var isFeedbackViewPresented = false
    @Published var isPrivacyPolicyPresented = false
    
    func presentCalendarOptionsView() {
        isCalendarOptionsViewPresented = true
    }
    
    func presentOtherSettingsView() {
        isOtherSettingsViewPresented = true
    }
    
    func presentFeedbackView() {
        isFeedbackViewPresented = true
    }
    
    func presentPrivacyPolicyView() {
        isPrivacyPolicyPresented = true
    }
    
    func openTwitter() {
        if let url = URL(string: "https://twitter.com/j_t_saeed") {
            UIApplication.shared.open(url)
        }
    }
}
