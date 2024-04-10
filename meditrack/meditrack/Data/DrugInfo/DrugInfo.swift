import Foundation

// MARK: - Object
struct DrugInfo {
    // MARK: Variables
    var id: String
    var name: String
    var descriptionDrug: String
    var timeInterval: [Date]
    var duration: DurationType // weeks
    var frequency: FrequencyType
    var drugType: DrugType
    var foodType: FoodType
    var notifications: [NotificationMinutesType]
    var dose: Int // per day
    let startDate: Date // start date
    
    // MARK: Body
    // Initial
    init(id: String?,
         name: String?,
         descriptionDrug: String?,
         timeInterval: [Date]?,
         duration: DurationType?,
         frequency: FrequencyType?,
         drugType: DrugType?,
         foodType: FoodType?,
         notifications: [NotificationMinutesType]?,
         dose: Int?,
         startDate: Date?
    ) {
        self.id = id ?? ""
        self.name = name ?? ""
        self.descriptionDrug = descriptionDrug ?? ""
        self.timeInterval = timeInterval ?? []
        self.duration = duration ?? .w1
        self.frequency = frequency ?? .daily
        self.drugType = drugType ?? .capsule
        self.foodType = foodType ?? .noMatter
        self.notifications = notifications ?? []
        self.dose = dose ?? 0
        if let startDate = startDate {
            self.startDate = startDate
        } else {
            self.startDate = Date()
        }
    }
    
    // Initia; by DrugInfoRealm object
    init(object: DrugInfoRealm) {
        let frequency = FrequencyType(rawValue: object.frequency) ?? .daily
        let drugType = DrugType(rawValue: object.drugType) ?? .capsule
        let duration = DurationType(rawValue: object.duration) ?? .w1
        let id = object._id.stringValue
        let timeInterval = Array(object.timeInterval)
        let foodType = FoodType(rawValue: object.foodType) ?? .noMatter
        let notifications = Array(object.notifications.map({ NotificationMinutesType(rawValue: $0) ?? .m5}))
        
        self.init(id: id,
                  name: object.name,
                  descriptionDrug: object.descriptionDrug,
                  timeInterval: timeInterval,
                  duration: duration,
                  frequency: frequency,
                  drugType: drugType,
                  foodType: foodType,
                  notifications: notifications,
                  dose: object.dose,
                  startDate: object.startDate)
    }
}
