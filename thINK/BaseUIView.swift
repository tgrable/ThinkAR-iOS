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
    var scrollview: UIScrollView?
    
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
            
            // About thINK
            } else if self.selectedIndex == 1 {
              
            // Contact thINK
            } else if self.selectedIndex == 2 {
              
            // Privacy
            } else if self.selectedIndex ==  4 {
                
            }
        }
    }
}
