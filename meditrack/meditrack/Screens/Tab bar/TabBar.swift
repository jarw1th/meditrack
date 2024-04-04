import UIKit

final class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = viewControllers()
    }
    
    private func viewControllers() -> [UIViewController] {
        let viewControllers = [mainScreen(),
                               emptyScreen()]
        
        return viewControllers
    }
    
    private func mainScreen() -> UIViewController {
        let router = DefaultRouter(rootTranstion: EmptyTransition())
        let viewModel = MainScreenViewModel(router: router)
        let viewController = MainScreenViewController(viewModel: viewModel)
        router.root = viewController
        
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = UITabBarItem(title: "", 
                                             image: nil,
                                             tag: 0)
        
        return navigation
    }
    
    private func emptyScreen() -> UIViewController {
        let router = DefaultRouter(rootTranstion: EmptyTransition())
        let viewController = UIViewController()
        router.root = viewController
        
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = UITabBarItem(title: "", 
                                             image: nil,
                                             tag: 1)
        
        return navigation
    }
}
