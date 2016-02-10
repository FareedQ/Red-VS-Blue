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

enum difficultyType {
    case None;
    case Hard;
    case Medium;
    case Easy;
}

enum ScoreCategories {
    case HardPlayer;
    case MediumPlayer;
    case EasyPlayer;
    case HardComputer;
    case MediumComputer;
    case EasyComputer;
    case PlayerX;
    case PlayerO;
}