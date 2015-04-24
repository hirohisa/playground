//
//  AppDelegate.swift
//  Appearance
//
//  Created by Hirohisa Kawasaki on 4/23/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        changeAppearance()
        return true
    }

    func changeAppearance() {
        changeUINavigationBarAppearance()
        changeStatusBarAppearance()
    }

    func changeStatusBarAppearance() {
        // info.plist -> View controller-based status bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    func changeUINavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor.blueColor()
        appearance.tintColor = UIColor.whiteColor()
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
    }

}

