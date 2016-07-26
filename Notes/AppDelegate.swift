//
//  AppDelegate.swift
//  Notes
//
//  Created by Joshua Fisher on 7/25/16.
//  Copyright © 2016 Calendre Co. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var browseController: BrowseController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow()
        
        browseController = BrowseController()
        browseController.show(window!)
        
        return true
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if let browser = browseController {
            return browser.handle(url: url)
        }
        return false
    }
}

