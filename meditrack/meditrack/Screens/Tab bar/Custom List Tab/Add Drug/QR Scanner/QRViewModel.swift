import Foundation

// MARK: - Protocol
protocol QRViewModelProtocol {
    // Pop view controller
    func close(_ animated: Bool)
}

// MARK: - Class
final class QRViewModel: QRViewModelProtocol {
    // MARK: Variables
    // Route
    typealias Routes = QRRoute & Closable & Dismissable
    
    // Genaral variables
    private let router: Routes
    
    // MARK: Body
    // Initial
    init(router: Routes) {
        self.router = router
    }
    
    // MARK: Functions
    // Popping view controller
    func close(_ animated: Bool) {
        router.close(animated: animated)
    }
}
