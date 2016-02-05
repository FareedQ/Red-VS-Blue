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

enum tileType {
    case Center
    case Corner
    case Edge
}

struct Tile {
    let type:tileType
    var player:Player
}

enum WinResults {
    case WinnerX
    case WinnerO
    case EndOfTurns
    case Error
    case Continuing
}
