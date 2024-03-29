import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Colors {
        static let greenAccent = UIColor(named: "AccentColor")
        
        static let grayPrimary = UIColor(named: "GrayPrimary")
        
        static let graySecondary = UIColor(named: "GraySecondary")
        
        static let graySecondaryLight = UIColor(named: "GraySecondaryLight")
        
        static let white = UIColor.white
        
        static let black = UIColor.black
        
        
        static let capsuleColor = UIColor(named: "CapsuleColor")
        
        static let tabletColor = UIColor(named: "TabletColor")
        
        static let dropColor = UIColor(named: "DropColor")
        
        static let powderColor = UIColor(named: "PowderColor")
        
        static let liquidColor = UIColor(named: "LiquidColor")
        
        static let inhaleColor = UIColor(named: "InhaleColor")
        
        static let injectionColor = UIColor(named: "InjectionColor")
        
        static let otherColor = UIColor(named: "OtherColor")
        
        static let grayBackground = UIColor(named: "GrayBackground")
    }
}

class GetColors {
    func byType(_ drugType: DrugType) -> UIColor {
        switch drugType {
        case .capsule:
            return Constants.Colors.capsuleColor!
        case .tablet:
            return Constants.Colors.tabletColor!
        case .drop:
            return Constants.Colors.dropColor!
        case .powder:
            return Constants.Colors.powderColor!
        case .liquid:
            return Constants.Colors.liquidColor!
        case .inhale:
            return Constants.Colors.inhaleColor!
        case .injection:
            return Constants.Colors.injectionColor!
        case .other:
            return Constants.Colors.otherColor!
        default:
            return Constants.Colors.white
        }
    }
}
