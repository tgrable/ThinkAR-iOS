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
    var bottomButtonOne: UIButton?
    var bottomButtonTwo: UIButton?
    var bottomLogo: UIImageView?
    var bottomLabel: UILabel?
    var scrollview: UIScrollView?
    var progressView: UIView?
    
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
    //
    //
    func reflowLayout(width: CGFloat, height: CGFloat) {
        
        // Parent Frame
        self.frame = CGRect(x:0, y:45, width: width, height: height)
        
        // Specific to DownloadMarker
        if self.selectedIndex == 3 {
            
            // Portrait
            collectionView!.frame = CGRect(x:20, y:20, width: (width - 40), height: (height - 80))
        
        } else {
            
            scrollview!.frame = CGRect(x:0, y:0, width: width, height: height)
           
            // thINK 2016
            if self.selectedIndex == 0 {
                
                if width > 320 {
                    progressView!.frame = CGRect(x: 170, y: 35, width: 180, height: 180)
                } else {
                    progressView!.frame = CGRect(x: 170, y: 35, width: 130, height: 130)
                }
                
            // About thINK
            } else if self.selectedIndex == 1 {
                
                bannerView!.frame = CGRect(x: 0, y: 0, width: width, height: 200)
                bodyCopyView!.frame = CGRect(x: 18, y: 335, width: (width - 36), height: 350)
                scrollview!.contentSize = CGSize(width: width, height: 750)
              
            // Contact thINK
            } else if self.selectedIndex == 2 {
                
                labelHeaderViewOne!.frame = CGRect(x: 20, y: 25, width: (width - 40), height: 30)
                bodyCopyView!.frame = CGRect(x: 18, y: 70, width: (width - 36), height: 85)
                bottomButtonOne!.frame = CGRect(x: 20, y: 160, width: (width - 40), height: 30)
                bottomButtonTwo!.frame = CGRect(x: 20, y: 205, width: (width - 40), height: 30)
                bottomLogo!.frame = CGRect(x: (width / 2 - 60), y: (height - 140), width: 122, height: 36)
                bottomLabel!.frame = CGRect(x: 20, y: (height - 89), width: (width - 40), height: 22)
                
            // Privacy
            } /*else if self.selectedIndex ==  4 {
                
            }*/
        }
    }
}
