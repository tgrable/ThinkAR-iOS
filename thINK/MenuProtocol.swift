//
//  MenuProtocol.swift
//  SolimarAR
//
//  Created by Trekk mini-1 on 9/14/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

// MenuProtocol calls back to any ViewController conforming to it
protocol MenuProtocol: class {
    // This function calls back to the view controller to notify of a button pressed
    func menuItemSelected(item: Int)
    // Swipe Gesture for Menu
    func swipeClose()
    
}
