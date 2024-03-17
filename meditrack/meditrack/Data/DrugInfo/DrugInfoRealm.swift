import RealmSwift

class DrugInfoRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var descriptionDrug: String
    @Persisted var timeInterval: Date // 1 hour interval
    @Persisted var duration: Int // weeks
    @Persisted var frequency: FrequencyType.RawValue
    @Persisted var drugType: DrugType.RawValue
    @Persisted var dose: Int // per day
    @Persisted var startDate: Date // start date
    
    convenience init(structure: DrugInfo) {
        let frequency = structure.frequency.rawValue
        let drugType = structure.drugType.rawValue
        self.init()
        self.name = structure.name
        self.descriptionDrug = structure.descriptionDrug
        self.timeInterval = structure.timeInterval
        self.duration = structure.duration
        self.frequency = frequency
        self.drugType = drugType    
        self.dose = structure.dose
        self.startDate = structure.startDate
    }
}
