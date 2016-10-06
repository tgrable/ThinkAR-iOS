//
//  PartnerTableViewCell.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/29/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

class PartnerTableViewCell: UITableViewCell {
    
    var status: UIImageView?
    var vendorName: UILabel?
    var widthValue = 170
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        status = UIImageView()
        status!.contentMode = UIViewContentMode.scaleAspectFit
        status!.clipsToBounds = true
        status!.frame = CGRect(x:20, y: 7, width:30, height:30)
        contentView.addSubview(status!)
        
        vendorName = UILabel(frame: CGRect(x: 140, y:12 , width: widthValue, height: 20))
        vendorName!.textAlignment = NSTextAlignment.left
        vendorName!.text = "Name Of Vendor"
        vendorName!.adjustsFontSizeToFitWidth = true
        vendorName!.textColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        vendorName!.font =  UIFont(name: "Helvetica Neue", size: 18)
        contentView.addSubview(vendorName!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
