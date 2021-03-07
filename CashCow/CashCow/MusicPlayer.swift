//
//  MusicPlayer.swift
//  CashCow
//
//  Created by Angie Ni on 3/4/21.
//

import Foundation
import AVFoundation

class MusicPlayer {
    
    static let shared = MusicPlayer()   // only one instance at a time
    var audioPlayer: AVAudioPlayer?

    func startMusic() {
        if let bundle = Bundle.main.path(forResource: "Music_Loop", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print("Couldn't play music :-(")
                print(error)
            }
        }
    }
}
