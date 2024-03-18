import Foundation

struct SectionModel {
    var sections: [Date] = []
    
    mutating func addSections(_ sections: [Date]) {
        self.sections = sections
    }
}
