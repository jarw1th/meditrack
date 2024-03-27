import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Images {
        static let plusIcon = UIImage(named: "PlusIcon")
        
        static let backIcon = UIImage(named: "BackArrow")
        
        static let qrIcon = UIImage(named: "QRReader")
        
        static let capsuleIcon = UIImage(named: "CapsuleIcon")
        
        static let tabletIcon = UIImage(named: "TabletIcon")
        
        static let dropIcon = UIImage(named: "DropIcon")
    }
}

class GetImages {
    func byType(_ drugType: DrugType) -> Data {
        let image = UIImage(named: "Capsule")?.pngData() ?? Data()
        switch drugType {
        case .capsule:
            return Constants.Images.capsuleIcon!.pngData() ?? image
        case .tablet:
            return Constants.Images.tabletIcon!.pngData() ?? image
        case .drops:
            return Constants.Images.dropIcon!.pngData() ?? image
        default:
            return image
        }
    }
}
