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
        
        static let inhaleIcon = UIImage(named: "InhaleIcon")
        
        static let injectionIcon = UIImage(named: "InjectionIcon")
        
        static let liquidIcon = UIImage(named: "LiquidIcon")
        
        static let otherIcon = UIImage(named: "OtherIcon")
        
        static let powderIcon = UIImage(named: "PowderIcon")
        
        static let nilIcon = UIImage(named: "NilIcon")
    }
}

class GetImages {
    func byType(_ drugType: DrugType) -> Data {
        let image = Constants.Images.nilIcon!.pngData() ?? Data()
        switch drugType {
        case .capsule:
            return Constants.Images.capsuleIcon!.pngData() ?? image
        case .tablet:
            return Constants.Images.tabletIcon!.pngData() ?? image
        case .drop:
            return Constants.Images.dropIcon!.pngData() ?? image
        case .inhale:
            return Constants.Images.inhaleIcon!.pngData() ?? image
        case .injection:
            return Constants.Images.injectionIcon!.pngData() ?? image
        case .liquid:
            return Constants.Images.liquidIcon!.pngData() ?? image
        case .other:
            return Constants.Images.otherIcon!.pngData() ?? image
        case .powder:
            return Constants.Images.powderIcon!.pngData() ?? image
        }
    }
}
