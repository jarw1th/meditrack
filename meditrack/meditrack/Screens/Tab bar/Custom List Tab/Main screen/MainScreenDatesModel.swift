import Foundation

// MARK: - Model
struct MainScreenDatesModel {
    // MARK: Variables
    // Genaral variables
    var dates: [Date] = []
    
    // MARK: Functions
    // Adding dates to model
    mutating func addDates(_ dates: [Date]) {
        self.dates = dates
    }
}
