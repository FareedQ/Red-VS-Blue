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
        if segue.identifier == "exitSegue" && resetBoardUponReturn {
            BoardDelegate.sharedInstance.resetBoard()
        }
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
            //PeekMain(touch)
            break
        case .Ended:
            togglePlayer(touch)
            toggleSound(touch)
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
            actualMainVC.animatePeekingMain()
        }
    }
    
    func togglePlayer(touch:CGPoint) {
        if playerLabelOutlet.frame.contains(touch) || playerResultLabelOutlet.frame.contains(touch) {
            if BoardDelegate.sharedInstance.computerPlayerIsActive {
                playerResultLabelOutlet.text = "2"
                BoardDelegate.sharedInstance.computerPlayerIsActive = false
                hardLabel.textColor = UIColor.grayColor()
                mediumLabel.textColor = UIColor.grayColor()
                easyLabel.textColor = UIColor.grayColor()
            } else {
                playerResultLabelOutlet.text = "1"
                BoardDelegate.sharedInstance.computerPlayerIsActive = true
                hardLabel.textColor = UIColor.greenColor()
                mediumLabel.textColor = UIColor.whiteColor()
                easyLabel.textColor = UIColor.whiteColor()
            }
        }
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
    
    func touchResetScore(touch:CGPoint) {
        if resetScoreLabel.frame.contains(touch) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            
        let alert = UIAlertController(title: "Caution", message: "This operation will reset the high score board and is not reversable", preferredStyle: .Alert)
        let save = UIAlertAction(title: "Okay", style: .Default) {
            (alertAction:UIAlertAction) -> Void in
            //TODO: Need to erase NSUserDefaults of high score
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
