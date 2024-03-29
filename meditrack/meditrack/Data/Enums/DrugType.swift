import Foundation

enum DrugType: String, CaseIterable {
    case capsule, tablet, liquid, powder, drop, inhale, injection, other, all
}

extension DrugType {
    func getString(_ number: Int) -> String {
        switch Locale.current.languageCode {
        case "ru":
            if number == 1 {
                return self.rawValue
            } else {
                return "\(self.rawValue)s"
            }
        default:
            if number == 1 {
                return "\(number) \(self.rawValue)"
            } else {
                return "\(number) \(self.rawValue)s"
            }
        }
        
    }
}
