//
//  CustomButtonProtocol.swift
//  SolimarAR
//
//  Created by Trekk mini-1 on 9/14/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//



// MarkerProtocol calls back to any ViewController conforming to it
protocol CustomButtonProtocol: class {
    // This function calls back to the view controller to send a user out to a URL
    func learnMoreLink(url: String)
}
