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
    
    @IBOutlet weak var computerWinsLabel: UILabel!
    
    @IBOutlet weak var playerWinsLabel: UILabel!
    
    weak var mySettingVC:SettingsVC?
    
    @IBOutlet weak var visualBoard: UICollectionView!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var settingMenuContraint: NSLayoutConstraint!
    @IBOutlet weak var resetLabel: UILabel!
    
    
    
    //MARK: Override UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.sharedInstance.setupBoard(self)
        setupGuestureRecongizers()
        updateScoreLabels()
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
    
    var touchedSettings = false
    var confirmedOpenSettings = false
    var firstTouchPonit = CGPoint()
    
    func setupGuestureRecongizers(){
        
        
        let LongPressGuesture = UILongPressGestureRecognizer(target: self, action: "pressGuestures:")
        LongPressGuesture.minimumPressDuration = 0
        
        guard let gestures = visualBoard.gestureRecognizers else { return }
        for gesture in gestures {
            view.removeGestureRecognizer(gesture)
        }
        
        let edgeGuesture = UIScreenEdgePanGestureRecognizer(target: self, action: "edgeGuesture:")
        edgeGuesture.edges = .Right
        LongPressGuesture.requireGestureRecognizerToFail(edgeGuesture)
        
        view.addGestureRecognizer(LongPressGuesture)
        view.addGestureRecognizer(edgeGuesture)
    }
    
    func pressGuestures(sender: UILongPressGestureRecognizer){
        let touch = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            peekSetting(touch)
            selectBoard(sender, touchInView: touch)
            touchDownResetLabel(touch)
            break
            
        case .Changed:
            touchMovedLeft(touch)
            break
            
        case .Ended:
            openSetting()
            touchUpResetLabel(touch)
            break
            
        default:
            break
        }
    }
    
    func edgeGuesture(sender: UIScreenEdgePanGestureRecognizer){
        animateOpeningSettings()
    }
    
    func peekSetting(touch:CGPoint){
        if settingsButtonOutlet.frame.contains(touch) {
            touchedSettings = true
            firstTouchPonit = touch
            animatePeekingSettings()
        }
    }
    
    func selectBoard(sender:UILongPressGestureRecognizer, touchInView:CGPoint){
        if visualBoard.frame.contains(touchInView) {
            let locationInCollectionView = sender.locationInView(visualBoard)
            guard let indexPath = visualBoard.indexPathForItemAtPoint(locationInCollectionView) else {return}
            Game.sharedInstance.selectItemOnBoard(indexPath)
        }
    }
    
    func touchDownResetLabel(touch:CGPoint){
        if resetLabel.frame.contains(touch){
            resetLabel.alpha = 0.5
        }
    }
    
    func touchMovedLeft(touch:CGPoint){
        if touchedSettings {
            settingMenuContraint.constant = (touch.x - view.frame.width)
            if touch.x < firstTouchPonit.x {
                confirmedOpenSettings = true
            } else {
                confirmedOpenSettings = false
            }
        }
    }
    
    func openSetting(){
        if touchedSettings {
            if confirmedOpenSettings {
                animateOpeningSettings()
            } else {
                animateClosingSetting()
            }
        }
        confirmedOpenSettings = false
        touchedSettings = false
    }
    
    func touchUpResetLabel(touch:CGPoint){
        resetLabel.alpha = 1
        if resetLabel.frame.contains(touch){
            performReset()
        }
    }
    
    func animateClosingSetting() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = 0
            self.view.layoutIfNeeded()
        })
        updateScoreLabels()
    }
    
    func animatePeekingSettings() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -40
            self.view.layoutIfNeeded()
        })
    }
    
    func animatePeekingMain() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -self.view.frame.width + 40
            self.view.layoutIfNeeded()
        })
    }
    
    func animateOpeningSettings() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: Shake Gestures
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            performReset()
        }
    }
    
    func performReset(){
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        Game.sharedInstance.resetBoard()
    }
    
    //MARK: Override CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Game.sharedInstance.tilesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let thisCell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionCell", forIndexPath: indexPath) as? SelectionCell else {return UICollectionViewCell() }
        
        thisCell.layer.borderWidth = 1
        thisCell.label.text = ""
        thisCell.layer.borderColor = UIColor.whiteColor().CGColor
        
        Game.sharedInstance.setupTiles(indexPath.row)
        
        return thisCell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let mySize = CGSize(
                width: collectionView.bounds.size.width/CGFloat(Game.sharedInstance.tilesPerRow),
                height: collectionView.bounds.size.width/CGFloat(Game.sharedInstance.tilesPerRow))
            
            return mySize
    }
    
    //MARK: Animations
    func displayPlayer(tileId:Int){
        let indexPath = NSIndexPath(forItem: tileId, inSection: 0)
        guard let thisCell = visualBoard.cellForItemAtIndexPath(indexPath) as? SelectionCell else {return}
        
        switch Game.sharedInstance.whoseTurn {
        case .X:
            thisCell.label.text = "X"
            Sounds.sharedInstance.xSound?.currentTime = 0
            Sounds.sharedInstance.xSound?.play()
            break
        case .O:
            thisCell.label.text = "O"
            Sounds.sharedInstance.oSound?.currentTime = 0
            Sounds.sharedInstance.oSound?.play()
            break
        default:
            break
        }
        
        thisCell.animateTextCommingIn()
    }
    
    func updateScoreLabels(){
        var returnPlayerWinsString = "Player : "
        var returnComputerWinsString = "Computer : "
            if !Game.sharedInstance.computerPlayerIsActive {
                returnPlayerWinsString = "Player X : " + String(HighScore.sharedInstance.getData(.PlayerX))
            } else {
                switch Game.sharedInstance.difficultyFlag {
                case .Hard:
                    returnPlayerWinsString += String(HighScore.sharedInstance.getData(.HardPlayer))
                    break
                case .Medium:
                    returnPlayerWinsString += String(HighScore.sharedInstance.getData(.MediumPlayer))
                    break
                case .Easy:
                    returnPlayerWinsString += String(HighScore.sharedInstance.getData(.EasyPlayer))
                    break
                default:
                    break
                }
            }
            if !Game.sharedInstance.computerPlayerIsActive {
                returnComputerWinsString = "Player O : " + String(HighScore.sharedInstance.getData(.PlayerO))
            } else {
                switch Game.sharedInstance.difficultyFlag {
                case .Hard:
                    returnComputerWinsString += String(HighScore.sharedInstance.getData(.HardComputer))
                    break
                case .Medium:
                    returnComputerWinsString += String(HighScore.sharedInstance.getData(.MediumComputer))
                    break
                case .Easy:
                    returnComputerWinsString += String(HighScore.sharedInstance.getData(.EasyComputer))
                    break
                default:
                    break
                }
            }
        playerWinsLabel.text = returnPlayerWinsString
        computerWinsLabel.text = returnComputerWinsString
    }
}