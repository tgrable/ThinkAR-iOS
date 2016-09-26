//
//  PartnerData.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/26/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import Foundation

class PartnerData {
    
    // Partner data and UserDefaults
    var partnerList = UserDefaults.standard
    var partnerNames: [String] = ["APPVION", "ARCIS", "BCC SOFTWARE", "CMC", "CRAWFORD TECHNOLOGIES", "DALIM",
                                  "DOMTAR", "EMT", "FINCH", "GEORGIA PACIFIC", "GEP EHRET", "GLATFELTER",
                                  "GMC", "INTERNATIONAL PAPER", "IRONSIDES", "LINDENMEYR MUNROE", "MAC PAPERS", "MBO AMERICA",
                                  "MIDLAND PAPER", "MITSUBISHI IMAGING", "MONDI", "MULLER MARTINI", "PRINOVA, INC.", "ROLLAND",
                                  "SEFAS", "SPIRAL", "STANDARD", "TECNAU", "THARSTERN", "ULTIMATE",
                                  "VERSO", "VIDEK", "Extra Set #1", "Extra Set #2", "Extra Set #3", "TREKK"]
    
    
    //
    // Constructor to load the partner data if not persisted
    //
    init() {
        
        if partnerList.object(forKey: "TREKK") as? Partner != nil {
            print("Partner user defaults have persisted between usage of app")
        } else {
            print("Partner data needs to be loaded or has been lost")
            
            var index = 0
            for name in partnerNames {
                // Issues
                let p = Partner(partnerName: name, booth: index, info: "")
                partnerList.set(p, forKey: name)
                index += 1
            }
            
        }
    }
    
    //
    //
    //
    func setPartnerAsScanned(name: String) {
        
        if partnerList.object(forKey: name) as? Partner != nil {
            let p:Partner = partnerList.object(forKey: name) as! Partner
            p.scanned = true
            partnerList.set(p, forKey: name)
            print("Updated partner as scanned")
        } else {
            
            print("Partner was not found")
        }
    }
}
