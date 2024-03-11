import Foundation

struct DrugInfo {
    let id: String
    let name: String
    let descriptionDrug: String
    let timeInterval: Int // 1 hour interval
    let duration: Int // weeks
    let frequency: FrequencyType
    let drugType: DrugType
    let dose: Int // per day
    let startDate: Date // start date
    
    init(id: String,
         name: String,
         descriptionDrug: String,
         timeInterval: Int,
         duration: Int,
         frequency: FrequencyType,
         drugType: DrugType,
         dose: Int,
         startDate: Date?
    ) {
        self.id = id
        self.name = name
        self.descriptionDrug = descriptionDrug
        self.timeInterval = timeInterval
        self.duration = duration
        self.frequency = frequency
        self.drugType = drugType
        self.dose = dose
        if let startDate = startDate {
            self.startDate = startDate
        } else {
            self.startDate = Date()
        }
    }
    
    init(object: DrugInfoRealm) {
        let frequency = FrequencyType(rawValue: object.frequency) ?? .daily
        let drugType = DrugType(rawValue: object.drugType) ?? .capsule
        let id = object._id.stringValue
        self.init(id: id,
                  name: object.name,
                  descriptionDrug: object.descriptionDrug,
                  timeInterval: object.timeInterval,
                  duration: object.duration,
                  frequency: frequency,
                  drugType: drugType,
                  dose: object.dose,
                  startDate: object.startDate)
    }
}
