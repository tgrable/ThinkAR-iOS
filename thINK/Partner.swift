//
//  Partner.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/26/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class Partner: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var scanned: NSNumber?
    @NSManaged var boothNumber: NSNumber?
    @NSManaged var information: String?
    @NSManaged var markerImage: String?
    
}
