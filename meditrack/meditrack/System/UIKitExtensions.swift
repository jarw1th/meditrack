import UIKit

// MARK: - UIView
extension UIView {
    // MARK: Functions
    // Adding each view to subview from array
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

// MARK: - UIStackView
extension UIStackView {
    // MARK: Functions
    // Adding each view to arranged subview from array
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

// MARK: - Date
extension Date {
    // MARK: Functions
    // Checking if date between other two
    func isBetween(start date1: Date, end date2: Date) -> Bool {
        let minDate = min(date1, date2)
        let maxDate = max(date1, date2)
        let interval = DateInterval(start: minDate, end: maxDate)
        let result = interval.contains(self)
        
        return result
    }
    
    // Standartizing date
    func standartize() -> Date {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let result = Calendar.current.date(from: comps) ?? Date()
        
        return result
    }
    
    // Convert date to time string
    func convertToTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let resultString = dateFormatter.string(from: self)
        
        return resultString
    }
}

// MARK: - UITextField
extension UITextField {
    // MARK: Functions
    // Set horizontal insets
    func setHorizontalPaddings(left leftPadding: CGFloat? = nil,
                               right rightPadding: CGFloat? = nil) {
        let leftPadding = leftPadding ?? self.frame.size.width
        let rightPadding = rightPadding ?? self.frame.size.width
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, 
                                                   y: 0,
                                                   width: leftPadding,
                                                   height: self.frame.size.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, 
                                                    y: 0,
                                                    width: rightPadding,
                                                    height: self.frame.size.height))
        
        self.leftView = leftPaddingView
        self.rightView = rightPaddingView
        
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
}

// MARK: - Array
extension Array {
    // MARK: Functions
    // Convert date array to time string array
    func convertToTime() -> [String] {
        guard let array = self as? Array<Date> else { return [] }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let resultString = array.map { dateFormatter.string(from: $0) }
        
        return resultString
    }
}

// MARK: - String
extension String {
    // MARK: Functions
    // Getting NotificationMinutesType enum from string
    func getNotificationMinutesType() -> NotificationMinutesType {
        let subStringArray = self.components(separatedBy: " ")
        let subString = subStringArray.first ?? ""
        let string = "m\(subString)"
        let noficationType = NotificationMinutesType(rawValue: string)
        
        return noficationType ?? .m5
    }
    
    // Convert string duration to number of weeks
    func convertDuration() -> Int {
        let postfix = self.components(separatedBy: " ").last
        let numberString = self.components(separatedBy: " ").first ?? ""
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
    
    // Get dose number from string
    func getDose() -> Int {
        let stringNumber = self.components(separatedBy: "/").first ?? ""
        let number = Int(stringNumber) ?? 0
        
        return number
    }
}
