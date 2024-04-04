import UIKit

protocol MainScreenRoute {
    func toAllList(with transition: Transition)
    
    func toAddDrug(with transition: Transition)
}

extension MainScreenRoute where Self: Router {
    func toAllList(with transition: Transition) {
        let router = DefaultRouter(rootTranstion: transition)
        let viewModel = AllListViewModel(router: router)
        let viewController = AllListViewController(viewModel: viewModel)
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
    
    func toAddDrug(with transition: Transition) {
        let router = DefaultRouter(rootTranstion: transition)
        let viewModel = AddDrugViewModel(router: router)
        let viewController = AddDrugViewController(viewModel: viewModel)
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
}

extension DefaultRouter: MainScreenRoute {}
