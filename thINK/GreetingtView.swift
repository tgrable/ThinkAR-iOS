//
//  GreetingView.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class GreetingView: UITextView {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        self.frame = rect
        self.font =  UIFont(name: "Helvetica Neue", size: 19)
        
        // Adjust the opening font size and frame if the phone is scaled down too far to display the text
        if appDelegate.screenWidth == 320 {
            self.font =  UIFont(name: "Helvetica Neue", size: 15)
            self.frame.size.height =  240
        }
    
    }
    
}
