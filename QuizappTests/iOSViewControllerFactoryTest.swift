import Foundation
import XCTest
@testable import Quizapp

class iOSViewControllerFactoryTest: XCTestCase {

    let options = ["A1", "A2"]
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
//    func test_questionViewController_withoutOptions_createsEmptyController() {
//        let sut = iOSViewControllerFactory(options: [:])
//
//        let controller = sut.questionViewController(for: singleAnswerQuestion, answerCallback: { _ in }) as? QuestionViewController
//
//        XCTAssertNotNil(controller)
//    }
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let questionPresenter = QuestionPresenter(questions: [singleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, questionPresenter.title)
    }
    
    func test_questionViewController_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
 
    func test_questionViewController_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: singleAnswerQuestion)
        _ = controller.view
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let questionPresenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, questionPresenter.title)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        _ = controller.view
        
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK: Helpers
    
    func makeSUT(options: [Question<String>: [String]]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: { _ in  }) as! QuestionViewController
    }
    
}
