import UIKit

protocol AllListRoute {
    func toDetailedScreen(with transition: Transition,
                          model: DrugInfo)
}

extension AllListRoute where Self: Router {
    func toDetailedScreen(with transition: Transition,
                          model: DrugInfo) {
        let router = DefaultRouter(rootTranstion: transition)
        let viewModel = DetailedScreenViewModel(router: router)
        let viewController = DetailedScreenViewController(viewModel: viewModel,
                                                          selectedDrug: model)
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
}

extension DefaultRouter: AllListRoute {}
