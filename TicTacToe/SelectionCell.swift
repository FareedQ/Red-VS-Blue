//
//  selectionCell.swift
//  TicTacToe
//
//  Created by FareedQ on 2016-01-19.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AVFoundation

class SelectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    func animateTextCommingIn(){
        label.alpha = 0
        label.transform = CGAffineTransformMakeScale(0.3, 0.3)
        UIView.animateWithDuration(0.3, animations: {
            self.label.alpha = 1
            self.label.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }) { (completed) -> Void in
                if !completed { NSLog("Something went wrong with the button pressed animation", "")}
                else {
                    UIView.animateWithDuration(0.1, animations: {
                        self.label.transform = CGAffineTransformMakeScale(1, 1)
                    })
                }
        }
    }
}