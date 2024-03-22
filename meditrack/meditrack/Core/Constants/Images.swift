import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Images {
        static let plusIcon = UIImage(named: "PlusIcon")
        
        static let rect = UIImage(named: "Rect")
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
