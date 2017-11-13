import UIKit
import XCTest
import QuizEngine
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
        factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsCorrectQuestionControllerWithRightCallback() {
        var answerCallbackWasFired = false
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in answerCallbackWasFired = true })
        
        factory.answerCallback[Question.singleAnswer("Q1")]!(["anything"])
        
        XCTAssertTrue(answerCallbackWasFired)
    }
    
    func test_routeToQuestion_showsResultController() {
        let viewController = UIViewController()
        let result = Result(answers: [Question.singleAnswer("Q1"): ["A1"]], score: 10)
        
        let secondViewController = UIViewController()
        let secondResult = Result(answers: [Question.singleAnswer("Q2"): ["A2"]], score: 20)
        
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    class NotAnimatedNavigationController: UINavigationController {
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
        
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        var answerCallback = [Question<String>: ([String]) -> Void]()
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = [Result<Question<String>, [String]>: UIViewController]()

        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(result: Result<Question<String>, [String]>, with viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
    }
}

extension Result: Hashable {
    
    init(answers: [Question: Answer], score: Int) {
        self.answers = answers
        self.score = score
    }
    
    public var hashValue: Int {
        return 1
    }
    
    public static func ==(lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
    
}





