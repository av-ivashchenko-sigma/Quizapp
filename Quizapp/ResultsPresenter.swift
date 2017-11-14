import Foundation
import QuizEngine

struct ResultsPresenter {
    let result: Result<Question<String>, [String]>
    let questions: [Question<String>]
    let correctAnswers: [Question<String>: [String]]
    
    var summary: String {
        return "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { question in
            guard let userAnswer = result.answers[question],
            let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find a correct answer for a question: \(question)")
            }
            
            return presentableAnswer(question, userAnswer, correctAnswer)
        }
    }
    
    private func presentableAnswer(_ question: Question<String>,
                                   _ userAnswer: [String],
                                   _ correctAnswer: [String]) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(
                question: value,
                answer: formattedAnswer(correctAnswer),
                wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer))
        }
    }
    
    private func formattedAnswer(_ correctAnswer: [String]) -> String {
        return correctAnswer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ userAnswer: [String],_ correctAnswer: [String]) -> String? {
        return userAnswer == correctAnswer ? nil : userAnswer.joined(separator: ", ")
    }
    
}
