//
//  SettingsVC.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-02-02.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var soundSwitchOutlet: UISwitch!
    @IBOutlet weak var computerSwitchOutlet: UISwitch!
    
    var AIchanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        computerSwitchOutlet.on = BoardDelegate.sharedInstance.computerPlayerIsActive
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func soundSwitch(sender: UISwitch) {
        
    }
    
    @IBAction func computerSwitch(sender: UISwitch) {
        if sender.on {
            BoardDelegate.sharedInstance.computerPlayerIsActive = true
            AIchanged = true
        } else {
            BoardDelegate.sharedInstance.computerPlayerIsActive = false
            AIchanged = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exitSegue" && AIchanged {
            BoardDelegate.sharedInstance.resetBoard()
        }
    }
    
}
