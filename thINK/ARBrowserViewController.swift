//
//  ARBrowserViewController.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/20/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit
import MessageUI

class ARBrowserViewController: UIViewController, MenuProtocol, MarkerProtocol, CustomButtonProtocol, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var parentUnityView: UIView?
    @IBOutlet weak var hamburgerButton: UIButton?
    @IBOutlet weak var infoButton: UIButton?
    
    // Custom classes
    //var unityView = UnityGetGLView()
    var menu = Menu()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var think2016 = Think2016()
    var aboutThink = AboutThink()
    var contactThink = ContactThink()
    //var privacy = Privacy()
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

        // Setup notification to close menu if it is open
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ARBrowserViewController.appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ARBrowserViewController.appMovedToFocus), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // Add all view classes to the subviews array
        // The order here is important
        subviews.append(think2016)
        subviews.append(aboutThink)
        subviews.append(contactThink)
        subviews.append(downloadMarker)
        //subviews.append(privacy)
        
        infoButton?.layer.cornerRadius = 11
        infoButton?.layer.borderColor = UIColor.white.cgColor
        infoButton?.layer.borderWidth = 2.0
        infoButton?.alpha = 0.0
        
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
        NotificationCenter.default.removeObserver(self)
    }
    
    //
    // DidReceiveMemoryWarning
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
        /* Commented out for future development */
    }
    
    //
    // NSNotification callback for when an app moves from the background into focus
    // This usually means coming from the home screen and opening the app back up
    //
    func appMovedToFocus() {
        
        print("App moved to focus!")
        
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
    
    // MARK: Navbar Info Functionality
    //
    // The info action to pop open the overlay on how to play the game when thINK 2016 is present
    // @param sender : UIButton
    //      The button triggering this action.
    //
    @IBAction func infoAction(sender: UIButton) {
        
        print("Hello")
    }
    
    //
    // Global function to switch the view with changing the view controller
    //
    func switchViews() {
        
        // Remove any present subviews
        for bv in self.view.subviews {
            if bv.tag == 11 {
                bv.removeFromSuperview()
            }
        }
        if subViewIndex == 10 {
            // Moving from background window to the ARBrowser
            parentUnityView!.alpha = 1.0
            
        } else  {
            // Hide background views
            parentUnityView!.alpha = 0.0
            // Any other subview inheriting from BaseUIView
            if subViewIndex < subviews.count {
                let selectedSubview: BaseUIView = subviews[subViewIndex]
                selectedSubview.setIndex(index: subViewIndex)
                selectedSubview.reflowLayout(width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view.addSubview(selectedSubview)
                subviewPresent = true
            } else {
                subviewPresent = false
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
    
    
    // MARK: Call thINK - Custom button delegate functions
    //
    //
    //
    func callthINK(scheme: String) {
        
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    // MARK: Open Privacy Statement - Custom button delegate functions
    //
    //
    //
    /*
     func openPrivacyStatement(url: String) {
     
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
    */
    // MARK: Contact Delegate Functions
    // MARK: Call thINK - Custom button delegate functions
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
    //
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
    //
    //
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
