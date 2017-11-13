import UIKit
import XCTest
@testable import Quizapp

class NavigationControllerRouterTest: XCTestCase {
   
//    func test_routeToQuestion_presentsQuestionController() {
//        let navigationController = UINavigationController()
//        let sut = NavigationControllerRouter(navigationController)
//
//        sut.routeTo(question: "Q2", answerCallback: { _ in })
//
//        XCTAssertEqual(navigationController.viewControllers.count, 1)
//    }
//
//    func test_routeToQuestionTwice_presentsQuestionController() {
//
//        sut.routeTo(question: "Q1", answerCallback: { _ in })
//        sut.routeTo(question: "Q2", answerCallback: { _ in })
//
//        XCTAssertEqual(navigationController.viewControllers.count, 2)
//    }
    
//    func test_routeToQuestion_presentsCorrectQuestionController() {
//        let navigationController = UINavigationController()
//        
//        let factory = ViewControllerFactoryStub()
//        let viewController = UIViewController()
//        factory.stub(question: "Q1", with: viewController)
//        
//        let sut = NavigationControllerRouter(navigationController, factory: factory)
//        
//        sut.routeTo(question: "Q1", answerCallback: { _ in })
//        
//        XCTAssertEqual(navigationController.viewControllers.count, 1)
//        XCTAssertEqual(navigationController.viewControllers.first, viewController)
//    }

    let navigationController = NotAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_routeToQuestion_presentsCorrectQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: "Q1", with: viewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        sut.routeTo(question: "Q2", answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsCorrectQuestionControllerWithRightCallback() {
        var answerCallbackWasFired = false
        sut.routeTo(question: "Q1", answerCallback: { _ in answerCallbackWasFired = true })
        
        factory.answerCallback["Q1"]!("anything")
        
        XCTAssertTrue(answerCallbackWasFired)
    }
    
    class NotAnimatedNavigationController: UINavigationController {
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
        
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        var answerCallback = [String: (String) -> Void]()
        private var stubbedQuestions = [String: UIViewController]()
        
        func stub(question: String, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
    }
    
}
