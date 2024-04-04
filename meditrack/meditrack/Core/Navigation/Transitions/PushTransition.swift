import UIKit

final class PushTransition: NSObject {
    var isOpenAnimated: Bool = true
    var isCloseAnimated: Bool = true
    
    private weak var from: UIViewController?
    private var openCompletionHandler: (() -> Void)?
    private var closeCompletionHandler: (() -> Void)?
    
    private var navigationController: UINavigationController? {
        guard let navigation = from as? UINavigationController else { return from?.navigationController }
        return navigation
    }
    
    init(isOpenAnimated: Bool = true,
         isCloseAnimated: Bool = true) {
        self.isOpenAnimated = isOpenAnimated
        self.isCloseAnimated = isCloseAnimated
    }
}

extension PushTransition: Transition {
    func open(_ viewController: UIViewController, 
              from: UIViewController,
              completion: (() -> Void)?) {
        self.from = from
        openCompletionHandler = completion
        navigationController?.delegate = self
        navigationController?.pushViewController(viewController, 
                                                 animated: isOpenAnimated)
    }
    
    func close(_ viewController: UIViewController, 
               completion: (() -> Void)?) {
        closeCompletionHandler = completion
        navigationController?.popViewController(animated: isCloseAnimated)
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
