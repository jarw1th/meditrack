import UIKit

final class ModalTransition: Transition {
    func open(_ viewController: UIViewController, 
              from: UIViewController,
              animated: Bool,
              completion: (() -> Void)?) {
        from.present(viewController, 
                     animated: animated,
                     completion: completion)
    }
    
    func close(_ viewController: UIViewController,
               animated: Bool,
               completion: (() -> Void)?) {
        viewController.dismiss(animated: animated,
                               completion: completion)
    }
}

