//
//  AudioGateway.swift
//  neon
//
//  Created by James Saeed on 22/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

/// A singleton gateway service used to interface with Core Haptics.
struct HapticsGateway {
    
    static let shared = HapticsGateway()
    
    /// Triggers a medium intensity heavy haptic that's generally used for when items are added.
    func triggerAddBlockHaptic() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.75)
    }
    
    /// Triggers a high intensity soft haptic that's generally used for when items are cleared.
    func triggerClearBlockHaptic() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.9)
    }
    
    /// Triggers a success haptic that's used when an item is marked as complete.
    func triggerCompletionHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    /// Triggers a light haptic that's generally used for generic button taps.
    func triggerLightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    /// Trigers a low intensity soft haptic that's used for lightweight interactions such as icon selection.
    func triggerSoftImpact() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.6)
    }
    
    /// Triggers an error haptic.
    func triggerErrorHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
