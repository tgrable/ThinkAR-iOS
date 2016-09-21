//
//  HomeViewController.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/20/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, MenuProtocol {
    
    // IBOutlets
    @IBOutlet weak var greeting: GreetingView?
    @IBOutlet weak var backgroudImage: UIImageView?
    @IBOutlet weak var logoImage: UIImageView?
    @IBOutlet weak var hamburgerButton: UIButton?
    @IBOutlet weak var goButton: GoButton?
    
    // Custom classes
    var menu = Menu()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var think2016 = Think2016()
    var aboutThink = AboutThink()
    var contactThink = ContactThink()
    var privacy = Privacy()
    var downloadMarker = DownloadMarker()
    
    // Data
    var subViewIndex = 0
    var animateViews = false
    var subviewPresent = false
    var subviews = [BaseUIView]()
    
    // Now a property and not a function
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Background and in-focus notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(HomeViewController.appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(HomeViewController.appMovedToFocus), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // Add all view classes to the subviews array
        // The order here is important
        subviews.append(think2016)
        subviews.append(aboutThink)
        subviews.append(contactThink)
        subviews.append(downloadMarker)
        subviews.append(privacy)
        
        // Custom delegates attached to the this view controller for the specific class
        //downloadMarker.printDelegate = self

        
        // The very last item in the view controller
        menu.frame = CGRect(x:-2048, y: 46, width: appDelegate.screenWidth, height:appDelegate.screenHeight)
        menu.delegate = self
        self.view.addSubview(menu)
    }
    
    //
    // ViewWillDisappear
    //
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        // Remove all registered notifications on this view so multiples are not attached
        NotificationCenter.default.removeObserver(self)
    }

    //
    //
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Background / Focus Functions
    //
    // NSNotification callback for when an app moves from focus into the background
    // This usually means that the app was in focus and being used and the user exits the app
    //
    func appMovedToBackground() {
        
        print("App moved to background!")
        // Clean up anything before the app goes into the background
    }
    
    //
    // NSNotification callback for when an app moves from the background into focus
    // This usually means coming from the home screen and opening the app back up
    //
    func appMovedToFocus() {
        
        print("App moved to focus!")
        
    }
    
    // MARK: Go Action
    //
    // Takes a user to the AR Browser
    //
    @IBAction func goAction(sender: UIButton!) {
        
        self.performSegue(withIdentifier: "HomeToARBrowser", sender: self)
    }

    // MARK: Menu Functionality
    //
    // The hamburger action to open and close the menu
    // @param sender : UIButton
    //      The button triggering this action.
    //
    @IBAction func menuAction(sender: UIButton) {
        
        var x = 0
        let width: CGFloat = CGFloat(appDelegate.screenWidth)
        let height: CGFloat = CGFloat(appDelegate.screenHeight)
        
        // If the menu x value is at 0 then we know it is open and we need to set it to a negative value
        if menu.frame.origin.x == 0 {
            // Make sure that if closing the menu that the x variable is over 100 pixels negative
            x = Int(width - (width * 2.5))
        }
        
        // Bring menu to front of view stack
        self.view.bringSubview(toFront: menu)
        
        // Reflow the menu subviews to be centered before the menu opens
        menu.rebuildMenuLayout(width: width, height: CGFloat(appDelegate.screenHeight))
        
        weak var weakSelf = self
        // Perform the animation
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseOut, animations: {
            weakSelf!.menu.frame = CGRect(x:x, y: 45, width:Int(width), height:Int(height))
            }, completion: { finished in
                if weakSelf!.animateViews {
                    weakSelf!.animateViews = false
                    weakSelf!.switchViews()
                }
        })
    }
    
    //
    // Global function to switch the view with changing the view controller
    //
    func switchViews() {
        
        if subViewIndex == 10 {
            // Moving out to the AR Browser
            self.performSegue(withIdentifier: "HomeToARBrowser", sender: self)
        } else  {
            greeting?.alpha = 0.0
            backgroudImage?.alpha = 0.0
            logoImage?.alpha = 0.0
            goButton?.alpha = 0.0
            // Remove any present subviews
            for bv in self.view.subviews {
                if bv.tag == 11 {
                    bv.removeFromSuperview()
                }
            }
            
            // Any other subview inheriting from BaseUIView
            if subViewIndex < subviews.count {
                let selectedSubview: BaseUIView = subviews[subViewIndex]
                selectedSubview.setIndex(index: subViewIndex)
                selectedSubview.reflowLayout(width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view.addSubview(selectedSubview)
                subviewPresent = true
            }
        }
    }
    
    // MARK: Menu delegate callback
    //
    // Route the app to the appropriate menu item selected
    // MenuProtocol function
    //
    func menuItemSelected(item: Int) {
        
        subViewIndex = item
        animateViews = true
        // Close the menu
        menuAction(sender: hamburgerButton!)
    }
    
    func swipeClose() {
        
        // If the x value on the menu is less than zero return and do not do anything
        if menu.frame.origin.x == 0 {
            menuAction(sender: hamburgerButton!)
        }
    }
}
