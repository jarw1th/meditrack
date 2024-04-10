
struct PickerModel {
    // MARK: Variables
    // Genaral variables
    var doses: [String] = []
    
    // MARK: Body
    // Initial
    init() {
        // Doses
        for i in 1...10 {
            let element = "\(i)\(Constants.Texts.menuDoseSub)"
            self.doses.append(element)
        }
    }
}
