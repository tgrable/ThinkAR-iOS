//
//  HomeViewController.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/20/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit
import MessageUI

class HomeViewController: UIViewController, MenuProtocol, MarkerProtocol, CustomButtonProtocol, MFMailComposeViewControllerDelegate {
    
    // IBOutlets
    @IBOutlet weak var greeting: GreetingView?
    @IBOutlet weak var backgroudImage: UIImageView?
    @IBOutlet weak var logoImage: UIImageView?
    @IBOutlet weak var hamburgerButton: UIButton?
    @IBOutlet weak var goButton: GoButton?
    @IBOutlet weak var infoButton: UIButton?
    
    // Custom classes
    var menu = Menu()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Data
    var subViewIndex = 0
    var animateViews = false
    var subviewPresent = false
    var infoPressed = false
    var subviews = [BaseUIView]()
    
    // Now a property and not a function
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure Unity sound does not fire up in the background
        appDelegate.soundOn(flag: false)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Background and in-focus notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(HomeViewController.appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(HomeViewController.appMovedToFocus), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // Add all view classes to the subviews array
        // The order here is important
        subviews.append(appDelegate.think2016!)
        subviews.append(appDelegate.aboutThink!)
        subviews.append(appDelegate.contactThink!)
        subviews.append(appDelegate.downloadMarker!)
        
        // Custom delegates attached to the this view controller for the specific class
        appDelegate.downloadMarker?.printDelegate = self
        appDelegate.contactThink?.customContactDelegate = self

        infoButton?.alpha = 0.0
        let info = UIImage(named: "info") as UIImage?
        infoButton?.setImage(info, for: .normal)
        infoButton?.touchAreaEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10)
        
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
        
        // Clean up anything before the app goes into the background
    }
    
    //
    // NSNotification callback for when an app moves from the background into focus
    // This usually means coming from the home screen and opening the app back up
    //
    func appMovedToFocus() {
        
    }
    
    // MARK: Go Action
    //
    // Takes a user to the AR Browser
    //
    @IBAction func goAction(sender: UIButton!) {
        
        // Make sure Unity sound does fire up in the background
        appDelegate.soundOn(flag: true)
        
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
        } else {
            setInfoAsClosed()
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
    
    // MARK: Navbar Info Functionality
    //
    // The info action to pop open the overlay on how to play the game when thINK 2016 is present
    // @param sender : UIButton
    //      The button triggering this action.
    //
    @IBAction func infoAction(sender: UIButton) {
        
        if !infoPressed {
            let close = UIImage(named: "x-mark") as UIImage?
            infoButton?.setImage(close, for: .normal)
            infoPressed = true
            appDelegate.think2016?.animateHowToPlay(yVal:Int(0.0))
        } else {
            let info = UIImage(named: "info") as UIImage?
            infoButton?.setImage(info, for: .normal)
            infoPressed = false
            appDelegate.think2016?.animateHowToPlay(yVal:Int(appDelegate.screenHeight))
        }
    }
    
    //
    // Global function to switch the view with changing the view controller
    //
    func switchViews() {
        
        if subViewIndex == 10 {
            // Make sure Unity sound does fire up in the background
            appDelegate.soundOn(flag: true)
            setInfoAsClosed()
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
            
            if subViewIndex < subviews.count {
                
                let selectedSubview: BaseUIView = subviews[subViewIndex]
                selectedSubview.setIndex(index: subViewIndex)
                selectedSubview.reflowLayout(width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                // Reload the partner data
                if subViewIndex == 0 {
                    appDelegate.reloadPartnerData()
                    infoButton?.alpha = 1.0
                    appDelegate.think2016?.addProgressView()
                } else {
                    setInfoAsClosed()
                }
                
                self.view.addSubview(selectedSubview)
                subviewPresent = true
            } 
        }
    }
    
    //
    // Function to hide the close button in multiple places
    //
    func setInfoAsClosed() {
        
        infoButton?.alpha = 0.0
        let info = UIImage(named: "info") as UIImage?
        infoButton?.setImage(info, for: .normal)
        infoPressed = true
        appDelegate.think2016?.animateHowToPlay(yVal:Int(appDelegate.screenHeight))
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
    
    // MARK: Print Delegate Callback
    //
    // MarkerProtocol callback function that displays a status to the user on their print job
    //
    func printJobCallback(flag: Int) {
        
        // Build a message based upon the flag
        var message = "Print job was sent successfully"
        if flag == 1 {
            message = "Print job failed, please make sure your printer connects to AirPrint"
        } else if flag == 2 {
            message = "Print job was canceled"
        }
        
        // Create an alert view
        let alert = UIAlertController(title: "Print Status", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: Contact thINK - Custom button delegate functions
    //
    // Contact thINK URL Callback
    //
    func contactthINK(url: String) {
        
        if let url = URL(string: url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(url): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(url): \(success)")
            }
        }
    }
    
    // MARK: Email thINK - Custom button delegate functions
    //
    // Actually performs the action of sending the email
    //
    func emailthINK(email: String) {
        
        let mailComposeViewController = configuredMailComposeViewController(email: email)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: alertUserSuccess)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    // MARK: Send Email Functions
    //
    // Compose an email to be sent using the default email client
    //
    func configuredMailComposeViewController(email: String) -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
 
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("Contact Submission From thINK iOS App")
        
        let emailString = "Contact submission from the thINK iOS Application \n"
        mailComposerVC.setMessageBody(emailString, isHTML: false)
        
        return mailComposerVC
    }
    
    //
    // This function calls back to the view controller to notify of a successful submission
    //
    func alertUserSuccess() {
        
        let alert = UIAlertController(title: "Email Sent", message: "Your email was sent off to Solimar", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //
    // This function calls back to the view controller to notify of an issue with submission
    //
    func alertUserIssue(message: String) {
        
        // Create an alert view
        let alert = UIAlertController(title: "Contact Submission Issue", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //
    // Show an error if the email could not be sent
    //
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //
    // MARK: MFMailComposeViewControllerDelegate Method
    //
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
