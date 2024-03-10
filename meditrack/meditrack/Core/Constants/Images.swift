import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Images {
        
        
    }
}

class GetImages {
    func byType(_ drugType: DrugType) -> Data {
        switch drugType {
        case .capsule:
            return Data()
        default:
            return Data()
        }
    }
}
