import UIKit

final class EmptyTransition: Transition {
    func open(_ viewController: UIViewController, 
              from: UIViewController,
              animated: Bool,
              completion: (() -> Void)?) {}
    
    func close(_ viewController: UIViewController, 
               animated: Bool,
               completion: (() -> Void)?) {}
}
