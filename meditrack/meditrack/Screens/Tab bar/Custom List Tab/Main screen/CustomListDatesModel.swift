import Foundation

struct CustomListDatesModel {
    var dates: [Date] = []
    
    mutating func addDates(_ dates: [Date]) {
        self.dates = dates
    }
}
