//
//  ViewController.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-01-19.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AudioToolbox

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        BoardDelegate.sharedInstance.setupBoard(self)
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
        
        let LongPressGuesture = UILongPressGestureRecognizer(target: self, action: "pullSettings:")
        LongPressGuesture.minimumPressDuration = 0
        
        guard let gestures = collectionView.gestureRecognizers else { return }
        for gesture in gestures {
            LongPressGuesture.requireGestureRecognizerToFail(gesture)
        }
        
        self.view.addGestureRecognizer(LongPressGuesture)
        
        
    }
    
    var touchedSettings = false
    var openSettings = false
    var beginningTouch = CGPoint()
    func pullSettings(sender: UILongPressGestureRecognizer){
        let touch = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            peekSetting(touch)
            selectBoard(sender, touchInView: touch)
            break
        case .Changed:
                touchMovedLeft(touch)
        case .Ended:
            if touchedSettings {
                if openSettings {
                    animateOpenSettings()
                } else {
                    animateCloseSetting()
                }
            }
            openSettings = false
            touchedSettings = false
            break
        default:
            break
        }
        
    }
    
    func touchMovedLeft(touch:CGPoint){
        settingMenuContraint.constant = (touch.x - view.frame.width)
        if touch.x < beginningTouch.x {
            openSettings = true
        } else {
            openSettings = false
        }
    }
    
    func peekSetting(touch:CGPoint){
        if settingsButtonOutlet.frame.contains(touch) {
            touchedSettings = true
            beginningTouch = touch
            animatePeekSettings()
        }
    }
    
    func selectBoard(sender:UILongPressGestureRecognizer, touchInView:CGPoint){
        if visualBoard.frame.contains(touchInView) {
            let locationInCollectionView = sender.locationInView(visualBoard)
            guard let indexPath = visualBoard.indexPathForItemAtPoint(locationInCollectionView) else {return}
            BoardDelegate.sharedInstance.selectItemOnBoard(indexPath)
        }
    }
    
    func animateCloseSetting() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animatePeekSettings() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -40
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animateOpenSettings() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: Override CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BoardDelegate.sharedInstance.tilesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let thisCell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionCell", forIndexPath: indexPath) as? SelectionCell else {return UICollectionViewCell() }
        
        thisCell.layer.borderWidth = 1
        thisCell.imageView.image = nil
        thisCell.layer.borderColor = UIColor.blackColor().CGColor
        
        BoardDelegate.sharedInstance.setupTiles(indexPath.row)
        
        return thisCell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let mySize = CGSize(
                width: collectionView.bounds.size.width/CGFloat(BoardDelegate.sharedInstance.tilesPerRow),
                height: collectionView.bounds.size.width/CGFloat(BoardDelegate.sharedInstance.tilesPerRow))
            
            return mySize
    }
    
    //MARK: Animations
    func displayPlayer(tileId:Int){
        let indexPath = NSIndexPath(forItem: tileId, inSection: 0)
        guard let thisCell = visualBoard.cellForItemAtIndexPath(indexPath) as? SelectionCell else {return}
        
        switch BoardDelegate.sharedInstance.whoseTurn {
        case .X:
            thisCell.imageView.image = UIImage(named: "blue")
            break
        case .O:
            thisCell.imageView.image = UIImage(named: "red")
            break
        default:
            break
        }
        
        thisCell.animateTextCommingIn()
    }
}