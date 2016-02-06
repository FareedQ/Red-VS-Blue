//
//  soundController.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-01-21.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AVFoundation

private let sharedSounds = Sounds()
class Sounds: NSObject {
    static let sharedInstance = Sounds()
    
    var robotSound: AVAudioPlayer?
    var cheersSound: AVAudioPlayer?
    var booSound: AVAudioPlayer?
    
    var soundState = true
    
    func setupSounds(){
        if let robotSound = self.setupAudioPlayerWithFile("Robot", type:"wav") {
            self.robotSound = robotSound
        }
        if let cheersSound = self.setupAudioPlayerWithFile("Cheers", type:"wav") {
            self.cheersSound = cheersSound
        }
        if let booSound = self.setupAudioPlayerWithFile("Boo", type:"mp3") {
            self.booSound = booSound
        }
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            NSLog("Player not available", "")
        }
        
        return audioPlayer
    }
    
    func stopAllSounds(){
        cheersSound?.stop()
        cheersSound?.currentTime = 0
        booSound?.stop()
        booSound?.currentTime = 0
    }
    
    func toggleSounds(){
        if soundState {
            robotSound?.volume = 0
            cheersSound?.volume = 0
            booSound?.volume = 0
            soundState = false
        } else {
            robotSound?.volume = 1
            cheersSound?.volume = 1
            booSound?.volume = 1
            soundState = true
        }
    }
    
}
