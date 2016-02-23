//
//  HighscoreVC.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-22.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class HighscoreVC: UIViewController {

    weak var myMainVC:MainVC?
    
    @IBOutlet weak var backButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGuestureRecongizers()
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
    
}
