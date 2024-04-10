import Foundation

// MARK: - FoodType Enum
enum FoodType: String, CaseIterable {
    case noMatter, beforeMeal, duringMeal, afterMeal
}

// MARK: - Extension Functions
extension FoodType {
    // MARK: Functions
    // Getting string with number
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
        case .noMatter:
            return Constants.Texts.systemNomatterMain
        case .beforeMeal:
            return Constants.Texts.systemBeforemealMain
        case .duringMeal:
            return Constants.Texts.systemDuringmealMain
        case .afterMeal:
            return Constants.Texts.systemAftermealMain
        }
    }
}
