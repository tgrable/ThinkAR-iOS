//
//  CustomButtonProtocol.swift
//  SolimarAR
//
//  Created by Trekk mini-1 on 9/14/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//



// MarkerProtocol calls back to any ViewController conforming to it
protocol CustomButtonProtocol: class {

    // Call thINK
    func callthINK(scheme: String)
    // Email thINK
    func emailthINK(email: String)
    // Open Privacy Statement
    //func openPrivacyStatement(url: String)
}
