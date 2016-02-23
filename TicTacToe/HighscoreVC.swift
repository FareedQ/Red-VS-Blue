//
//  HighscoreVC.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-22.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AudioToolbox

class HighscoreVC: UIViewController {

    weak var myMainVC:MainVC?
    
    @IBOutlet weak var backButton: UILabel!
    
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var hardScore: UILabel!
    @IBOutlet weak var mediumScore: UILabel!
    @IBOutlet weak var easyScore: UILabel!
    @IBOutlet weak var resetScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGuestureRecongizers()
        displayScores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupGuestureRecongizers(){
        
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "pressGesture:")
        pressGestureRecognizer.minimumPressDuration = 0
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "edgeGesture:")
        edgeGesture.edges = .Right
        pressGestureRecognizer.requireGestureRecognizerToFail(edgeGesture)
        
        view.addGestureRecognizer(pressGestureRecognizer)
        view.addGestureRecognizer(edgeGesture)
        
    }
    
    func pressGesture(sender: UIPanGestureRecognizer){
        let touch = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            PeekMain(touch)
            break
        case .Ended:
            touchUpBack(touch)
            touchResetScore(touch)
            break
        default:
            break
        }
    }
    
    func edgeGesture(sender: UIScreenEdgePanGestureRecognizer){
        guard let actualMainVC = myMainVC else {return}
        actualMainVC.animateClosingHighScore()
    }
    
    func PeekMain(touch:CGPoint) {
        guard let actualMainVC = myMainVC else {return}
        
        if backButton.frame.contains(touch) {
            actualMainVC.animatePeekingMainFromHighscore()
        }
    }
    
    func touchUpBack(touch:CGPoint) {
        guard let actualMainVC = myMainVC else {return}
        
        if backButton.frame.contains(touch) {
            actualMainVC.animateClosingHighScore()
        } else {
            actualMainVC.animateOpeningHighScore()
        }
    }
    
    
    func touchResetScore(touch:CGPoint) {
        if resetScore.frame.contains(touch) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            
            let alert = UIAlertController(title: "Caution", message: "This operation will reset the high score board and is not reversable", preferredStyle: .Alert)
            let save = UIAlertAction(title: "Okay", style: .Default) {
                (alertAction:UIAlertAction) -> Void in
                HighScore.sharedInstance.resetAllScores()
                self.displayScores()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .Default) { (UIAlertAction) -> Void in
            }
            alert.addAction(save)
            alert.addAction(cancel)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func displayScores(){
        playerScore.text = "\(HighScore.sharedInstance.getData(.PlayerX)) -  \(HighScore.sharedInstance.getData(.PlayerO))"
        hardScore.text = "\(HighScore.sharedInstance.getData(.HardPlayer)) -  \(HighScore.sharedInstance.getData(.HardComputer))"
        mediumScore.text = "\(HighScore.sharedInstance.getData(.MediumPlayer)) -  \(HighScore.sharedInstance.getData(.MediumComputer))"
        easyScore.text = "\(HighScore.sharedInstance.getData(.EasyPlayer)) -  \(HighScore.sharedInstance.getData(.EasyComputer))"
        
    }
    
}
