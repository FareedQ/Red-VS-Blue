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
    
    @IBOutlet weak var backLabelOutlet: UILabel!
    
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
            PeekMain(touch)
            break
        case .Ended:
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
    
}
