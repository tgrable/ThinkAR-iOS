//
//  MarkerCell.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class MarkerCell: UICollectionViewCell {
    
    var backgroundImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
        backgroundImage = UIImageView()
        backgroundImage!.contentMode = UIViewContentMode.scaleAspectFit
        backgroundImage!.clipsToBounds = true
        backgroundImage!.frame = CGRect(x:2, y: 2, width:(frame.size.width - 4), height:216)
        contentView.addSubview(backgroundImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
