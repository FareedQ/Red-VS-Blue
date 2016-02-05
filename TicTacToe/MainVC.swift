//
//  ViewController.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-01-19.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AudioToolbox

class MainVC: UIViewController {
    
    
    @IBOutlet weak var visualBoard: UICollectionView!
    
    //MARK IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    let myBoard = Board()
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue) {
    }
    
    //MARK overrideUIViewControllerFunctions
    override func viewDidLoad() {
        super.viewDidLoad()
        BoardDelegate.sharedInstance.setup(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("mainVC did recieve a memory warning", "")
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBoard.board.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let thisCell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionCell", forIndexPath: indexPath) as? SelectionCell else {return UICollectionViewCell() }
        setupTilesInCollectionView(thisCell, indexPathRow: indexPath.row)
        return thisCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if BoardDelegate.sharedInstance.lockSelectionForComputersTurn {return}
        
        //Player's selection
        playerSelection(indexPath)
        
        //Computer's selection
        if BoardDelegate.sharedInstance.computerPlayerIsActive && BoardDelegate.sharedInstance.whoseTurn == .O {
            BoardDelegate.sharedInstance.computerSelection()
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let mySize = CGSize(width: collectionView.bounds.size.width/3, height: collectionView.bounds.size.width/3)
            return mySize
    }
}

extension MainVC {
    func playerSelection(indexPath:NSIndexPath){
        guard let thisCell = collectionView.cellForItemAtIndexPath(indexPath) as? SelectionCell else {return}
        if (thisCell.imageView.image == nil) {
            let results = BoardDelegate.sharedInstance.executeSelection(thisCell)
            displayAlertBasedOnWinResults(results)
        }
    }
    
    func displayAlertBasedOnWinResults(results:WinResults) {
        switch results {
        case .WinnerX:
            alertMessage(title: "Game Over", message: "Blue Player Wins")
            break
        case .WinnerO:
            alertMessage(title: "Game Over", message: "Red Player Wins")
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
    
    func setupTilesInCollectionView(tile:SelectionCell, indexPathRow:Int){
        tile.imageView.image = nil
        tile.layer.borderColor = UIColor.blackColor().CGColor
        tile.layer.borderWidth = 1
        tile.id = convertIndexPathRowToTileId(indexPathRow)
    }
    
    //Needed to show alerts
    func alertMessage(title title:String, message:String){
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: .Default) { (UIAlertAction) -> Void in
            Sounds.sharedInstance.stopAllSounds()
            BoardDelegate.sharedInstance.resetBoard()
        }
        alert.addAction(okay)
        self.presentViewController(alert, animated: true, completion: nil)
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