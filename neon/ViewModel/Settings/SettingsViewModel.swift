//
//  NewSettingsViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import UIKit

/// The view model for the SettingsView.
class SettingsViewModel: ObservableObject {
    
    @Published var isCalendarSettingsViewPresented = false
    @Published var isOtherSettingsViewPresented = false
    @Published var isPrivacyPolicyViewPresented = false
    @Published var isAcknowledgementsViewPresented = false
    
    /// Creates an instance of the SettingsViewModel.
    init() { }
    
    /// Presents the CalendarSettingsView.
    func presentCalendarSettingsView() {
        HapticsGateway.shared.triggerLightImpact()
        isCalendarSettingsViewPresented = true
    }
    
    /// Presents the OtherSettingsView.
    func presentOtherSettingsView() {
        HapticsGateway.shared.triggerLightImpact()
        isOtherSettingsViewPresented = true
    }
    
    /// Presents the PrivacyPolicyView.
    func presentPrivacyPolicyView() {
        HapticsGateway.shared.triggerLightImpact()
        isPrivacyPolicyViewPresented = true
    }
    
    /// Presents the AcknowledgementsView.
    func presentAcknowledgementsView() {
        HapticsGateway.shared.triggerLightImpact()
        isAcknowledgementsViewPresented = true
    }
    
    /// Opens a web link to James' Twitter profile.
    func openTwitter() {
        if let url = URL(string: "https://twitter.com/j_t_saeed") {
            UIApplication.shared.open(url)
        }
    }
}
