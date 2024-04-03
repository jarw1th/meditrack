// MARK: - Model
struct DrugTypeModel {
    // MARK: Variables
    // Genaral variables
    var sections: [DrugType] = []
    
    // MARK: Functions
    // Adding sections to model
    mutating func addSections(_ sections: [DrugType]) {
        self.sections = sections
    }
}
