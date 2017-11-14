import Foundation
import XCTest
import QuizEngine
@testable import Quizapp

class ResultsPresenterTest: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    func test_title_returnsFormattedTitle() {
        let result: Result<Question<String>, Set<String>> = Result(answers: [:], score: 0)
        let sut = ResultsPresenter(result: result,
                                   questions: [],
                                   options: [:],
                                   correctAnswers: [:])
        
        XCTAssertEqual(sut.title, "Result")
    }
    
    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let answers: [Question<String>: Set<String>] = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]];
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let orderedOptions = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"], ]
        let result = Result(answers: answers, score: 1)
        let sut = ResultsPresenter(result: result,
                                   questions: orderedQuestions,
                                   options: orderedOptions,
                                   correctAnswers: [:])
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswer_withoutQuestions_isEmpty() {
        let answers: [Question<String>: Set<String>] = [Question<String>: Set<String>]()
        let result = Result(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, questions: [], options: [:], correctAnswers: [:])

        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let answers: [Question<String>: Set<String>] = [singleAnswerQuestion: ["A1"]]
        let correctAnswers: [Question<String>: Set<String>] = [singleAnswerQuestion: ["A2"]]
        let orderedOptions = [singleAnswerQuestion: ["A1", "A2"]]
        let result = Result(answers: answers, score: 1)
        let sut = ResultsPresenter(result: result,
                                   questions: [singleAnswerQuestion],
                                   options: orderedOptions,
                                   correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let answers: [Question<String>: Set<String>] = [multipleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers: [Question<String>: Set<String>] = [multipleAnswerQuestion: ["A2", "A3"]]
        let orderedOptions = [multipleAnswerQuestion: ["A1", "A2", "A3", "A4"]]
        let result = Result(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result,
                                   questions: [multipleAnswerQuestion],
                                   options: orderedOptions,
                                   correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withRightSingleAnswer_mapsAnswer() {
        let answers: [Question<String>: Set<String>] = [singleAnswerQuestion: ["A1"]]
        let correctAnswers: [Question<String>: Set<String>] = [singleAnswerQuestion: ["A1"]]
        let orderedOptions = [singleAnswerQuestion: ["A1"]]
        let result = Result(answers: answers, score: 1)
        let sut = ResultsPresenter(result: result,
                                   questions: [singleAnswerQuestion],
                                   options: orderedOptions,
                                   correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
    }
    
    func test_presentableAnswers_withRightMultipleAnswer_mapsAnswer() {
        let answers: [Question<String>: Set<String>] = [multipleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers: [Question<String>: Set<String>] = [multipleAnswerQuestion: ["A1", "A4"]]
        let orderedOptions = [multipleAnswerQuestion: ["A1", "A4"]]
        let result = Result(answers: answers, score: 1)
        let sut = ResultsPresenter(result: result, questions: [multipleAnswerQuestion], options: orderedOptions, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
    }
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let answers: [Question<String>: Set<String>] = [multipleAnswerQuestion: ["A2"], singleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers: [Question<String>: Set<String>] = [multipleAnswerQuestion: ["A2"], singleAnswerQuestion: ["A1", "A4"]]
        let orderedOptions = [singleAnswerQuestion: ["A1", "A4"], multipleAnswerQuestion: ["A2"]]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let result = Result(answers: answers, score: 2)
        let sut = ResultsPresenter(result: result, questions: orderedQuestions, options: orderedOptions, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
    
    
    
    
    
}
