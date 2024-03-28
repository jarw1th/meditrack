import Foundation

enum FoodType: String, CaseIterable {
    case noMatter, beforeMeal, duringMeal, afterMeal
}

extension FoodType {
    func getString() -> String {
        switch Locale.current.languageCode {
        case "ru":
            return ""
        default:
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
}
