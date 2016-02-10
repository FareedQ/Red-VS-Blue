//
//  HighScore.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-09.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class HighScore: NSObject {
    static let sharedInstance = HighScore()
    
    var data = [
        "Hard-Player": 0,
        "Hard-Computer": 0,
        "Medium-Player": 0,
        "Medium-Computer": 0,
        "Easy-Player": 0,
        "Easy-Computer":0,
        "Player-X":0,
        "Player-O":0]
    
    let defaults = NSUserDefaults.standardUserDefaults()

    func saveDataToDefaults(){
        defaults.setValue(data, forKey: "highScore")
        defaults.synchronize()
    }
    
    func fetchDataWithDefaults() {
        if let object = defaults.objectForKey("highScore") as? [String:Int] {
            data = object
        }
    }
    
    func incrementScore(category:ScoreCategories){
        switch category {
        case .HardPlayer:
            guard let currentScore = data["Hard-Player"] else {
                return }
            data["Hard-Player"] = currentScore + 1
        case .HardComputer:
            guard let currentScore = data["Hard-Computer"] else { return }
            data["Hard-Computer"] = currentScore + 1
        case .MediumPlayer:
            guard let currentScore = data["Medium-Player"] else { return }
            data["Medium-Player"] = currentScore + 1
        case .MediumComputer:
            guard let currentScore = data["Medium-Computer"] else { return }
            data["Medium-Computer"] = currentScore + 1
        case .EasyPlayer:
            guard let currentScore = data["Easy-Player"] else { return }
            data["Easy-Player"] = currentScore + 1
        case .EasyComputer:
            guard let currentScore = data["Easy-Computer"] else { return }
            data["Easy-Computer"] = currentScore + 1
        case .PlayerX:
            guard let currentScore = data["Player-X"] else { return }
            data["Player-X"] = currentScore + 1
        case .PlayerO:
            guard let currentScore = data["Player-O"] else { return }
            data["Player-O"] = currentScore + 1
        }
    }

    func resetAllScores(){
        data = [
            "Hard-Player": 0,
            "Hard-Computer": 0,
            "Medium-Player": 0,
            "Medium-Computer": 0,
            "Easy-Player": 0,
            "Easy-Computer":0,
            "Player-X": 0,
            "Player-O":0,
        ]
    }
    
    func getData(category:ScoreCategories) -> Int {
        switch category {
        case .HardPlayer:
            guard let currentScore = data["Hard-Player"] else { return -1 }
            return currentScore
        case .HardComputer:
            guard let currentScore = data["Hard-Computer"] else { return -1 }
            return currentScore
        case .MediumPlayer:
            guard let currentScore = data["Medium-Player"] else { return -1 }
            return currentScore
        case .MediumComputer:
            guard let currentScore = data["Medium-Computer"] else { return -1 }
            return currentScore
        case .EasyPlayer:
            guard let currentScore = data["Easy-Player"] else { return -1 }
            return currentScore
        case .EasyComputer:
            guard let currentScore = data["Easy-Computer"] else { return -1 }
            return currentScore
        case .PlayerX:
            guard let currentScore = data["Player-X"] else { return -1 }
            return currentScore
        case .PlayerO:
            guard let currentScore = data["Player-O"] else { return -1 }
            return currentScore
        }
    }
    
}