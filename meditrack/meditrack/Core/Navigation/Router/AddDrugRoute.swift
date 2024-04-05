import UIKit

protocol AddDrugRoute {
    func toQR(with transition: Transition)
}

extension AddDrugRoute where Self: Router {
    func toQR(with transition: Transition) {
        let router = DefaultRouter(rootTranstion: transition)
        let viewModel = QRViewModel(router: router)
        let viewController = QRViewController(viewModel: viewModel)
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
}

extension DefaultRouter: AddDrugRoute {}
