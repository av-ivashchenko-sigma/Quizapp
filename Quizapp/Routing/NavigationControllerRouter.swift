import UIKit
import QuizEngine

class NavigationControllerRouter: Router {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping (Set<String>) -> Void) {
        switch question {
        case .singleAnswer:
            show(factory.questionViewController(for: question, answerCallback: answerCallback))
        case .multipleAnswer:
            let button = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
            let buttonController = SubmitButtonController(button, answerCallback)
            let viewController = factory.questionViewController(for: question, answerCallback: { selection in
                buttonController.update(selection)
            })
            viewController.navigationItem.rightBarButtonItem = button
            show(viewController)
        }
    }

    func routeTo(result: Result<Question<String>, Set<String>>) {
        show(factory.resultsViewController(for: result))
    }

    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

private class SubmitButtonController: NSObject {
    private let button: UIBarButtonItem
    private let callback: (Set<String>) -> Void
    private var model: Set<String> = []
    
    init(_ button: UIBarButtonItem,_ callback: @escaping (Set<String>) -> Void) {
        self.button = button
        self.callback = callback
        super.init()
        self.setup()
    }
    
    private func setup() {
        button.target = self
        button.action = #selector(fireCallback)
        updateButtonState()
    }
    
    @objc private func fireCallback() {
        callback(model)
    }
    
    func updateButtonState() {
        button.isEnabled = model.count > 0
    }
    
    func update(_ model: Set<String>) {
        self.model = model
        updateButtonState()
    }
}





