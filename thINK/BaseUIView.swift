//
//  BaseUIView.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class BaseUIView: UIView {
    
    // DownloadMarker Views
    var collectionView: UICollectionView?
    var markerImagewCells = [UIImage]()
    
    // aboutThink, ContactThink, Privacy
    var bannerView: UIImageView?
    var bannerLogoView: UIImageView?
    var labelHeaderViewOne: UILabel?
    var labelHeaderViewTwo: UILabel?
    var bodyCopyView: UITextView?
    var htpbodyCopyView: UITextView?
    var howToPlayView: UIView?
    var bottomButtonOne: UIButton?
    var bottomLogo: UIImageView?
    var bottomLabel: UILabel?
    var scrollview: UIScrollView?
    
    // Think2016 Views
    var progressView: UIView?
    var tableHeader: UIView?
    var tableHeaderStatus: UILabel?
    var tableHeaderVendor: UILabel?
    var vendorTable: UITableView?

    var selectedIndex = 0

    // MARK: UIView Methods
    //
    //
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    //
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setters/Getters on current index
    //
    //
    //
    func setIndex(index: Int) {
        
        self.selectedIndex = index
    }
    
    func getIndex() -> Int {
        
        return self.selectedIndex
    }
    
    // Mark: Reflow child layouts
    //
    // Rearrange the layout based upon the subview menu item
    //
    func reflowLayout(width: CGFloat, height: CGFloat) {
        
        // Parent Frame
        self.frame = CGRect(x:0, y:45, width: width, height: height)
        
        // Specific to DownloadMarker
        if self.selectedIndex == 3 {
        
            collectionView!.frame = CGRect(x:20, y:20, width: (width - 40), height: (height - 80))
        
        } else {
            
            scrollview!.frame = CGRect(x:0, y:0, width: width, height: height)
           
            // thINK 2016
            if self.selectedIndex == 0 {
                
                progressView?.removeFromSuperview()
                
                if width > 320 {
                    progressView = UIView(frame: CGRect(x: 175, y: 35, width: 150, height: 150))
                    tableHeader!.frame = CGRect(x: 0, y: 235, width: width, height: 44)
                    vendorTable!.frame = CGRect(x: 0, y: 279, width: width, height: (height - 325))
                    htpbodyCopyView!.frame = CGRect(x: 18, y: 195, width: (width - 36), height: 340)
                } else {
                    progressView = UIView(frame: CGRect(x: 170, y: 35, width: 130, height: 130))
                    tableHeader!.frame = CGRect(x: 0, y: 185, width: width, height: 44)
                    vendorTable!.frame = CGRect(x: 0, y: 229, width: width, height: (height - 281))
                    htpbodyCopyView!.frame = CGRect(x: 18, y: 195, width: (width - 36), height: 320)
                }
                
                progressView!.tag = 33
                progressView!.backgroundColor = UIColor.clear
                scrollview!.addSubview(progressView!)
                
                vendorTable!.reloadData()
                scrollview!.contentSize = CGSize(width:width, height: height)
                
                howToPlayView!.frame = CGRect(x: 0, y: height, width: width, height: (height - 45))
                scrollview!.bringSubview(toFront: howToPlayView!)
                
            // About thINK
            } else if self.selectedIndex == 1 {
                
                bannerView!.frame = CGRect(x: 0, y: 0, width: width, height: 200)
                bodyCopyView!.frame = CGRect(x: 18, y: 335, width: (width - 36), height: 500)
                scrollview!.contentSize = CGSize(width: width, height: 900)
              
            // Contact thINK
            } else if self.selectedIndex == 2 {
                
                labelHeaderViewOne!.frame = CGRect(x: 20, y: 25, width: (width - 40), height: 30)
                bodyCopyView!.frame = CGRect(x: 18, y: 70, width: (width - 36), height: 300)
                bottomButtonOne!.frame = CGRect(x: 20, y: 375, width: (width - 40), height: 30)
                bottomLogo!.frame = CGRect(x: (width / 2 - 60), y: (height - 140), width: 122, height: 36)
                bottomLabel!.frame = CGRect(x: 20, y: (height - 89), width: (width - 40), height: 22)
                
            }
        }
    }
}
