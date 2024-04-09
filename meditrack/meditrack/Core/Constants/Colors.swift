import UIKit

// MARK: - Colors
extension Constants {
    // rule: (name)(type)(number if needed)
    enum Colors {
        // Default value
        private static let _none_ = UIColor.white
        
        // Green
        static let greenAccent = UIColor(named: "AccentColor") ?? _none_
        
        // Gray
        static let grayPrimary = UIColor(named: "GrayPrimary") ?? _none_
        
        static let graySecondary = UIColor(named: "GraySecondary") ?? _none_
        
        static let graySecondaryLight = UIColor(named: "GraySecondaryLight") ?? _none_
        
        static let grayBackground = UIColor(named: "GrayBackground") ?? _none_
        
        // Action
        static let deleteAccent = UIColor(named: "DeleteAccent") ?? _none_
        
        static let deleteBackground = UIColor(named: "DeleteBackground") ?? _none_
        
        // Others
        static let white = UIColor.white
        
        static let black = UIColor.black
        
        // Icons style
        enum IconStyle {
            case normal, light
        }
        
        // Normal Icons
        static let capsuleColor = UIColor(named: "CapsuleColor") ?? _none_
        
        static let tabletColor = UIColor(named: "TabletColor") ?? _none_
        
        static let dropColor = UIColor(named: "DropColor") ?? _none_
        
        static let powderColor = UIColor(named: "PowderColor") ?? _none_
        
        static let liquidColor = UIColor(named: "LiquidColor") ?? _none_
        
        static let inhaleColor = UIColor(named: "InhaleColor") ?? _none_
        
        static let injectionColor = UIColor(named: "InjectionColor") ?? _none_
        
        static let otherColor = UIColor(named: "OtherColor") ?? _none_
        
        // Light Icons
        static let capsuleLightColor = UIColor(named: "CapsuleLightColor") ?? _none_
        
        static let tabletLightColor = UIColor(named: "TabletLightColor") ?? _none_
        
        static let dropLightColor = UIColor(named: "DropLightColor") ?? _none_
        
        static let powderLightColor = UIColor(named: "PowderLightColor") ?? _none_
        
        static let liquidLightColor = UIColor(named: "LiquidLightColor") ?? _none_
        
        static let inhaleLightColor = UIColor(named: "InhaleLightColor") ?? _none_
        
        static let injectionLightColor = UIColor(named: "InjectionLightColor") ?? _none_
        
        static let otherLightColor = UIColor(named: "OtherLightColor") ?? _none_
    }
}

// MARK: - Class
class GetColors {
    // MARK: Functions
    // Get color by drug type and icon style
    func byType(_ drugType: DrugType, style: Constants.Colors.IconStyle) -> UIColor {
        switch style {
        case .normal:
            return normalIcons(drugType)
        case .light:
            return lightIcons(drugType)
        }
    }
    
    // MARK: Private functions
    // Normal icons
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
        }
    }
    
    // Light icons
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
        }
    }
}
