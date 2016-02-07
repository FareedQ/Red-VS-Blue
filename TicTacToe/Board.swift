//
//  BoardMaster.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-02.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

struct Board {
    //MARK: DataTypes
    var board: [Int:Tile]
    
    
    //MARK CalculatedVariables
    
    var centerTiles: [Int] {
        get {
            var returnTiles = [Int]()
            for mytile in board {
                if mytile.1.tileType == .Center {
                    returnTiles.append(mytile.0)
                }
            }
            return returnTiles
        }
    }
    
    var cornerTiles: [Int] {
        get {
            var returnTiles = [Int]()
            for mytile in board {
                if mytile.1.tileType == .Corner {
                    returnTiles.append(mytile.0)
                }
            }
            return returnTiles
        }
    }
    
    var allTiles: [Int] {
        get {
            var returnTiles = [Int]()
            for mytile in board {
                returnTiles.append(mytile.0)
            }
            return returnTiles
        }
    }
}
