//
//  AppDelegate.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let container = Container.sharedContainer

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        self.instantiateRootViewController(for: window)
        
        return true
    }
    
    private func instantiateRootViewController(for window: UIWindow) {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        
        window.rootViewController = navigationController
        
        let hotelsViewController = container.resolve(HotelsViewController.self)!
        navigationController.pushViewController(hotelsViewController, animated: false)
        
    }

}

