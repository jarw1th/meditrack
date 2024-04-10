import Foundation

// MARK: - DrugType Enum
enum DrugType: String, CaseIterable {
    case capsule, tablet, liquid, powder, drop, inhale, injection, other
}

// MARK: - Extension Functions
extension DrugType {
    // MARK: Functions
    // Getting string with number
    func getString(_ number: Int) -> String {
        switch Locale.current.languageCode {
        case "ru":
            if number == 1 {
                return "\(number) \(string())"
            } else {
                return "\(number) \(string())"
            }
        case "es":
            if number == 1 {
                return "\(number) \(string())"
            } else {
                return "\(number) \(string())s"
            }
        default:
            if number == 1 {
                return "\(number) \(string())"
            } else {
                return "\(number) \(string())s"
            }
        }
        
    }
    
    // Getting string
    func getString() -> String {
        switch Locale.current.languageCode {
        case "ru":
            return string()
        case "es":
            return string()
        default:
            return string()
        }
        
    }
    
    // MARK: Private Functions
    // Getting localized string
    private func string() -> String {
        switch self {
        case .capsule:
            return Constants.Texts.systemCapsuleMain
        case .tablet:
            return Constants.Texts.systemTabletMain
        case .drop:
            return Constants.Texts.systemDropMain
        case .inhale:
            return Constants.Texts.systemInhaleMain
        case .injection:
            return Constants.Texts.systemInjectionMain
        case .liquid:
            return Constants.Texts.systeLiquidMain
        case .powder:
            return Constants.Texts.systemPowderMain
        case .other:
            return Constants.Texts.systemOtherMain
        }
    }
}
