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
        ["A1","A2","A3"],
        ["B1","B2","B3"],
        ["C1","C2","C3"],
        ["A1","B2","C3"],
        ["A3","B2","C1"],
        ["A1","B1","C1"],
        ["A2","B2","C2"],
        ["A3","B3","C3"]]
    
    
    //MARK: CalculatedParameters
    var collectedTiles: [String]{
        get {
            var returnTiles = [String]()
            for mytile in memoryBoard.board {
                if mytile.1.player != .None {
                    returnTiles.append(mytile.0)
                }
            }
            return returnTiles
        }
    }
    
    //MARK: Functions
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
        var playersCollectedArray = [String]()
        for tileId in collectedTiles {
            guard let tile = memoryBoard.board[tileId] else {return false}
            if tile.player == whoseTurn {
                playersCollectedArray.append(tileId)
            }
        }
        let playercollectedSet = Set(playersCollectedArray)
        
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
    
    //Chooses a random selected tile
    func aRandomTile(allCollectedTiles:[String], var rangeToSelectFrom:[String]) -> String {
        
        var randomIndex = Int(arc4random_uniform(UInt32(rangeToSelectFrom.count)))
        while allCollectedTiles.contains(rangeToSelectFrom[randomIndex]) {
            randomIndex = Int(arc4random_uniform(4))
        }
        return rangeToSelectFrom[randomIndex]
    }
    
    func getARandomCenterTile() -> String {
        if BoardDelegate.sharedInstance.isACenterTileAvaliable() {
            return aRandomTile(collectedTiles, rangeToSelectFrom:memoryBoard.centerTiles)
        }
        return ""
    }
    
    func getARandomCornerTile() -> String {
        if BoardDelegate.sharedInstance.isACornerTileAvaliable() {
            return BoardDelegate.sharedInstance.aRandomTile(BoardDelegate.sharedInstance.collectedTiles, rangeToSelectFrom:BoardDelegate.sharedInstance.memoryBoard.cornerTiles)
        }
        return ""
    }
    
    func getARandomTile() -> String {
        return BoardDelegate.sharedInstance.aRandomTile(BoardDelegate.sharedInstance.collectedTiles, rangeToSelectFrom:BoardDelegate.sharedInstance.memoryBoard.allTiles)
    }
    
    func whoHasClaimed(tileId:String) -> Player {
        guard let tile = BoardDelegate.sharedInstance.memoryBoard.board[tileId] else {return .None}
        return tile.player
    }
    
    func whoHasClaimedThisSet(tileIdArray:[String]) -> [Player] {
        var playerArray = [Player]()
        for tileId in tileIdArray {
            playerArray.append(whoHasClaimed(tileId))
        }
        return playerArray
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
            let indexPathRow = self.convertTileIdToIndexPathRow(self.HAL.aggressivelyTakeTileSelection())
            guard let actualtile = myVisualBoard.cellForItemAtIndexPath(NSIndexPath(forRow: indexPathRow, inSection: 0)) as? SelectionCell else { return }
            let results = BoardDelegate.sharedInstance.executeSelection(actualtile)
            myControllingView.displayAlertBasedOnWinResults(results)
        })
    }
    
    
    
    //Used to make the code more readable
    func convertIndexPathRowToTileId(indexPathRow:Int) -> String {
        switch indexPathRow {
        case 0...2:
            return "A\(indexPathRow+1)"
        case 3...5:
            return "B\((indexPathRow%3)+1)"
        case 6...9:
            return "C\((indexPathRow%3)+1)"
        default:
            return ""
        }
    }
    
    
    func convertTileIdToIndexPathRow(tileId:String) -> Int {
        switch tileId {
        case "A1":
            return 0
        case "A2":
            return 1
        case "A3":
            return 2
        case "B1":
            return 3
        case "B2":
            return 4
        case "B3":
            return 5
        case "C1":
            return 6
        case "C2":
            return 7
        case "C3":
            return 8
        default:
            return 0
        }
    }
}

