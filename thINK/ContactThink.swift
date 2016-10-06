//
//  ContactThink.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class ContactThink: BaseUIView, UIScrollViewDelegate {
    
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
        
        labelHeaderViewOne = UILabel(frame: CGRect(x: 20, y: 25, width: frame.size.width, height: 30))
        labelHeaderViewOne!.textAlignment = NSTextAlignment.center
        labelHeaderViewOne!.text = "Contact thINK"
        labelHeaderViewOne!.textColor = UIColor(red: 64.0/255.0, green: 154.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        labelHeaderViewOne!.font =  UIFont(name: "Helvetica Neue", size: 26)
        scrollview!.addSubview(labelHeaderViewOne!)
        
        bodyCopyView = UITextView(frame: CGRect(x: 18, y: 70, width: (frame.size.width - 80), height: 300))
        bodyCopyView!.backgroundColor = UIColor.clear
        bodyCopyView!.isEditable = false
        bodyCopyView!.textColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        bodyCopyView!.isScrollEnabled = false
        bodyCopyView!.font =  UIFont(name: "Helvetica Neue", size: 18)
        bodyCopyView!.textAlignment = NSTextAlignment.center
        bodyCopyView!.text = "The thINK Executive Director and Board Members welcome your input, questions, and comments. Would you like to share your ideas, opinions, and best practices with the community? Do you have suggestions for a blog post, educational session, or community resource that will help you grow your business? Have a question about how you can get involved? \n\n Please tap the button below to get in contact with us."
        scrollview!.addSubview(bodyCopyView!)
        
        bottomButtonOne = UIButton(frame: CGRect(x: 20, y: 375, width: frame.size.width, height: 30))
        bottomButtonOne!.backgroundColor =  UIColor.clear
        bottomButtonOne!.setTitle("Contact Us", for: [])
        bottomButtonOne!.setTitleColor(UIColor(red: 64.0/255.0, green: 154.0/255.0, blue: 158.0/255.0, alpha: 1.0), for: [])
        bottomButtonOne!.titleLabel?.textAlignment = NSTextAlignment.center
        bottomButtonOne!.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 22)
        bottomButtonOne!.tag = 4
        bottomButtonOne!.addTarget(self, action: #selector(contactUsButtonPressed), for: .touchUpInside)
        scrollview!.addSubview(bottomButtonOne!)
    
        
        let blackLogo: UIImage = UIImage(named: "img-think-logo-black")!
        bottomLogo = UIImageView(image: blackLogo)
        bottomLogo!.contentMode = UIViewContentMode.scaleAspectFill
        bottomLogo!.clipsToBounds = true
        bottomLogo!.frame = CGRect(x: (frame.size.width / 2 - 60), y: (frame.size.height - 140), width: 122, height: 36)
        scrollview!.addSubview(bottomLogo!)
        
        bottomLabel = UILabel(frame: CGRect(x: 20, y: (frame.size.height - 89), width: frame.size.width, height: 22))
        bottomLabel!.textAlignment = NSTextAlignment.center
        bottomLabel!.text = "© 2016 thINK"
        bottomLabel!.textColor = UIColor.black
        bottomLabel!.font =  UIFont(name: "Helvetica Neue", size: 12)
        scrollview!.addSubview(bottomLabel!)
        
        scrollview!.contentSize = CGSize(width: frame.size.width, height: frame.size.height)
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
    func contactUsButtonPressed(sender: UIButton!) {
        
        customContactDelegate?.contactthINK(url: "http://thinkconference.thinkforum.com/contact")
    }
}
