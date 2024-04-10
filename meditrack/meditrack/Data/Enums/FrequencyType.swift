import Foundation

// MARK: - FrequencyType Enum
enum FrequencyType: String, CaseIterable {
    case daily, weekly, monthly, annually
}

// MARK: - Extension Functions
extension FrequencyType {
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
        case .daily:
            return Constants.Texts.systemDailyMain
        case .weekly:
            return Constants.Texts.systemWeeklyMain
        case .monthly:
            return Constants.Texts.systemMonthlyMain
        case .annually:
            return Constants.Texts.systemAnnuallyMain
        }
    }
}
