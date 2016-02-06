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
    
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var visualBoard: UICollectionView!
    weak var mySettingVC:SettingsVC?
    
    //MARK IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue) {
    }
    @IBOutlet weak var settingMenuContraint: NSLayoutConstraint!
    
    //MARK: Override UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        BoardDelegate.sharedInstance.setup(self)
        setupGuestureRecongizers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("mainVC did recieve a memory warning", "")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueSettings" {
            guard let tempVC = segue.destinationViewController as? SettingsVC else {return}
            mySettingVC = tempVC
            mySettingVC?.myMainVC = self
        }
    }
    
    //MARK: GuestureRecongizer
    func setupGuestureRecongizers(){
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "pullSettings:")
        gestureRecognizer.minimumPressDuration = 0
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    var touchedSettings = false
    var openSettings = false
    var beginningTouch = CGPoint()
    func pullSettings(sender: UIPanGestureRecognizer){
        let touch = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            if settingsButtonOutlet.frame.contains(touch) {
                touchedSettings = true
                beginningTouch = touch
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.settingMenuContraint.constant = -40
                    self.view.layoutIfNeeded()
                })
            }
            if visualBoard.frame.contains(touch) {
                let locationInCollectionView = sender.locationInView(visualBoard)
                guard let indexPath = visualBoard.indexPathForItemAtPoint(locationInCollectionView) else {return}
                selectItemOnBoard(indexPath)
            }
            break
        case .Changed:
            if touchedSettings {
                settingMenuContraint.constant = (touch.x - view.frame.width)
                if touch.x < beginningTouch.x {
                    openSettings = true
                } else {
                    openSettings = false
                }
            }
            break
        case .Ended:
            if touchedSettings {
                touchedSettings = false
                if openSettings {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.settingMenuContraint.constant = -self.view.frame.width
                        self.view.layoutIfNeeded()
                    })
                } else {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.settingMenuContraint.constant = 0
                        self.view.layoutIfNeeded()
                    })
                }
                openSettings = false
            }
            break
        default:
            break
        }
        
    }
    
    func animateClosingSetting() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animateSettingsPeekStart() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -self.view.frame.width + 40
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animateSettingsPeekEnd() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return BoardDelegate.sharedInstance.tilesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let thisCell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionCell", forIndexPath: indexPath) as? SelectionCell else {return UICollectionViewCell() }
        
        thisCell.layer.borderWidth = 1
        thisCell.imageView.image = nil
        thisCell.layer.borderColor = UIColor.blackColor().CGColor
        
        thisCell.id = indexPath.row
        BoardDelegate.sharedInstance.setupTilesInMemory(thisCell)
        var TILEPERROW = BoardDelegate.sharedInstance.tilesPerRow
        
        thisCell.neighbourTopLeft = indexPath.row - TILEPERROW - 1
        thisCell.neighbourTopMiddle = indexPath.row - TILEPERROW
        thisCell.neighbourTopRight = indexPath.row - TILEPERROW + 1
        thisCell.neighbourMiddleLeft = indexPath.row - 1
        thisCell.neighbourMiddleRight = indexPath.row + 1
        thisCell.neighbourBottomLeft = indexPath.row + TILEPERROW - 1
        thisCell.neighbourBottomMiddle = indexPath.row + TILEPERROW
        thisCell.neighbourBottomRight = indexPath.row + TILEPERROW + 1
        
        func setupTilesInMemory(tile:SelectionCell){
            guard let tileId = tile.id else {return}
            
            if(tileId%TILEPERROW == 0 || tileId%TILEPERROW == TILEPERROW-1){
                if(tileId/TILEPERROW == 0 || tileId/TILEPERROW == TILEPERROW-1){
                    thisCell.tile = Tile(type: .Corner, player: .None)
                } else {
                    thisCell.tile = Tile(type: .Edge, player: .None)
                }
            } else {
                if(tileId/TILEPERROW == 0 || tileId/TILEPERROW == TILEPERROW-1){
                    thisCell.tile = Tile(type: .Edge, player: .None)
                } else {
                    thisCell.tile = Tile(type: .Center, player: .None)
                }
            }
        }
        
        return thisCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectItemOnBoard(indexPath)
        
    }
    
    //Needed to have this function called directly after guesture recongizers were added to the page
    func selectItemOnBoard(indexPath:NSIndexPath){
        if BoardDelegate.sharedInstance.lockSelectionForComputersTurn {return}
        
        if (BoardDelegate.sharedInstance.whoHasClaimed(indexPath.row) == .None) {
            guard let thisCell = visualBoard.cellForItemAtIndexPath(indexPath) as? SelectionCell else {return}
            
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