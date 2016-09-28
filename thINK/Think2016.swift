//
//  Think2016.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit


class Think2016: BaseUIView, UITableViewDelegate {

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
        
        let gameLogo: UIImage = UIImage(named: "img-thinkevent-logo")!
        bannerLogoView = UIImageView(image: gameLogo)
        bannerLogoView!.contentMode = UIViewContentMode.scaleAspectFill
        bannerLogoView!.clipsToBounds = true
        bannerLogoView!.frame = CGRect(x: 20, y: 35, width: 122, height: 90)
        scrollview?.addSubview(bannerLogoView!)
        
        progressView = UIView(frame: CGRect(x: 170, y: 35, width: 147, height: 140))
        progressView?.backgroundColor = UIColor.gray
        scrollview?.addSubview(progressView!)
    
        scrollview!.contentSize = CGSize(width: frame.size.width, height: frame.size.height)
        self.addSubview(scrollview!)
    }
    
    //
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
