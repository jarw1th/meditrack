import RealmSwift

class DrugInfoRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var descriptionDrug: String
    @Persisted var timeInterval: List<Date> // 1 hour interval
    @Persisted var duration: Int // weeks
    @Persisted var frequency: FrequencyType.RawValue
    @Persisted var drugType: DrugType.RawValue
    @Persisted var foodType: FoodType.RawValue
    @Persisted var notifications: List<NotificationMinutesType.RawValue>
    @Persisted var dose: Int // per day
    @Persisted var startDate: Date // start date
    
    convenience init(structure: DrugInfo) {
        let frequency = structure.frequency.rawValue
        let drugType = structure.drugType.rawValue
        let timeInterval = List<Date>()
        timeInterval.append(objectsIn: structure.timeInterval)
        let foodType = structure.foodType.rawValue
        let notifications = List<NotificationMinutesType.RawValue>()
        notifications.append(objectsIn: structure.notifications.map({ $0.rawValue }))
        
        self.init()
        self.name = structure.name
        self.descriptionDrug = structure.descriptionDrug
        self.timeInterval = timeInterval
        self.duration = structure.duration
        self.frequency = frequency
        self.drugType = drugType    
        self.foodType = foodType
        self.notifications = notifications
        self.dose = structure.dose
        self.startDate = structure.startDate
    }
}
