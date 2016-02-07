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
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "pullSettings:")
        gestureRecognizer.minimumPressDuration = 0
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        guard let gestures = collectionView.gestureRecognizers else { return }
        for gesture in gestures {
            gestureRecognizer.requireGestureRecognizerToFail(gesture)
        }
    }
    
    var touchedSettings = false
    var openSettings = false
    var beginningTouch = CGPoint()
    func pullSettings(sender: UIPanGestureRecognizer){
        let touch = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            if settingsButtonOutlet.frame.contains(touch) {
                touchedSettings = true
                beginningTouch = touch
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.settingMenuContraint.constant = -40
                    self.view.layoutIfNeeded()
                })
            }
            if visualBoard.frame.contains(touch) {
                let locationInCollectionView = sender.locationInView(visualBoard)
                guard let indexPath = visualBoard.indexPathForItemAtPoint(locationInCollectionView) else {return}
                BoardDelegate.sharedInstance.selectItemOnBoard(indexPath)
            }
            break
        case .Changed:
            if touchedSettings {
                settingMenuContraint.constant = (touch.x - view.frame.width)
                if touch.x < beginningTouch.x {
                    openSettings = true
                } else {
                    openSettings = false
                }
            }
            break
        case .Ended:
            if touchedSettings {
                touchedSettings = false
                if openSettings {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.settingMenuContraint.constant = -self.view.frame.width
                        self.view.layoutIfNeeded()
                    })
                } else {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.settingMenuContraint.constant = 0
                        self.view.layoutIfNeeded()
                    })
                }
                openSettings = false
            }
            break
        default:
            break
        }
        
    }
    
    func animateClosingSetting() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animateSettingsPeekStart() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingMenuContraint.constant = -self.view.frame.width + 40
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animateSettingsPeekEnd() {
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