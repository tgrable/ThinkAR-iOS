//
//  Partner.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/26/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import Foundation

class Partner {
    
    var name: String = ""
    var scanned: Bool = false
    var boothNumber: Int = 0
    var information: String = ""
    
    init(partnerName: String, booth: Int, info: String) {
    
        name = partnerName
        scanned = false
        boothNumber = booth
        information = info
        
    }
}
