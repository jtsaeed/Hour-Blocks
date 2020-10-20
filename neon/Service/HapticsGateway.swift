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

struct HapticsGateway {
    
    static let shared = HapticsGateway()
    
    func triggerAddBlockHaptic() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.75)
    }
    
    func triggerClearBlockHaptic() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.9)
    }
    
    func triggerCompletionHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func triggerLightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func triggerSoftImpact() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.6)
    }
    
    func triggerErrorHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
