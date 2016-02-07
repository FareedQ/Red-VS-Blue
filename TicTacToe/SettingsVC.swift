//
//  SettingsVC.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-02.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    weak var myMainVC:MainVC?
    
    @IBOutlet weak var soundSwitchOutlet: UISwitch!
    @IBOutlet weak var computerSwitchOutlet: UISwitch!
    @IBOutlet weak var backLabelOutlet: UILabel!
    
    var resetBoardUponReturn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        computerSwitchOutlet.on = BoardDelegate.sharedInstance.computerPlayerIsActive
        soundSwitchOutlet.on = Sounds.sharedInstance.soundState
        
        setupGuestureRecongizers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func soundSwitch(sender: UISwitch) {
        Sounds.sharedInstance.toggleSounds()
        
    }
    
    @IBAction func computerSwitch(sender: UISwitch) {
        if sender.on {
            BoardDelegate.sharedInstance.computerPlayerIsActive = true
            resetBoardUponReturn = true
        } else {
            BoardDelegate.sharedInstance.computerPlayerIsActive = false
            resetBoardUponReturn = true
        }
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
        guard let actualMainVC = myMainVC else {return}
        let touch = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            if backLabelOutlet.frame.contains(touch) {
                actualMainVC.animatePeekingMain()
            }
            break
        case .Ended:
            if backLabelOutlet.frame.contains(touch) {
                actualMainVC.animateClosingSetting()
            } else {
                actualMainVC.animateOpeningSettings()
            }
            break
        default:
            break
        }
    }
    
    func edgeGesture(sender: UIScreenEdgePanGestureRecognizer){
        guard let actualMainVC = myMainVC else {return}
        actualMainVC.animateClosingSetting()
    }
    
}
