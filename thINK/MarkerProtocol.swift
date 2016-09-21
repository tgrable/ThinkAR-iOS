//
//  MarkerProtocol.swift
//  SolimarAR
//
//  Created by Trekk mini-1 on 9/14/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

// MarkerProtocol calls back to any ViewController conforming to it
protocol MarkerProtocol: class {
    // This function calls back to the view controller to notify of a button pressed
    func printJobCallback(flag: Int)
}
