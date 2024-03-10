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
}
