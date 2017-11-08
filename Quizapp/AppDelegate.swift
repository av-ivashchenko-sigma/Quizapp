//
//  AppDelegate.swift
//  Quizapp
//
//  Created by Aleksandr Ivashchenko on 11/8/17.
//  Copyright © 2017 Sigma Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let viewController = QuestionViewController(question: "A question?", options: ["Option 1", "Option 2"]) {
      print($0)
    }
    
    _ = viewController.view
    viewController.tableView.allowsMultipleSelection = false
    
    window.rootViewController = viewController
    
    self.window = window
    window.makeKeyAndVisible()
    
    return true
  }
  
}

