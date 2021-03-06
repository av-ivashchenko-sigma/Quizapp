import Foundation
import XCTest
import QuizEngine
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
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion).allowsMultipleSelection)
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
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion).allowsMultipleSelection)
    }

    func test_resultsViewController_createsControllerWithSummary() {
        let results = makeResults()
        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }
    
    func test_resultsViewController_createsControllerWithTitle() {
        let results = makeResults()
        XCTAssertEqual(results.controller.title, results.presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let results = makeResults()
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }
    
    // MARK: Helpers
    
    func makeSUT(options: [Question<String>: [String]] = [:], correctAnswers: [Question<String>: Set<String>] = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: { _ in  }) as! QuestionViewController
    }
    
    func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let userAnswers = [singleAnswerQuestion: Set(["A1", "A2"]), multipleAnswerQuestion: Set(["A3", "A4"])]
        let correctAnswers = [singleAnswerQuestion: Set(["A1", "A2"]), multipleAnswerQuestion: Set(["A3", "A4"])]
        let orderedOptions = [singleAnswerQuestion: ["A1", "A2"], multipleAnswerQuestion: ["A3", "A4"]]
        let result = Result(answers: userAnswers, score: 2)
        let presenter = ResultsPresenter(result: result, questions: questions, options: orderedOptions, correctAnswers: correctAnswers)
        let sut = makeSUT(correctAnswers: correctAnswers)
        let controller = sut.resultsViewController(for: result) as! ResultsViewController
        
        return (controller, presenter)
    }
}












