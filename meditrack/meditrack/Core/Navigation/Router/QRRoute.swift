import UIKit

protocol QRRoute {
    
}

extension QRRoute where Self: Router {
    
}

extension DefaultRouter: QRRoute {}
