import UIKit

final class SwipeBack: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            present(using: transitionContext)
        } else {
            dismiss(using: transitionContext)
        }
    }
    
    private func present(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {return}
        
        let containerView = transitionContext.containerView
        let img = UIImageView(image: UIImage(systemName: "pencil"))
        img.alpha = 1.0
        img.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
        toView.addSubview(img)
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {img.alpha = 0.0}, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        
        let containerView = transitionContext.containerView
        let img = UIImageView(image: UIImage(systemName: "pencil"))
        img.alpha = 1.0
        img.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
        fromView.addSubview(img)
        
        containerView.addSubview(fromView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {img.alpha = 0.0}, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
