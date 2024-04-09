import UIKit

// MARK: - Images
extension Constants {
    // rule: (name)(second name)(number if needed)
    enum Images {
        // Default value
        private static let _none_ = UIImage()
        
        // System icons
        static let plusIcon = UIImage(named: "PlusIcon") ?? _none_
        
        static let backIcon = UIImage(named: "BackArrow") ?? _none_
        
        static let qrIcon = UIImage(named: "QRReader") ?? _none_
        
        static let picturesIcon = UIImage(named: "Pictures") ?? _none_
        
        static let settingsIcon = UIImage(named: "Settings") ?? _none_
        
        static let nilIcon = UIImage(named: "NilIcon") ?? _none_
        
        static let downArrow = UIImage(named: "DownArrow") ?? _none_
        
        static let rightArrow = UIImage(named: "RightArrow") ?? _none_
        
        static let checkIcon = UIImage(named: "Check") ?? _none_
        
        static let trashIcon = UIImage(named: "Trash") ?? _none_
        
        // Drug icons
        static let capsuleIcon = UIImage(named: "CapsuleIcon") ?? _none_
        
        static let tabletIcon = UIImage(named: "TabletIcon") ?? _none_
        
        static let dropIcon = UIImage(named: "DropIcon") ?? _none_
        
        static let inhaleIcon = UIImage(named: "InhaleIcon") ?? _none_
        
        static let injectionIcon = UIImage(named: "InjectionIcon") ?? _none_
        
        static let liquidIcon = UIImage(named: "LiquidIcon") ?? _none_
        
        static let otherIcon = UIImage(named: "OtherIcon") ?? _none_
        
        static let powderIcon = UIImage(named: "PowderIcon") ?? _none_
    }
}

// MARK: - Class
class GetImages {
    // MARK: functions
    // Get image data by drug type
    func byType(_ drugType: DrugType) -> Data {
        let _none_ = Data()
        
        switch drugType {
        case .capsule:
            return Constants.Images.capsuleIcon.pngData() ?? _none_
        case .tablet:
            return Constants.Images.tabletIcon.pngData() ?? _none_
        case .drop:
            return Constants.Images.dropIcon.pngData() ?? _none_
        case .inhale:
            return Constants.Images.inhaleIcon.pngData() ?? _none_
        case .injection:
            return Constants.Images.injectionIcon.pngData() ?? _none_
        case .liquid:
            return Constants.Images.liquidIcon.pngData() ?? _none_
        case .other:
            return Constants.Images.otherIcon.pngData() ?? _none_
        case .powder:
            return Constants.Images.powderIcon.pngData() ?? _none_
        }
    }
}
