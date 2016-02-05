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
    
    //MARK: CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return BoardDelegate.sharedInstance.tilesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let thisCell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionCell", forIndexPath: indexPath) as? SelectionCell else {return UICollectionViewCell() }
        
        thisCell.id = indexPath.row
        thisCell.layer.borderWidth = 1
        thisCell.imageView.image = nil
        thisCell.layer.borderColor = UIColor.blackColor().CGColor
        BoardDelegate.sharedInstance.setupTilesInMemory(thisCell)
        
        return thisCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if BoardDelegate.sharedInstance.lockSelectionForComputersTurn {return}
        
        if (BoardDelegate.sharedInstance.whoHasClaimed(indexPath.row) == .None) {
            guard let thisCell = collectionView.cellForItemAtIndexPath(indexPath) as? SelectionCell else {return}
            
            let results = BoardDelegate.sharedInstance.executeSelection(thisCell)
            displayAlertBasedOnWinResults(results)
        }
        
        BoardDelegate.sharedInstance.letComputerHaveATurn()
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let mySize = CGSize(
                width: collectionView.bounds.size.width/CGFloat(BoardDelegate.sharedInstance.tilesPerRow),
                height: collectionView.bounds.size.width/CGFloat(BoardDelegate.sharedInstance.tilesPerRow))
            
            return mySize
    }
    
    //MARK:Alerts
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
}