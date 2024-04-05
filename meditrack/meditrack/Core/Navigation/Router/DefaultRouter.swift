import UIKit

final class DefaultRouter: NSObject, Router, Closable, Dismissable {
    private let rootTransition: Transition
    weak var root: UIViewController?
    
    init(rootTranstion: Transition) {
        self.rootTransition = rootTranstion
    }
    
    func route(to viewController: UIViewController, 
               as transition: Transition,
               animated: Bool,
               completion: (() -> Void)?) {
        guard let root = root else { return }
        transition.open(viewController,
                        from: root,
                        animated: animated,
                        completion: completion)
    }
    
    func route(to viewController: UIViewController,
               as transition: Transition,
               animated: Bool) {
        route(to: viewController,
              as: transition,
              animated: animated,
              completion: nil)
    }
    
    func route(to viewController: UIViewController,
               as transition: Transition) {
        route(to: viewController,
              as: transition,
              animated: true,
              completion: nil)
    }
    
    func close(animated: Bool,
               completion: (() -> Void)?) {
        guard let root = root else { return }
        rootTransition.close(root,
                             animated: animated,
                             completion: completion)
    }
    
    func close(animated: Bool) {
        close(animated: animated, completion: nil)
    }
    
    func close() {
        close(animated: true, completion: nil)
    }
    
    func dismiss(completion: (() -> Void)?) {
        root?.dismiss(animated: true, 
                      completion: completion)
    }
    
    func dismiss() {
        dismiss(completion: nil)
    }
}

