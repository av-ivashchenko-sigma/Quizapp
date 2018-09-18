//
//  AppDelegate.swift
//  Quizapp
//
//  Created by Aleksandr Ivashchenko on 11/8/17.
//  Copyright © 2017 Sigma Software. All rights reserved.
//

import UIKit
import QuizEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController!
    var game: Game<Question<String>, Set<String>, NavigationControllerRouter>?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        setupAppearance()
        setupLogic()
        return true
    }
}

private extension AppDelegate {
    func setupLogic() {
        let question1 = Question.singleAnswer("What's Alex's nationality?")
        let question2 = Question.multipleAnswer("What are Boris's nationalities?")

        let option1 = "American"
        let option2 = "Russian"
        let option3 = "Ukrainian"
        let options1 = [option1, option2, option3]

        let option4 = "Bulgarian"
        let option5 = "Ukrainian"
        let option6 = "Belorussian"
        let options2 = [option4, option5, option6]

        let questions = [question1, question2]
        let correctAnswers = [question1: Set([option3]), question2: Set([option5, option6])]
        let factory = iOSViewControllerFactory(questions: questions, options: [question1: options1, question2: options2], correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(navigationController, factory: factory)
        game = startGame(questions: questions, router: router, correctAnswers: correctAnswers)
    }

    func setupAppearance() {
        UINavigationBar.appearance().barStyle = .blackOpaque
        UINavigationBar.appearance().barTintColor = UIColor.red
        let barAppearance = UINavigationBar.appearance()
        barAppearance.tintColor = .white
        barAppearance.barTintColor = .red
        barAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}

