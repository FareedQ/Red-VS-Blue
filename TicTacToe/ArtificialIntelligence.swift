//
//  ArtificialIntelligence.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-04.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class ArtificialIntelligence: NSObject {
    
    func chooseTile() -> Int {
        switch Game.sharedInstance.difficultyFlag {
        case .Hard:
            return aggressivelyTakeTileSelection()
        case .Medium:
            if arc4random_uniform(4) < 2 {
                return aggressivelyTakeTileSelection()
            } else {
                return greedyTileSelection()
            }
        case .Easy:
            if arc4random_uniform(4) > 2 {
                return aggressivelyTakeTileSelection()
            } else {
                return Game.sharedInstance.getARandomTile()
            }
        default:
            break
        }
        return -1
    }
    
    //Checks if a win can occur and react accordingly
    func aggressivelyTakeTileSelection() -> Int {
        for winCondition in Game.sharedInstance.winningConditions {
            
            let tileCombination = Game.sharedInstance.whoHasClaimedThisSet(winCondition)
            for index0 in 0...(tileCombination.count-1) {
                let index1 = (index0+1)%(tileCombination.count)
                let index2 = (index0+2)%(tileCombination.count)
                
                if tileCombination[index0] == tileCombination[index1] && tileCombination[index0] != Player.None && tileCombination[index2] == Player.None {
                    return winCondition[index2]
                }
            }
        }
        return greedyTileSelection()
    }
    
    //Chooses the center tile and the corner tiles if avaliable
    func greedyTileSelection() -> Int {
        
        var tileId = Game.sharedInstance.getARandomCenterTile()
        
        if (tileId == -1) {
            tileId = Game.sharedInstance.getARandomCornerTile()
        }
        
        if (tileId == -1) {
            tileId = Game.sharedInstance.getARandomTile()
        }
        
        return tileId
    }

}
