import UIKit

// rule: (name)(number if needed)
extension Constants {
    enum Colors {
        static let greenAccent = UIColor(named: "AccentColor") ?? .white
        
        static let grayPrimary = UIColor(named: "GrayPrimary") ?? .white
        
        static let graySecondary = UIColor(named: "GraySecondary") ?? .white
        
        static let graySecondaryLight = UIColor(named: "GraySecondaryLight") ?? .white
        
        static let grayBackground = UIColor(named: "GrayBackground") ?? .white
        
        static let white = UIColor.white
        
        static let black = UIColor.black
        
        // Icons style
        enum IconStyle {
            case normal, light
        }
        
        // Normal Icons
        static let capsuleColor = UIColor(named: "CapsuleColor") ?? .white
        
        static let tabletColor = UIColor(named: "TabletColor") ?? .white
        
        static let dropColor = UIColor(named: "DropColor") ?? .white
        
        static let powderColor = UIColor(named: "PowderColor") ?? .white
        
        static let liquidColor = UIColor(named: "LiquidColor") ?? .white
        
        static let inhaleColor = UIColor(named: "InhaleColor") ?? .white
        
        static let injectionColor = UIColor(named: "InjectionColor") ?? .white
        
        static let otherColor = UIColor(named: "OtherColor") ?? .white
        
        // Light Icons
        static let capsuleLightColor = UIColor(named: "CapsuleLightColor") ?? .white
        
        static let tabletLightColor = UIColor(named: "TabletLightColor") ?? .white
        
        static let dropLightColor = UIColor(named: "DropLightColor") ?? .white
        
        static let powderLightColor = UIColor(named: "PowderLightColor") ?? .white
        
        static let liquidLightColor = UIColor(named: "LiquidLightColor") ?? .white
        
        static let inhaleLightColor = UIColor(named: "InhaleLightColor") ?? .white
        
        static let injectionLightColor = UIColor(named: "InjectionLightColor") ?? .white
        
        static let otherLightColor = UIColor(named: "OtherLightColor") ?? .white
    }
}

class GetColors {
    func byType(_ drugType: DrugType, style: Constants.Colors.IconStyle) -> UIColor {
        switch style {
        case .normal:
            return normalIcons(drugType)
        case .light:
            return lightIcons(drugType)
        }
    }
    
    private func normalIcons(_ drugType: DrugType) -> UIColor {
        switch drugType {
        case .capsule:
            return Constants.Colors.capsuleColor
        case .tablet:
            return Constants.Colors.tabletColor
        case .drop:
            return Constants.Colors.dropColor
        case .powder:
            return Constants.Colors.powderColor
        case .liquid:
            return Constants.Colors.liquidColor
        case .inhale:
            return Constants.Colors.inhaleColor
        case .injection:
            return Constants.Colors.injectionColor
        case .other:
            return Constants.Colors.otherColor
        default:
            return Constants.Colors.white
        }
    }
    
    private func lightIcons(_ drugType: DrugType) -> UIColor {
        switch drugType {
        case .capsule:
            return Constants.Colors.capsuleLightColor
        case .tablet:
            return Constants.Colors.tabletLightColor
        case .drop:
            return Constants.Colors.dropLightColor
        case .powder:
            return Constants.Colors.powderLightColor
        case .liquid:
            return Constants.Colors.liquidLightColor
        case .inhale:
            return Constants.Colors.inhaleLightColor
        case .injection:
            return Constants.Colors.injectionLightColor
        case .other:
            return Constants.Colors.otherLightColor
        default:
            return Constants.Colors.white
        }
    }
}
