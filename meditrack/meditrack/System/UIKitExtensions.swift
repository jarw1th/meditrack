import UIKit

extension UIView {
    // Extension for adding each view to subview from array
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIStackView {
    // Extension for adding each view to arranged subview from array
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

extension Date {
    // Extension for checking if date between other two
    func isBetween(start date1: Date, end date2: Date) -> Bool {
        let minDate = min(date1, date2)
        let maxDate = max(date1, date2)
        let result = DateInterval(start: minDate, end: maxDate).contains(self)
        return result
    }
    
    func standartize() -> Date {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: comps) ?? Date()
    }
    
    func convertToTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let resultString = dateFormatter.string(from: self)
        return resultString
    }
}

extension UITextField {
    func setHorizontalPaddings(left leftPadding: CGFloat? = nil, right rightPadding: CGFloat? = nil) {
        let leftPadding = leftPadding ?? self.frame.size.width
        let rightPadding = rightPadding ?? self.frame.size.width
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.size.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.size.height))
        
        self.leftView = leftPaddingView
        self.rightView = rightPaddingView
        
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
}
