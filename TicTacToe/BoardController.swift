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
    private var memoryBoard = Board(board: [:])
    private let HAL9000 = ArtificialIntelligence()
    weak var controllingView:MainVC?
    weak var visualBoard:UICollectionView?
    
    var whoseTurn:Player = .X
    var turnCount = 0
    var lockSelectionForComputersTurn = false
    var computerPlayerIsActive = true
    var difficultyFlag:difficultyType = .Hard
    var tilesPerRow = 3
    
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
    
    var tilesCount: Int {
        get{
            return tilesPerRow*tilesPerRow
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
    func setupBoard(controllingView:MainVC){
        self.controllingView = controllingView
        self.visualBoard = controllingView.visualBoard
        resetBoard()
    }
    
    func resetBoard(){
        whoseTurn = .X
        turnCount = 0
        memoryBoard = Board(board: [:])
        visualBoard?.reloadData()
    }
    
    func setupTiles(tileId:Int){
        
        let neighbouringTiles = [
        "TopLeft":tileId - tilesPerRow - 1,
        "TopMiddle":tileId - tilesPerRow,
        "TopRight":tileId - tilesPerRow + 1,
        "MiddleLeft":tileId - 1,
        "MiddleRight":tileId + 1,
        "BottomLeft":tileId + tilesPerRow - 1,
        "BottomMiddle":tileId + tilesPerRow,
        "BottomRight":tileId + tilesPerRow + 1]
        
        var tileType:TileType?
        if(tileId%tilesPerRow == 0 || tileId%tilesPerRow == tilesPerRow-1){
            if(tileId/tilesPerRow == 0 || tileId/tilesPerRow == tilesPerRow-1){
                tileType = .Corner
            } else {
                tileType = .Edge
            }
        } else {
            if(tileId/tilesPerRow == 0 || tileId/tilesPerRow == tilesPerRow-1){
                tileType = .Edge
            } else {
                tileType = .Center
            }
        }
        guard let assignedTile = tileType else {
            NSLog("A tile was not assigned a type", "")
            return
        }
        
        memoryBoard.board[tileId] = Tile(tileType: assignedTile, player: .None,neighbouringTiles:neighbouringTiles)
    }
    
    //MARK: PlayGame
    func selectItemOnBoard(indexPath:NSIndexPath){
        if BoardDelegate.sharedInstance.lockSelectionForComputersTurn {return}
        
        if (BoardDelegate.sharedInstance.whoHasClaimed(indexPath.row) == .None) {
            let results = BoardDelegate.sharedInstance.executeSelection(indexPath.row)
            displayAlertBasedOnWinResults(results)
        }
        
        BoardDelegate.sharedInstance.letComputerHaveATurn()
    }
    
    func executeSelection(tileId:Int) -> WinResults {
        guard let myControllingView = controllingView else { return .Error }
        
        collectTile(tileId)
        myControllingView.displayPlayer(tileId)
        let stateOfGame = isGameOver()
        if stateOfGame == .Continuing {
            incrementTurn()
        }
        return stateOfGame
    }
    
    func collectTile(tileId:Int){
        
        switch whoseTurn {
        case .X:
            memoryBoard.board[tileId]?.player = whoseTurn
            break
        case .O:
            memoryBoard.board[tileId]?.player = whoseTurn
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
    
    func letComputerHaveATurn(){
        if BoardDelegate.sharedInstance.computerPlayerIsActive && BoardDelegate.sharedInstance.whoseTurn == .O {
            BoardDelegate.sharedInstance.computerSelection()
        }
    }
    
    
    func computerSelection(){
        
        BoardDelegate.sharedInstance.lockSelectionForComputersTurn = true
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            BoardDelegate.sharedInstance.lockSelectionForComputersTurn = false
            let computersChoice = self.HAL9000.chooseTile()
            let results = BoardDelegate.sharedInstance.executeSelection(computersChoice)
            self.displayAlertBasedOnWinResults(results)
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
            default:
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
            Sounds.sharedInstance.booSound?.play()
            return true
        }
        return false
    }
    
    
    
    func displayAlertBasedOnWinResults(results:WinResults) {
        switch results {
        case .WinnerX:
            alertMessage(title: "Game Over", message: "X Wins")
            break
        case .WinnerO:
            alertMessage(title: "Game Over", message: "O Wins")
            break
        case .EndOfTurns:
            alertMessage(title:"Game Over", message: "No one wins")
            break
        case .Error:
            alertMessage(title: "Error", message: "You broke the system!!")
            break
        default:
            break
        }
    }
    
    func alertMessage(title title:String, message:String){
        guard let myViewController = controllingView else {return}
        
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: .Default) { (UIAlertAction) -> Void in
            Sounds.sharedInstance.stopAllSounds()
            BoardDelegate.sharedInstance.resetBoard()
        }
        alert.addAction(okay)
        myViewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Utility Function
    func aRandomTile(allCollectedTiles:[Int], var rangeToSelectFrom:[Int]) -> Int {
        
        var randomIndex = Int(arc4random_uniform(UInt32(rangeToSelectFrom.count)))
        while allCollectedTiles.contains(rangeToSelectFrom[randomIndex]) {
            randomIndex = Int(arc4random_uniform(UInt32(rangeToSelectFrom.count)))
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

