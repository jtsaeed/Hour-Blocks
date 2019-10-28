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

    var player: AVAudioPlayer?

    func playSFX(_ sfx: SoundEffect) {
        guard let url = Bundle.main.url(forResource: sfx.rawValue, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            if let player = player {
                player.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

enum SoundEffect: String {
    
    case addBlock = "add_block"
    case removeBlock = "remove_block"
    case toggleBlocks = "toggle_blocks"
}
