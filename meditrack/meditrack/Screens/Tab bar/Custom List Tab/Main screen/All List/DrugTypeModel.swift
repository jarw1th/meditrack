import Foundation

struct DrugTypeModel {
    var sections: [DrugType] = []
    
    mutating func addSections(_ sections: [DrugType]) {
        self.sections = sections
    }
}
