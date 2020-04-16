//
//  SoundController.swift
//  SensorTesting
//
//  Created by Lia Kassardjian on 16/04/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import AVFoundation

class SoundManager {
    
    var player: AVAudioPlayer?

    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "ball", withExtension: "wav"), UserDefaults.standard.bool(forKey: "sound") {

            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: soundURL, fileTypeHint: AVFileType.mp3.rawValue)
            } catch {
                print(error.localizedDescription)
            }
            player?.prepareToPlay()
            player?.play()
        } else {
            print("Não foi possível encontrar o arquivo ou a configuração está desabilitada")
        }
    }
}
