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
    var unityView = UnityGetGLView()
    var menu = Menu()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Data
    var subViewIndex = 0
    var animateViews = false
    var subviewPresent = false
    var infoPressed = false
    var subviews = [BaseUIView]()
    var imageMarkers = [String]()
    
    // Timer
    var timer = Timer()
    var timePaused = true
    
    // Winner Views
    var winnerBackgroundView: UIView?
    var winnerCloseButton: UIButton?
    var winnerImageView: UIImageView?
    var winnerLabel: UILabel?
    
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
        
        
        unityView?.frame = CGRect(x:0, y: 0, width: appDelegate.screenWidth, height: appDelegate.screenHeight)
        unityView?.tag = 20
        parentUnityView!.addSubview(unityView!)
        unityView?.translatesAutoresizingMaskIntoConstraints = false
        
        // The very last item in the view controller
        menu.frame = CGRect(x:-2048, y: 46, width: appDelegate.screenWidth, height:appDelegate.screenHeight)
        menu.delegate = self
        self.view.addSubview(menu)

        // Set off timer
        timerSetup()
        
        // Winner view stack
        winnerBackgroundView = UIView(frame: CGRect(x: 0, y: appDelegate.screenHeight, width: appDelegate.screenWidth, height: appDelegate.screenHeight))
        winnerBackgroundView?.backgroundColor = UIColor.clear
        
        let winLogo: UIImage = UIImage(named: "img-instantWin")!
        winnerImageView = UIImageView(image: winLogo)
        winnerImageView!.contentMode = UIViewContentMode.scaleAspectFill
        winnerImageView!.clipsToBounds = true
        winnerImageView!.frame = CGRect(x: (appDelegate.screenWidth / 2 - 113), y: (appDelegate.screenHeight / 2 - 131), width: 227, height: 218)
        winnerBackgroundView?.addSubview(winnerImageView!)
        
        winnerLabel = UILabel(frame: CGRect(x: 52, y: 125, width: 125, height: 55))
        winnerLabel!.textAlignment = NSTextAlignment.center
        winnerLabel!.text = "You’re An Instant Winner! Claim your prize at the Canon Solutions America area"
        winnerLabel!.numberOfLines = 4
        winnerLabel!.backgroundColor = UIColor.clear
        winnerLabel!.textColor = UIColor.white
        winnerLabel!.font =  UIFont(name: "Helvetica Neue", size: 10)
        winnerImageView!.addSubview(winnerLabel!)
        
        winnerCloseButton = UIButton(frame: CGRect(x: (appDelegate.screenWidth - 48), y: 8, width: 32, height: 32))
        winnerCloseButton!.backgroundColor =  UIColor.clear
        let close: UIImage = UIImage(named: "x-mark")!
        winnerCloseButton?.setImage(close, for: .normal)
        winnerCloseButton?.touchAreaEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10)
        winnerCloseButton!.addTarget(self, action: #selector(closeWinnerView), for: .touchUpInside)
        winnerBackgroundView!.addSubview(winnerCloseButton!)
        
        self.view.addSubview(winnerBackgroundView!)
    
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
        
    }
    
    //
    // Close winner view that pops up over the AR Browser
    //
    func closeWinnerView() {
        
        var yVal = 44
        
        if (winnerBackgroundView?.frame.origin.y)! == 44.00 {
            yVal = appDelegate.screenHeight
        }
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf!.winnerBackgroundView!.frame.origin.y = CGFloat(yVal)
            }, completion: {
                (value: Bool) in
        })
    }
    
    
    // MARK: Timer Actions
    //
    // Sets up new or invalidates a time to check if a target is being scanned or if a target is a winner
    //
    func timerSetup() {
        
        if timePaused {
            // Get an updated set of image markers than have been scanned
            imageMarkers = appDelegate.partners!.getListOfScannedPartners()
            
            // Create a timer to detect if there is a winner or if an item is being
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(targetDetection), userInfo: nil, repeats: true)
            timePaused = false
        } else {
            timer.invalidate()
            timePaused = true
        }
    }
    
    //
    // Callback for the timer running to detect if there is a partner being scanned and if a target is a winner
    //
    func targetDetection() {
        
        
        // Make sure that a marker is not scanned while the browser is in the background
        if !timePaused {
            print ("Winner text: \(appDelegate.currentUnityController.winner)")
            print ("Possible text: \(appDelegate.currentUnityController.scannedTarget)")
        
            if (appDelegate.currentUnityController.scannedTarget) != nil {
                let imageTarget = appDelegate.currentUnityController.scannedTarget!
                // Make sure that partner target has not already been scanned
                if !imageMarkers.contains(imageTarget) {
                    if (appDelegate.partners?.updatePartnerObject(imageTargetName: imageTarget))! {
                        // Update the imageMarkers array
                        imageMarkers.append(imageTarget)
                    }
                }
            }
            
            // Perform winner action
            if let winnerText = appDelegate.currentUnityController.winner {
                if winnerText == "true"{
                    // Display Winner
                    if (winnerBackgroundView?.frame.origin.y)! == CGFloat(appDelegate.screenHeight) {
                        closeWinnerView()
                        appDelegate.currentUnityController.winner = "false"
                    }
                }
            }
        }
    }
    
    //
    // NSNotification callback for when an app moves from the background into focus
    // This usually means coming from the home screen and opening the app back up
    //
    func appMovedToFocus() {
        
        parentUnityView!.alpha = 1.0
        
        // Remove any menu views
        for bv in self.view.subviews {
            if bv.tag == 11 {
                bv.removeFromSuperview()
            }
        }
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
        
        // Remove any present subviews
        for bv in self.view.subviews {
            if bv.tag == 11 {
                bv.removeFromSuperview()
            }
        }
        
        if subViewIndex == 10 {
            
            // Make sure Unity sound does fire up in the background
            appDelegate.soundOn(flag: true)

            // Moving from background window to the ARBrowser
            parentUnityView!.alpha = 1.0
            
            timePaused = true
            // Update the timer accordingly
            timerSetup()
            // Hide info
            setInfoAsClosed()
            
        } else  {
            
            if !timePaused {
                // Update the timer accordingly
                timerSetup()
            }

            // Hide background views
            parentUnityView!.alpha = 0.0
            // Any other subview inheriting from BaseUIView
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
            } else {
                subviewPresent = false
            }
            
            // Make sure Unity sound does not fire up in the background
            appDelegate.soundOn(flag: false)
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
    
    //
    // Swipe gesture close callback
    //
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
    // Send an email with the default email client
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
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
