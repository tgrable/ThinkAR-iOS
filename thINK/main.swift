//
//  main.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/28/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import Foundation
import UIKit

// overriding @UIApplicationMain
// http://stackoverflow.com/a/24021180/1060314

custom_unity_init(CommandLine.argc,CommandLine.unsafeArgv)
// Entry point to the application
UIApplicationMain(CommandLine.argc,
                  UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                    .bindMemory(
                        to: UnsafeMutablePointer<Int8>.self,
                        capacity: Int(CommandLine.argc)),
                  nil,
                  NSStringFromClass(AppDelegate.self)
)

