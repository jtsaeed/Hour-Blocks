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

class HapticsGateway {
    
    static let shared = HapticsGateway()

    var player: AVAudioPlayer!
    
    func triggerAddBlockHaptic() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.75)
        triggerHaptic(for: .addBlock)
    }

    private func triggerHaptic(for sfx: SoundEffect) {
        if let path = Bundle.main.path(forResource: sfx.rawValue, ofType: "aif") {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player.play()
            } catch {
                print("Could not find file")
            }
        }
    }
}

enum SoundEffect: String {
    
    case addBlock = "add_block"
}
