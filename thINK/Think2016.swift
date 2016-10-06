//
//  Think2016.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

// MARK: -
// MARK: Device Detection

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

class Think2016: BaseUIView, UITableViewDelegate, UITableViewDataSource {


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        // Used for thINK 2016 and for how to play
        let gameLogo: UIImage = UIImage(named: "img-thinkevent-logo")!
        
        bannerLogoView = UIImageView(image: gameLogo)
        bannerLogoView!.contentMode = UIViewContentMode.scaleAspectFill
        bannerLogoView!.clipsToBounds = true
        bannerLogoView!.frame = CGRect(x: 20, y: 35, width: 122, height: 90)
        scrollview?.addSubview(bannerLogoView!)
        
        tableHeader = UIView(frame: CGRect(x: 0, y: 200, width: frame.size.width, height: 44))
        tableHeader?.backgroundColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        scrollview?.addSubview(tableHeader!)
        
        tableHeaderStatus = UILabel(frame: CGRect(x: 16, y: 10, width: 65, height: 24))
        tableHeaderStatus!.textAlignment = NSTextAlignment.left
        tableHeaderStatus!.text = "Status"
        tableHeaderStatus!.textColor = UIColor.white
        tableHeaderStatus!.font =  UIFont(name: "Helvetica Neue", size: 22)
        tableHeader!.addSubview(tableHeaderStatus!)
        
        tableHeaderVendor = UILabel(frame: CGRect(x: 140, y: 9, width: 90, height: 26))
        tableHeaderVendor!.textAlignment = NSTextAlignment.left
        tableHeaderVendor!.text = "Vendor"
        tableHeaderVendor!.textColor = UIColor.white
        tableHeaderVendor!.font =  UIFont(name: "Helvetica Neue", size: 24)
        tableHeader!.addSubview(tableHeaderVendor!)
        
        vendorTable = UITableView(frame: CGRect(x: 0, y: 245, width: frame.size.width, height: (frame.size.height - 245)), style: UITableViewStyle.plain)
        vendorTable!.delegate = self
        vendorTable!.dataSource = self
        vendorTable!.register(PartnerTableViewCell.self, forCellReuseIdentifier: "Cell")
        scrollview?.addSubview(vendorTable!)
        
        // How to play View Stack
        howToPlayView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        howToPlayView?.backgroundColor = UIColor.white
        howToPlayView?.alpha = 0.98
        
        let htpLogoView = UIImageView(image: gameLogo)
        htpLogoView.contentMode = UIViewContentMode.scaleAspectFill
        htpLogoView.clipsToBounds = true
        htpLogoView.frame = CGRect(x: 20, y: 35, width: 122, height: 90)
        howToPlayView?.addSubview(htpLogoView)
        
