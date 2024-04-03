import Foundation

// MARK: - Model
struct CustomListSectionModel {
    // MARK: Variables
    // Genaral variables
    var sections: [Date] = []
    
    // MARK: Functions
    // Adding sections to model
    mutating func addSections(_ sections: [Date]) {
        self.sections = sections
    }
}
