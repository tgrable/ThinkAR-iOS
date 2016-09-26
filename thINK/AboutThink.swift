//
//  AboutThink.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class AboutThink: BaseUIView, UIScrollViewDelegate {
    
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
        
        let header: UIImage = UIImage(named: "img-hdrWarm")!
        bannerView = UIImageView(image: header)
        bannerView!.contentMode = UIViewContentMode.scaleAspectFill
        bannerView!.clipsToBounds = true
        bannerView!.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 200)
        scrollview!.addSubview(bannerView!)
        
        let logo: UIImage = UIImage(named: "img-think-logo-white")!
        bannerLogoView = UIImageView(image: logo)
        bannerLogoView!.frame = CGRect(x: 20, y: 65, width: 245, height: 72)
        bannerView!.addSubview(bannerLogoView!)
        
        labelHeaderViewOne = UILabel(frame: CGRect(x: 20, y: 245, width: 280, height: 30))
        labelHeaderViewOne!.textAlignment = NSTextAlignment.left
        labelHeaderViewOne!.text = "Headline Placeholder"
        labelHeaderViewOne!.textColor = UIColor(red: 64.0/255.0, green: 154.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        labelHeaderViewOne!.font =  UIFont(name: "Helvetica Neue", size: 26)
        scrollview!.addSubview(labelHeaderViewOne!)
        
        labelHeaderViewTwo = UILabel(frame: CGRect(x: 20, y: 285, width: 280, height: 30))
        labelHeaderViewTwo!.textAlignment = NSTextAlignment.left
        labelHeaderViewTwo!.text = "Subhead Placeholder"
        labelHeaderViewTwo!.textColor = UIColor(red: 64.0/255.0, green: 154.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        labelHeaderViewTwo!.font =  UIFont(name: "Helvetica Neue", size: 22)
        scrollview!.addSubview(labelHeaderViewTwo!)
        
        bodyCopyView = UITextView(frame: CGRect(x: 18, y: 335, width: (frame.size.width - 40), height: 350))
        bodyCopyView!.isEditable = false
        bodyCopyView!.isScrollEnabled = false
        bodyCopyView!.font =  UIFont(name: "Helvetica Neue", size: 18)
        bodyCopyView!.text = "Aliquam sed augue tincidunt, suscipit velit nec, malesuada mauris. Phasellus ac lacus est. Nam eu erat a nibh sagittis venenatis eget sed elit. Aliquam tincidunt nisi vel augue gravida, vel lacinia nisl varius. Praesent pretium varius nulla atviverra."
        scrollview!.addSubview(bodyCopyView!)
        
        scrollview!.contentSize = CGSize(width: frame.size.width, height: 750)
        self.addSubview(scrollview!)
        
    }
    
    //
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
