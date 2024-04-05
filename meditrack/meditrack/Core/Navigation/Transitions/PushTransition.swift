import UIKit

final class PushTransition: NSObject {
    private weak var from: UIViewController?
    private var openCompletionHandler: (() -> Void)?
    private var closeCompletionHandler: (() -> Void)?
    
    private var navigationController: UINavigationController? {
        guard let navigation = from as? UINavigationController else { return from?.navigationController }
        return navigation
    }
}

extension PushTransition: Transition {
    func open(_ viewController: UIViewController, 
              from: UIViewController,
              animated: Bool,
              completion: (() -> Void)?) {
        self.from = from
        openCompletionHandler = completion
        navigationController?.delegate = self
        navigationController?.pushViewController(viewController, 
                                                 animated: animated)
    }
    
    func close(_ viewController: UIViewController,
               animated: Bool,
               completion: (() -> Void)?) {
        closeCompletionHandler = completion
        navigationController?.popViewController(animated: animated)
    }
}

extension PushTransition: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, 
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let transitionCoordinator = navigationController.transitionCoordinator, 
              let fromVC = transitionCoordinator.viewController(forKey: .from), 
              let toVC = transitionCoordinator.viewController(forKey: .to) else { return }
        if fromVC == from {
            openCompletionHandler?()
            openCompletionHandler = nil
        } else if toVC == from {
            closeCompletionHandler?()
            closeCompletionHandler = nil
        }
    }
}
