import Foundation

struct DatesModel {
    var dates: [Date] = []
    
    init() {
        self.dates = [Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date()]
    }
    
    mutating func addDates(_ dates: [Date]) {
        self.dates = dates
    }
}
