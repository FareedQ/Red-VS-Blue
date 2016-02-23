//
//  SettingsVC.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-02.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AudioToolbox

class SettingsVC: UIViewController {

    weak var myMainVC:MainVC?
    
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    @IBOutlet weak var soundLabelOutlet: UILabel!
    @IBOutlet weak var soundResultLabelOutlet: UILabel!
    @IBOutlet weak var playerLabelOutlet: UILabel!
    @IBOutlet weak var playerResultLabelOutlet: UILabel!
    @IBOutlet weak var backLabelOutlet: UILabel!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var hardLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var easyLabel: UILabel!
    @IBOutlet weak var resetScoreLabel: UILabel!
    var resetBoardUponReturn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGuestureRecongizers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    //MARK: GuestureRecongizer
    var firstTouchPonit = CGPoint()
    
    func setupGuestureRecongizers(){
        
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "pressGesture:")
        pressGestureRecognizer.minimumPressDuration = 0
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "edgeGesture:")
        edgeGesture.edges = .Left
        pressGestureRecognizer.requireGestureRecognizerToFail(edgeGesture)
        
        view.addGestureRecognizer(pressGestureRecognizer)
        view.addGestureRecognizer(edgeGesture)
        
    }
    
    func pressGesture(sender: UIPanGestureRecognizer){
        let touch = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            resetContraints()
            PeekMain(touch)
            break
        case .Ended:
            togglePlayer(touch)
            toggleSound(touch)
            touchDifficulty(touch)
            touchResetScore(touch)
            touchBackLabel(touch)
            break
        default:
            break
        }
    }
    
    func PeekMain(touch:CGPoint) {
        guard let actualMainVC = myMainVC else {return}
        
        if backLabelOutlet.frame.contains(touch) {
            actualMainVC.animatePeekingMainFromSettings()
        }
    }
    
    func togglePlayer(touch:CGPoint) {
        if playerLabelOutlet.frame.contains(touch) || playerResultLabelOutlet.frame.contains(touch) {
            if Game.sharedInstance.computerPlayerIsActive {
                playerResultLabelOutlet.text = "2"
                Game.sharedInstance.computerPlayerIsActive = false
                toggleDifficultySelection()
            } else {
                playerResultLabelOutlet.text = "1"
                Game.sharedInstance.computerPlayerIsActive = true
                toggleDifficultySelection()
            }
        }
    }
    
    func toggleDifficultySelection(){
        if Game.sharedInstance.computerPlayerIsActive == false {
            hardLabel.textColor = UIColor.grayColor()
            mediumLabel.textColor = UIColor.grayColor()
            easyLabel.textColor = UIColor.grayColor()
            return
        } else {
            hardLabel.textColor = UIColor.whiteColor()
            mediumLabel.textColor = UIColor.whiteColor()
            easyLabel.textColor = UIColor.whiteColor()
        }
        
        if Game.sharedInstance.difficultyFlag == .Hard {
            hardLabel.textColor = UIColor.greenColor()
        } else if Game.sharedInstance.difficultyFlag == .Medium {
            mediumLabel.textColor = UIColor.greenColor()
        } else if Game.sharedInstance.difficultyFlag == .Easy {
            easyLabel.textColor = UIColor.greenColor()
        }
        
        resetBoardUponReturn = true
    }
    
    func toggleSound(touch:CGPoint) {
        if soundLabelOutlet.frame.contains(touch) || soundResultLabelOutlet.frame.contains(touch) {
            if Sounds.sharedInstance.soundState {
                soundResultLabelOutlet.text = "OFF"
            } else {
                soundResultLabelOutlet.text = "ON"
            }
            Sounds.sharedInstance.toggleSounds()
        }
    }
    
    func touchDifficulty(touch:CGPoint) {
        if Game.sharedInstance.computerPlayerIsActive == false { return }
        if hardLabel.frame.contains(touch) {
            Game.sharedInstance.difficultyFlag = .Hard
        } else if mediumLabel.frame.contains(touch) {
            Game.sharedInstance.difficultyFlag = .Medium
        } else if easyLabel.frame.contains(touch) {
            Game.sharedInstance.difficultyFlag = .Easy
        }
        toggleDifficultySelection()
    }
    
    func touchResetScore(touch:CGPoint) {
        if resetScoreLabel.frame.contains(touch) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            
        let alert = UIAlertController(title: "Caution", message: "This operation will reset the high score board and is not reversable", preferredStyle: .Alert)
        let save = UIAlertAction(title: "Okay", style: .Default) {
            (alertAction:UIAlertAction) -> Void in
            HighScore.sharedInstance.resetAllScores()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (UIAlertAction) -> Void in
        }
        alert.addAction(save)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func touchBackLabel(touch:CGPoint) {
        guard let actualMainVC = myMainVC else {return}
        
        if backLabelOutlet.frame.contains(touch) {
            actualMainVC.animateClosingSetting()
        } else {
            actualMainVC.animateOpeningSettings()
        }
    }
    
    func edgeGesture(sender: UIScreenEdgePanGestureRecognizer){
        guard let actualMainVC = myMainVC else {return}
        actualMainVC.animateClosingSetting()
    }
    
    //MARK: Utilites
    
    //For some reason the contraints animate after text is changed on the view.
    //This hack is in place to make the unknown animation not seem as obvious.
    func resetContraints(){
        leadingContraint.constant = 8
        topContraint.constant = 3
        view.layoutIfNeeded()
    }
    
}
