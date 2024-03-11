import Foundation

struct DatesModel {
    var dates: [Date] = []
    
    mutating func addDates(_ dates: [Date]) {
        self.dates = dates
    }
}
