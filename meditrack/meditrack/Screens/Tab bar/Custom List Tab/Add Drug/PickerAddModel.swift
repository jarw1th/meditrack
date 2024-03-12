import Foundation

struct PickerModel {
    var doses: [String] = []
    var duration: [String] = []
    var frequency: [String] = []
    
    init() {
        // Doses
        for i in 1...10 {
            let element = "\(i)\(Constants.Texts.menuDoseSub)"
            self.doses.append(element)
        }
        
        // Duration
        for i in 1...3 {
            let element = "\(i) \(Constants.Texts.menuDuration1Sub)"
            self.duration.append(element)
        }
        for i in 1...6 {
            let element = "\(i) \(Constants.Texts.menuDuration2Sub)"
            self.duration.append(element)
        }
        self.duration.append("1 \(Constants.Texts.menuDuration3Sub)")
        
        // Frequency
        for element in FrequencyType.allCases {
            self.frequency.append(element.rawValue)
        }
    }
}
