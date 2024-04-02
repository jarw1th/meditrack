import Foundation

struct CustomListSectionModel {
    var sections: [Date] = []
    
    mutating func addSections(_ sections: [Date]) {
        self.sections = sections
    }
}