        let htpLogoHeaderLabel = UILabel(frame: CGRect(x: 20, y: 145, width: 280, height: 30))
        htpLogoHeaderLabel.textAlignment = NSTextAlignment.left
        htpLogoHeaderLabel.text = "How To Play The Game"
        htpLogoHeaderLabel.textColor = UIColor(red: 64.0/255.0, green: 154.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        htpLogoHeaderLabel.font =  UIFont(name: "Helvetica Neue", size: 26)
        howToPlayView!.addSubview(htpLogoHeaderLabel)
        
        htpbodyCopyView = UITextView(frame: CGRect(x: 18, y: 195, width:(frame.size.width - 36), height: 340))
        htpbodyCopyView?.isEditable = false
        htpbodyCopyView?.textColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        htpbodyCopyView?.isScrollEnabled = true
        htpbodyCopyView?.font =  UIFont(name: "Helvetica Neue", size: 18)
        let encodedString = "Each partner has a special postcard waiting for you. All of them have an augmented reality experience inside. Some could make you an instant winner.\n\n1.  Collect a greeting at every partner table\n2. Watch the AR experience with the thINK AR app to find out if you are an instant winner\n3. Visit the TREKK booth to get your last greeting and enter the grand prize drawing\n 4. Post about it on social media using the hashtag: #GreetingsfromthINK\n*Grand Prize winners (chosen by random drawing) will be announced Wednesday morning."
        htpbodyCopyView?.text = encodedString
        howToPlayView!.addSubview(htpbodyCopyView!)
        
        scrollview?.addSubview(howToPlayView!)
        
        
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
    func animateHowToPlay(yVal: Int) {
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf!.howToPlayView!.frame.origin.y = CGFloat(yVal)
            }, completion: {
                (value: Bool) in
        })
    }
    
    //
    //
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.partnerData.count
    }
    
    //
    //
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let partnerCell: PartnerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PartnerTableViewCell
        
        if appDelegate.screenWidth > 320 {
            partnerCell.widthValue = 220
        } else {
            partnerCell.widthValue = 170
        }
        partnerCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let row = indexPath.row
        let p: Partner = appDelegate.partnerData[row]
        
        if let cellText = p.name {
            partnerCell.vendorName?.text = cellText
        } 
    
        if p.scanned == 1 {
            let check: UIImage = UIImage(named: "check")!
            partnerCell.status?.image = check
        } else {
            partnerCell.status?.image = nil
        }
        
        return partnerCell
    }

    //
    //
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: -
    // MARK: Progress View
    func addProgressView() {
        
        var count = 0
        
        for i in 0..<appDelegate.partnerData.count {
            let p: Partner = appDelegate.partnerData[i]
            if p.scanned == 1 {
                count += 1
            }
        }
        
        print("***************** Count: \(count) *****************")
        
        let fillPercentage = Float(count) / Float(appDelegate.partnerData.count)
        
        let arcWidth: CGFloat = (progressView?.bounds.width)! / 3
        let center = CGPoint(x: ((progressView?.bounds.width)! / centerfactor()) + xPlacementFactor(), y: ((progressView?.bounds.height)! / centerfactor()) + 15)
        let radius: CGFloat = max((progressView?.bounds.width)! * scalefactor(), (progressView?.bounds.height)! * scalefactor())
        let startAngle: CGFloat = -(CGFloat)(M_PI_2) // 12:00 on the circle or 270 degrees
        let endAngle: CGFloat = CGFloat(M_PI * 2) * CGFloat(fillPercentage) - CGFloat(M_PI_2) // 360 degrees * percentage to fill -
        
        let bottomPath = UIBezierPath(arcCenter: center, radius: radius / 2, startAngle: startAngle, endAngle: CGFloat(360), clockwise: true)
        progressView?.layer.addSublayer(drawACircleOnView(path: bottomPath, arcWidth: arcWidth, color: UIColor.lightGray, fillColor: UIColor.lightGray))
        
        let path = UIBezierPath(arcCenter: center, radius: radius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let teal = UIColor(red: 0.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0)
        progressView?.layer.addSublayer(drawACircleOnView(path: path, arcWidth: arcWidth, color: teal, fillColor: UIColor.clear))
        
        let topPath = UIBezierPath(arcCenter: center, radius: radius / 2, startAngle: startAngle, endAngle: CGFloat(360), clockwise: true)
        progressView?.layer.addSublayer(drawACircleOnView(path: topPath, arcWidth: arcWidth * 0.01, color: UIColor.white, fillColor: UIColor.white))
        
        progressView?.addSubview(addTextToView(string: "\(count)" + " \\ " + "\(appDelegate.partnerData.count)", textColor: teal, textSize: fontFactor()))
    }
    
    //
    //
    //
    func drawACircleOnView(path: UIBezierPath, arcWidth: CGFloat, color: UIColor, fillColor: UIColor) -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = arcWidth
        
        return shapeLayer
    }
    
    //
    //
    //
    func addTextToView(string: String, textColor: UIColor, textSize: CGFloat) -> UILabel {
        
        let rect = CGRect(x: textXPlacementFactor(), y: textYPlacementFactor(), width: 100, height: 50)
        let label = UILabel(frame: rect)
        label.textAlignment = NSTextAlignment.center
        label.textColor = textColor
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(textSize)
        label.text = string
        
        return label
    }
    
    // MARK: -
    // MARK: Placement Helper Methods
    func centerfactor() -> CGFloat{
        if DeviceType.IS_IPHONE_5 {
            return 3
        }
        else {
            return 2
        }
    }
    func scalefactor() -> CGFloat{
        if DeviceType.IS_IPHONE_5 {
            return 0.70
        }
        else if DeviceType.IS_IPHONE_6 {
            return 0.90
        }
        else if DeviceType.IS_IPHONE_6P {
            return 1.0
        }
        else {
            return 1.0
        }
    }
    
    func xPlacementFactor() -> CGFloat {
        if DeviceType.IS_IPHONE_5 {
            return 15.0
        }
        else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
            return 25.0
        }
        else {
            return 25.0
        }
        
    }
    
    func textXPlacementFactor() -> CGFloat {
        if DeviceType.IS_IPHONE_5 {
            return ((progressView?.bounds.width)! / 2) - 60.0
        }
        else if DeviceType.IS_IPHONE_6 {
            return ((progressView?.bounds.width)! / 2) - 20.0
        }
        else if DeviceType.IS_IPHONE_6P {
            return ((progressView?.bounds.width)! / 2) - 25.0
        }
        else {
            return ((progressView?.bounds.width)! / 2) - 20.0
        }
    }
    
    func textYPlacementFactor() -> CGFloat {
        if DeviceType.IS_IPHONE_5 {
            return ((progressView?.bounds.width)! / 2) - 40.0
        }
        else if DeviceType.IS_IPHONE_6 {
            return ((progressView?.bounds.width)! / 2) - 20.0
        }
        else if DeviceType.IS_IPHONE_6P {
            return ((progressView?.bounds.width)! / 2) - 15.0
        }
        else {
            return ((progressView?.bounds.width)! / 2) - 20.0
        }
    }
    
    func fontFactor() -> CGFloat {
        if DeviceType.IS_IPHONE_5 {
            return 25.0
        }
        else if DeviceType.IS_IPHONE_6 {
            return 35.0
        }
        else if DeviceType.IS_IPHONE_6P {
            return 35.0
        }
        else {
            return 35.0
        }
    }
}
