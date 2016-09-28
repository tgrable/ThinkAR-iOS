//
//  Menu.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class Menu: UIView {

    // The menu delegate
    weak var delegate:MenuProtocol?
    
    // MenuView child views
    var parentScroll = UIScrollView()
    // Container for the menu
    var menuContainer = UIView()

    // Image Views
    var thinkImageView = UIImageView()
    var bottomLabel = UILabel()
    // Arrays used to adjust the width of the dividers
    var dividerViews = [UIView]()
    var buttonViews = [UIButton]()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // Set the background color
        self.backgroundColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipe.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipe)
        
        // Setup default values for the parent scroll, not the final display values though
        parentScroll.frame = CGRect(x: 0, y: 0, width: 280, height: (frame.size.height - 40))
        parentScroll.backgroundColor = UIColor.clear
        self.addSubview(parentScroll)
        
        // Setup default values for the menu container
        menuContainer.frame = CGRect(x: 0, y: 10, width: 280, height: 293)
        menuContainer.backgroundColor = UIColor.clear
        parentScroll.addSubview(menuContainer)
        
        // Setup the bottons and dividers that will go in the menu conainer
        // The widths used are not the final widths used during display
        
        
        let arBrowser = UIButton(frame: CGRect(x: 0, y: 10, width: 280, height: 28))
        arBrowser.backgroundColor = UIColor.clear
        arBrowser.setTitle("AR Browser", for: [])
        arBrowser.setTitleColor(UIColor.white, for: [])
        arBrowser.titleLabel?.textAlignment = NSTextAlignment.center
        arBrowser.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 22)
        arBrowser.tag = 10
        arBrowser.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        menuContainer.addSubview(arBrowser)
        buttonViews.append(arBrowser)
        
        let arDivider = UIView(frame: CGRect(x: 0, y: 48, width: 280, height: 1))
        arDivider.backgroundColor = UIColor.white
        menuContainer.addSubview(arDivider)
        dividerViews.append(arDivider)
        
        let think2016 = UIButton(frame: CGRect(x: 0, y: 59, width: 280, height: 28))
        think2016.backgroundColor = UIColor.clear
        think2016.setTitle("thINK 2016", for: [])
        think2016.setTitleColor(UIColor.white, for: [])
        think2016.titleLabel?.textAlignment = NSTextAlignment.center
        think2016.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 22)
        think2016.tag = 0
        think2016.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        menuContainer.addSubview(think2016)
        buttonViews.append(think2016)
        
        let think2016Divider = UIView(frame: CGRect(x: 0, y: 97, width: 280, height: 1))
        think2016Divider.backgroundColor = UIColor.white
        menuContainer.addSubview(think2016Divider)
        dividerViews.append(think2016Divider)
        
        let aboutThink = UIButton(frame: CGRect(x: 0, y: 108, width: 280, height: 28))
        aboutThink.backgroundColor = UIColor.clear
        aboutThink.setTitle("About thINK", for: [])
        aboutThink.setTitleColor(UIColor.white, for: [])
        aboutThink.titleLabel?.textAlignment = NSTextAlignment.center
        aboutThink.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 22)
        aboutThink.tag = 1
        aboutThink.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        menuContainer.addSubview(aboutThink)
        buttonViews.append(aboutThink)
        
        let aboutThinkDivider = UIView(frame: CGRect(x: 0, y: 146, width: 280, height: 1))
        aboutThinkDivider.backgroundColor = UIColor.white
        menuContainer.addSubview(aboutThinkDivider)
        dividerViews.append(aboutThinkDivider)
        
        let contactThink = UIButton(frame: CGRect(x: 0, y: 157, width: 280, height: 28))
        contactThink.backgroundColor = UIColor.clear
        contactThink.setTitle("Contact thINK", for: [])
        contactThink.setTitleColor(UIColor.white, for: [])
        contactThink.titleLabel?.textAlignment = NSTextAlignment.center
        contactThink.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 22)
        contactThink.tag = 2
        contactThink.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        menuContainer.addSubview(contactThink)
        buttonViews.append(contactThink)
        
        let contactThinkDivider = UIView(frame: CGRect(x: 0, y: 195, width: 280, height: 1))
        contactThinkDivider.backgroundColor = UIColor.white
        menuContainer.addSubview(contactThinkDivider)
        dividerViews.append(contactThinkDivider)
        
        let doanloadMarker = UIButton(frame: CGRect(x: 0, y: 206, width: 280, height: 28))
        doanloadMarker.backgroundColor = UIColor.clear
        doanloadMarker.setTitle("Download a Marker", for: [])
        doanloadMarker.setTitleColor(UIColor.white, for: [])
        doanloadMarker.titleLabel?.textAlignment = NSTextAlignment.center
        doanloadMarker.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 22)
        doanloadMarker.tag = 3
        doanloadMarker.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        menuContainer.addSubview(doanloadMarker)
        buttonViews.append(doanloadMarker)
        

        // Create a Solimar ImageView
        let thinkLogoImage: UIImage = UIImage(named: "img-think-logo-white")!
        thinkImageView = UIImageView(image: thinkLogoImage)
        thinkImageView.frame = CGRect(x: 15, y: 400, width: 245, height: 72)
        parentScroll.addSubview(thinkImageView)
        
        // Bottom label for copyright purposes
        bottomLabel = UILabel(frame: CGRect(x: 15, y: 480, width: 245, height: 15))
        bottomLabel.textAlignment = NSTextAlignment.center
        bottomLabel.text = "© 2016 thINK"
        bottomLabel.textColor = UIColor.white
        bottomLabel.font =  UIFont(name: "Helvetica Neue", size: 12)
        parentScroll.addSubview(bottomLabel)
        
        // Set a default content height
        parentScroll.contentSize.height = 620;
    }
    
    //
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                delegate!.swipeClose()
                
            default:
                break
            }
        }
    }
    
    // MARK: Menu action central callback
    //
    // Central action for all menu buttons in the menu
    // @param sender
    //      The button in the menu that was tapped
    //
    func menuAction(sender: UIButton) {
        
        delegate!.menuItemSelected(item: sender.tag)
    }
    
    // MARK: Reflow the menu based upon landscape or portrait orientation
    //
    // Rebuild the menu layout based upon the height and width of the screen
    // @param width: CGFloat
    //      The width of the incoming screen
    // @param height: CGFloat
    //      The height of the incoming screen
    //
    func rebuildMenuLayout(width: CGFloat, height: CGFloat) {
        
        // Make the width variable mutable
        let width = width
       
        // Set and inside width to ensure that padding is respected
        let insideWidth = (width - 40)
        // Setup scrollview frame values
        parentScroll.frame = CGRect(x: 20, y: 20, width: (width - 40), height: (height - 40))

        //
        // Portrait
        //
        
        // Setup the width of the menu container using inside width
        // Setup the width of the buttons and the dividers using inside width
        menuContainer.frame = CGRect(x: 0, y: 0, width: insideWidth, height: 293)
        for b in buttonViews {
            b.frame = CGRect(x: 0, y: b.frame.origin.y, width: insideWidth, height: 28)
        }
        
        for d in dividerViews {
            d.frame = CGRect(x: 0, y: d.frame.origin.y, width: insideWidth, height: 1)
        }
        
        
       
        thinkImageView.frame = CGRect(x: ((insideWidth - 245) / 2),y:  (height - 200), width: 245, height: 60)
        bottomLabel.frame = CGRect(x: ((insideWidth - 245) / 2), y: (height - 100), width: 245, height: 15)
        // Set the content size height for the scrollview
        parentScroll.contentSize.height = 645;

    }
}
