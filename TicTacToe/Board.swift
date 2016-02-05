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
    
    var board: [String:Tile]
    
    override init(){
        board = [
            "A1":A1,
            "A2":A2,
            "A3":A3,
            "B1":B1,
            "B2":B2,
            "B3":B3,
            "C1":C1,
            "C2":C2,
            "C3":C3]
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
    
    var centerTiles: [String] {
        get {
            var returnTiles = [String]()
            for mytile in board {
                if mytile.1.type == .Center {
                    returnTiles.append(mytile.0)
                }
            }
            return returnTiles
        }
    }
    
    var cornerTiles: [String] {
        get {
            var returnTiles = [String]()
            for mytile in board {
                if mytile.1.type == .Corner {
                    returnTiles.append(mytile.0)
                }
            }
            return returnTiles
        }
    }
    
    var allTiles: [String] {
        get {
            var returnTiles = [String]()
            for mytile in board {
                returnTiles.append(mytile.0)
            }
            return returnTiles
        }
    }
}
