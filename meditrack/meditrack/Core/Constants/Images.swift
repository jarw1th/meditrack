import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Images {
        
        
    }
}

class GetImages {
    func byType(_ drugType: DrugType) -> Data {
        let image = UIImage(named: "Capsule")?.pngData() ?? Data()
        return image
        switch drugType {
        case .capsule:
            return Data()
        default:
            return Data()
        }
    }
}
