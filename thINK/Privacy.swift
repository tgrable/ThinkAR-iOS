//
//  Privacy.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class Privacy: BaseUIView, UIScrollViewDelegate {
    
    weak var customContactDelegate:CustomButtonProtocol?
    
    // MARK: UIView Methods
    //
    // Declaration of the UIView init method
    // Make sure this view has a tag of 11 on it so it can be removed when needed to by the UIViewController using it
    //
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.tag = 11
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        scrollview = UIScrollView(frame: UIScreen.main.bounds)
        scrollview!.delegate = self
        
        labelHeaderViewOne = UILabel(frame: CGRect(x: 40, y: 95, width: frame.size.width, height: 70))
        labelHeaderViewOne!.textAlignment = NSTextAlignment.left
        labelHeaderViewOne!.numberOfLines = Int(2.0)
        labelHeaderViewOne!.text = "Privacy Statement Regarding Customer and Online User Information"
        labelHeaderViewOne!.textColor = UIColor(red: 64.0/255.0, green: 154.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        labelHeaderViewOne!.font =  UIFont(name: "Helvetica Neue", size: 24)
        scrollview!.addSubview(labelHeaderViewOne!)
        
        bodyCopyView = UITextView(frame: CGRect(x: 38, y: 345, width: (frame.size.width - 80), height: 250))
        bodyCopyView!.font =  UIFont(name: "OpenSans", size: 18)
        bodyCopyView!.isEditable = false
        bodyCopyView!.isScrollEnabled = false
        bodyCopyView!.textAlignment = NSTextAlignment.center
        bodyCopyView!.text = "This Privacy Statement governs Personal Information we collect from anyone who downloads and runs the think AR application (\"you\"), as well as information we automatically collect from online visits (data collected via cookies). That includes, but is not limited to the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, mobile operating system you use, and information about the way you use the Application. \n\n By using this application, you are consenting to our processing of your information as set forth in this Privacy Policy now and as amended by us. \"Processing,\" means using cookies on a computer/hand held device or using or touching information in any way, including, but not limited to collecting, storing, deleting, using, combining, and disclosing information."
        scrollview!.addSubview(bodyCopyView!)
        
        bottomButtonOne = UIButton(frame: CGRect(x: 40, y: 145, width: frame.size.width, height: 40))
        bottomButtonOne!.backgroundColor =  UIColor.clear
        bottomButtonOne!.setTitle("View the complete Privacy statement", for: [])
        bottomButtonOne!.setTitleColor(UIColor(red: 64.0/255.0, green: 154.0/255.0, blue: 158.0/255.0, alpha: 1.0), for: [])
        bottomButtonOne!.titleLabel?.textAlignment = NSTextAlignment.center
        bottomButtonOne!.titleLabel!.font =  UIFont(name: "OpenSans", size: 22)
        bottomButtonOne!.tag = 4
        bottomButtonOne!.addTarget(self, action: #selector(privacyButtonPressed), for: .touchUpInside)
        scrollview!.addSubview(bottomButtonOne!)
        
        scrollview!.contentSize = CGSize(width: frame.size.width, height: 1050)
        self.addSubview(scrollview!)

    }
    
    //
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    //
    //
    func privacyButtonPressed(sender: UIButton!) {
        
    }
}
