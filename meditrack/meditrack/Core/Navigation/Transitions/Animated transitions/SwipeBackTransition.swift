import UIKit

final class SwipeBackTransition: NSObject {
    let animatedTransition: SwipeBack
    var isAnimated: Bool = true
    
    init(animatedTransition: SwipeBack, isAnimated: Bool = true) {
        self.animatedTransition = animatedTransition
        self.isAnimated = isAnimated
    }
}

extension SwipeBackTransition: Transition {
    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .custom
        from.present(viewController, animated: isAnimated, completion: completion)
    }
    
    func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        viewController.dismiss(animated: isAnimated, completion: completion)
    }
}

extension SwipeBackTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatedTransition.isPresenting = true
        return animatedTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatedTransition.isPresenting = false
        return animatedTransition
    }
}
