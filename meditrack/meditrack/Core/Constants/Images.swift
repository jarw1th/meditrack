import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Images {
        static let plusIcon = UIImage(named: "PlusIcon") ?? UIImage()
        
        static let backIcon = UIImage(named: "BackArrow") ?? UIImage()
        
        static let qrIcon = UIImage(named: "QRReader") ?? UIImage()
        
        static let capsuleIcon = UIImage(named: "CapsuleIcon") ?? UIImage()
        
        static let tabletIcon = UIImage(named: "TabletIcon") ?? UIImage()
        
        static let dropIcon = UIImage(named: "DropIcon") ?? UIImage()
        
        static let inhaleIcon = UIImage(named: "InhaleIcon") ?? UIImage()
        
        static let injectionIcon = UIImage(named: "InjectionIcon") ?? UIImage()
        
        static let liquidIcon = UIImage(named: "LiquidIcon") ?? UIImage()
        
        static let otherIcon = UIImage(named: "OtherIcon") ?? UIImage()
        
        static let powderIcon = UIImage(named: "PowderIcon") ?? UIImage()
        
        static let nilIcon = UIImage(named: "NilIcon") ?? UIImage()
        
        static let downArrow = UIImage(named: "DownArrow") ?? UIImage()
        
        static let rightArrow = UIImage(named: "RightArrow") ?? UIImage()
    }
}

class GetImages {
    func byType(_ drugType: DrugType) -> Data {
        let image = Constants.Images.nilIcon.pngData() ?? Data()
        switch drugType {
        case .capsule:
            return Constants.Images.capsuleIcon.pngData() ?? image
        case .tablet:
            return Constants.Images.tabletIcon.pngData() ?? image
        case .drop:
            return Constants.Images.dropIcon.pngData() ?? image
        case .inhale:
            return Constants.Images.inhaleIcon.pngData() ?? image
        case .injection:
            return Constants.Images.injectionIcon.pngData() ?? image
        case .liquid:
            return Constants.Images.liquidIcon.pngData() ?? image
        case .other:
            return Constants.Images.otherIcon.pngData() ?? image
        case .powder:
            return Constants.Images.powderIcon.pngData() ?? image
        default:
            return image
        }
    }
}
