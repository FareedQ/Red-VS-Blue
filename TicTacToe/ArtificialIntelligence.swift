//
//  ArtificialIntelligence.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-04.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class ArtificialIntelligence: NSObject {
    //This extention is to create an artificial intelligent player to compete with
    
    //Checks if a win can occur and react accordingly
    func aggressivelyTakeTileSelection() -> String {
        for winCondition in BoardDelegate.sharedInstance.winningConditions {
            
            let tileCombination = BoardDelegate.sharedInstance.whoHasClaimedThisSet(winCondition)
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
    func greedyTileSelection() -> String {
        
        var tileId = BoardDelegate.sharedInstance.getARandomCenterTile()
        
        if (tileId.isEmpty) {
            tileId = BoardDelegate.sharedInstance.getARandomCornerTile()
        }
        
        if (tileId.isEmpty) {
            tileId = BoardDelegate.sharedInstance.getARandomTile()
        }
        
        return tileId
    }

}
