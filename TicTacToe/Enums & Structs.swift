//
//  Global Enums.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-02.
//  Copyright © 2016 FareedQ. All rights reserved.
//

enum Player {
    case X
    case O
    case None
}

enum TileType {
    case Center
    case Corner
    case Edge
}

enum WinResults {
    case WinnerX
    case WinnerO
    case EndOfTurns
    case Error
    case Continuing
}

struct Tile {
    let tileType:TileType
    var player:Player
    var neighbouringTiles:[String:Int]
}