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
    
    @IBOutlet weak var tilesSegmentedOutlet: UISegmentedControl!
    var resetBoard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        computerSwitchOutlet.on = BoardDelegate.sharedInstance.computerPlayerIsActive
        switch BoardDelegate.sharedInstance.tilesPerRow {
        case 3:
            tilesSegmentedOutlet.selectedSegmentIndex = 0
            break
        case 4:
            tilesSegmentedOutlet.selectedSegmentIndex = 1
            break
        case 5:
            tilesSegmentedOutlet.selectedSegmentIndex = 2
            break
        default:
            break
        }
    }

    @IBAction func selectTiles(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            BoardDelegate.sharedInstance.tilesPerRow = 3
            break
        case 1:
            BoardDelegate.sharedInstance.tilesPerRow = 4
            break
        case 2:
            BoardDelegate.sharedInstance.tilesPerRow = 5
            break
        default:
            break
        }
        resetBoard = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func soundSwitch(sender: UISwitch) {
        
    }
    
    @IBAction func computerSwitch(sender: UISwitch) {
        if sender.on {
            BoardDelegate.sharedInstance.computerPlayerIsActive = true
            resetBoard = true
        } else {
            BoardDelegate.sharedInstance.computerPlayerIsActive = false
            resetBoard = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exitSegue" && resetBoard {
            BoardDelegate.sharedInstance.resetBoard()
        }
    }
    
}
