//
//  BoardMaster.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-02.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class Board: NSObject {
    //MARK: DataTypes
    
    var board: [Int:Tile]
    
    override init(){
        board = [
            0:A1,
            1:A2,
            2:A3,
            3:B1,
            4:B2,
            5:B3,
            6:C1,
            7:C2,
            8:C3]
    }
    
    let A1 = Tile(type: .Corner, player: .None)
    let A2 = Tile(type: .Edge, player: .None)
    let A3 = Tile(type: .Corner, player: .None)
    let B1 = Tile(type: .Edge, player: .None)
    let B2 = Tile(type: .Center, player: .None)
    let B3 = Tile(type: .Edge, player: .None)
    let C1 = Tile(type: .Corner, player: .None)
    let C2 = Tile(type: .Edge, player: .None)
    let C3 = Tile(type: .Corner, player: .None)
    
    
    //MARK CalculatedVariables
    
    var centerTiles: [Int] {
        get {
            var returnTiles = [Int]()
            for mytile in board {
                if mytile.1.type == .Center {
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
                if mytile.1.type == .Corner {
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
