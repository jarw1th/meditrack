import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Images {
        static let plusIcon = UIImage(named: "PlusIcon")
        
        static let backIcon = UIImage(named: "BackArrow")
        
        static let qrIcon = UIImage(named: "QRReader")
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
