import Foundation

// MARK: - DrugType Enum
enum DurationType: String, CaseIterable {
    case w1, w2, w3, m1, m2, m3, m4, m5, y1
}

// MARK: - Extension Functions
extension DurationType {
    // MARK: Functions
    // Getting string
    func getString() -> String {
        return "\(getNumberString()) \(getTypeString())"
    }
    
    // Getting int
    func getInt() -> Int {
        let postfix = getTypeString()
        let numberString = getNumberString()
        let number = Int(numberString) ?? 0
        
        switch postfix {
        case "week":
            return number
        case "month":
            return number * 4
        case "year":
            return number * 52
        default:
            return number
        }
    }
    
    // MARK: Private Functions
    // Get number string
    private func getNumberString() -> String {
        var string = self.rawValue
        string.removeFirst()
        
        return string
    }
    
    // Get type string
    private func getTypeString() -> String {
        var string = self.rawValue
        string.removeLast()
        
        switch string {
        case "w":
            return Constants.Texts.menuDuration1Sub
        case "m":
            return Constants.Texts.menuDuration2Sub
        case "y":
            return Constants.Texts.menuDuration3Sub
        default:
            return string
        }
    }
}
