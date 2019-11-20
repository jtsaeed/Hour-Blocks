//
//  AudioGateway.swift
//  neon
//
//  Created by James Saeed on 22/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import AVFoundation

class AudioGateway {
    
    static let shared = AudioGateway()

    var player: AVAudioPlayer!

    func playSFX(_ sfx: SoundEffect) {
        if let path = Bundle.main.path(forResource: sfx.rawValue, ofType: "mp3") {
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
    case removeBlock = "remove_block"
    case toggleBlocks = "toggle_blocks"
}
