import UIKit

protocol Closable: AnyObject {
    func close()
    
    func close(animated: Bool,
               completion: (() -> Void)?)
    
    func close(animated: Bool)
}

protocol Dismissable: AnyObject {
    func dismiss()
    
    func dismiss(completion: (() -> Void)?)
}

protocol Routable: AnyObject {
    func route(to viewController: UIViewController,
               as transition: Transition)
    
    func route(to viewController: UIViewController,
               as transition: Transition,
               animated: Bool)
    
    func route(to viewController: UIViewController,
               as transition: Transition,
               animated: Bool,
               completion: (() -> Void)?)
}

protocol Router: Routable {
    var root: UIViewController? { get set }
}
