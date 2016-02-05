//
//  BoardDelegate.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-03.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class BoardDelegate: NSObject {
    static let sharedInstance = BoardDelegate()
    
    //MARK: Parameters
    private let memoryBoard = Board()
    private let HAL = ArtificialIntelligence()
    weak var controllingView:MainVC?
    weak var visualBoard:UICollectionView?
    
    var whoseTurn:Player = .X
    var turnCount = 0
    
    var computerPlayerIsActive = true
    var lockSelectionForComputersTurn = false
    
    var winningConditions = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,4,8],
        [2,4,6],
        [0,3,6],
        [1,4,7],
        [2,5,8]]
    
    
    //MARK: CalculatedParameters
    var collectedTiles: [Int]{
        get {
            var returnTiles = [Int]()
            for mytile in memoryBoard.board {
                if mytile.1.player != .None {
                    returnTiles.append(mytile.0)
                }
            }
            return returnTiles
        }
    }
    
    //MARK: FuncitonalParameters
    func isACenterTileAvaliable() -> Bool {
        for tile in memoryBoard.centerTiles {
            if !collectedTiles.contains(tile) { return true }
        }
        return false
    }
    
    func isACornerTileAvaliable() -> Bool {
        for tile in memoryBoard.cornerTiles {
            if !collectedTiles.contains(tile) { return true }
        }
        return false
    }
    
    
    func whoHasClaimed(tileId:Int) -> Player {
        guard let tile = memoryBoard.board[tileId] else {return .None}
        return tile.player
    }
    
    func whoHasClaimedThisSet(tileIdArray:[Int]) -> [Player] {
        var playerArray = [Player]()
        for tileId in tileIdArray {
            playerArray.append(whoHasClaimed(tileId))
        }
        return playerArray
    }
    
    //MARK: BoardMaintence
    func setup(controllingView:MainVC){
        self.controllingView = controllingView
        self.visualBoard = controllingView.visualBoard
        resetBoard()
    }
    
    func resetBoard(){
        whoseTurn = .X
        turnCount = 0
        
        for tileId in memoryBoard.allTiles {
            memoryBoard.board[tileId]?.player = .None
        }
        visualBoard?.reloadData()
    }
    
    //MARK: PlayGame
    func executeSelection(thisCell:SelectionCell) -> WinResults {
        collectTile(thisCell)
        thisCell.animateTextCommingIn()
        let stateOfGame = isGameOver()
        if stateOfGame == .Continuing {
            incrementTurn()
        }
        return stateOfGame
    }
    
    func collectTile(thisCell:SelectionCell){
        guard let id = thisCell.id else {return}
        
        switch whoseTurn {
        case .X:
            thisCell.imageView.image = UIImage(named: "blue")
            memoryBoard.board[id]?.player = whoseTurn
            break
        case .O:
            thisCell.imageView.image = UIImage(named: "red")
            memoryBoard.board[id]?.player = whoseTurn
            break
        default:
            break
        }
    }
    
    func incrementTurn(){
        turnCount++
        
        switch whoseTurn {
        case .X:
            whoseTurn = .O
            break
        case .O:
            whoseTurn = .X
            break
        default:
            break
        }
    }
    
    
    
    func computerSelection(){
        
        guard let myVisualBoard = self.visualBoard else {return}
        guard let myControllingView = self.controllingView else {return}
        
        
        BoardDelegate.sharedInstance.lockSelectionForComputersTurn = true
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            BoardDelegate.sharedInstance.lockSelectionForComputersTurn = false
            let computersChoice = self.HAL.aggressivelyTakeTileSelection()
            guard let actualtile = myVisualBoard.cellForItemAtIndexPath(NSIndexPath(forRow: computersChoice, inSection: 0)) as? SelectionCell else { return }
            let results = BoardDelegate.sharedInstance.executeSelection(actualtile)
            myControllingView.displayAlertBasedOnWinResults(results)
        })
    }

    //MARK:EndGame
    func isGameOver() -> WinResults {
        if isWinner() {
            switch whoseTurn {
            case .X:
                Sounds.sharedInstance.cheersSound?.play()
                return .WinnerX
            case .O:
                if(computerPlayerIsActive){
                    Sounds.sharedInstance.booSound?.play()
                } else {
                    Sounds.sharedInstance.cheersSound?.play()
                }
                return .WinnerO
            case .None:
                Sounds.sharedInstance.cheersSound?.play()
                break
            }
        }
        if isNoTurnsLeft() { return .EndOfTurns }
        return .Continuing
    }
    
    func isWinner() -> Bool {
        var playersCollectedTiles = [Int]()
        for tileId in collectedTiles {
            guard let tile = memoryBoard.board[tileId] else {return false}
            if tile.player == whoseTurn {
                playersCollectedTiles.append(tileId)
            }
        }
        let playercollectedSet = Set(playersCollectedTiles)
        
        for winCondition in winningConditions {
            let winConditionSet = Set(winCondition)
            if playercollectedSet.isSupersetOf(winConditionSet) { return true }
        }
        return false
    }
    
    func isNoTurnsLeft() -> Bool {
        if(turnCount == (memoryBoard.board.count - 1)) {
            return true
        }
        return false
    }
    
    //MARK: RandomTileSelection
    func aRandomTile(allCollectedTiles:[Int], var rangeToSelectFrom:[Int]) -> Int {
        
        var randomIndex = Int(arc4random_uniform(UInt32(rangeToSelectFrom.count)))
        while allCollectedTiles.contains(rangeToSelectFrom[randomIndex]) {
            randomIndex = Int(arc4random_uniform(4))
        }
        return rangeToSelectFrom[randomIndex]
    }
    
    func getARandomCenterTile() -> Int {
        if BoardDelegate.sharedInstance.isACenterTileAvaliable() {
            return aRandomTile(collectedTiles, rangeToSelectFrom:memoryBoard.centerTiles)
        }
        return -1
    }
    
    func getARandomCornerTile() -> Int {
        if BoardDelegate.sharedInstance.isACornerTileAvaliable() {
            return aRandomTile(BoardDelegate.sharedInstance.collectedTiles, rangeToSelectFrom:BoardDelegate.sharedInstance.memoryBoard.cornerTiles)
        }
        return -1
    }
    
    func getARandomTile() -> Int {
        return aRandomTile(BoardDelegate.sharedInstance.collectedTiles, rangeToSelectFrom:BoardDelegate.sharedInstance.memoryBoard.allTiles)
    }
}

