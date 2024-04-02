import Foundation

protocol AddDrugViewModelProtocol {
    func getType(at indexPath: IndexPath) -> DrugType
    
    func getFood(at indexPath: IndexPath) -> FoodType
    
    func createDrug(_ item: DrugInfo)
    
    func getDoses() -> [String]
    
    func getDurations() -> [String]
    
    func getFrequency() -> [String]
    
    func getNotifications() -> [String]
    
    func convertDuration(_ duration: String) -> Int
    
    var numberOfTypes: Int { get }
    
    var numberOfFood: Int { get }
    
    // Drug
    var timeInterval: [Date]? { get set }
    
    var duration: Int? { get set }
    
    var frequency: FrequencyType? { get set }
    
    var drugType: DrugType? { get }
    
    var foodType: FoodType? { get }
    
    var selectedType: Int? { get set }
    
    var selectedFood: Int? { get set }
    
    var notifications: [NotificationMinutesType]? { get set }
    
    var dose: Int? { get set }
    
    func deleteInterval(_ time: String)
    
    func deleteNotification(_ notify: String)
    
    func checkOptional(name: String?, 
                       description: String?) -> Bool
}

final class AddDrugViewModel: AddDrugViewModelProtocol {
    // MARK: - Variables
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    
    private let model = PickerModel()
    
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository()) {
        self.drugInfoRepository = drugInfoRepository
    }
    
    func getType(at indexPath: IndexPath) -> DrugType {
        return DrugType.allCases[indexPath.row]
    }
    
    func getFood(at indexPath: IndexPath) -> FoodType {
        return FoodType.allCases[indexPath.row]
    }
    
    func createDrug(_ item: DrugInfo) {
        drugInfoRepository.saveDrugList([item])
    }
    
    func getDoses() -> [String] {
        let doses = model.doses
        return doses
    }
    
    func getDurations() -> [String] {
        let durations = model.duration
        return durations
    }
    
    func getFrequency() -> [String] {
        let frequency = model.frequency
        return frequency
    }
    
    func getNotifications() -> [String] {
        let notifications = model.notifications
        return notifications
    }
    
    func convertDuration(_ duration: String) -> Int {
        let postfix = duration.split(separator: " ").suffix(1).joined()
        let duration = Int(duration.split(separator: " ").prefix(1).joined()) ?? 0
        
        switch postfix {
        case Constants.Texts.menuDuration1Sub:
            return duration
        case Constants.Texts.menuDuration2Sub:
            return duration * 4
        case Constants.Texts.menuDuration2Sub:
            return duration * 52
        default:
            return 0
        }
    }
    
    var numberOfTypes: Int {
        return DrugType.allCases.count
    }
    
    var numberOfFood: Int {
        return FoodType.allCases.count
    }
    
    // Drug
    var timeInterval: [Date]? = []
    
    var duration: Int? = nil
    
    var frequency: FrequencyType? = nil
    
    var drugType: DrugType? {
        guard let selectedType = selectedType else { return nil }
        let type = DrugType.allCases[selectedType]
        
        return type
    }
    
    var foodType: FoodType? {
        guard let selectedType = selectedFood else { return nil }
        let type = FoodType.allCases[selectedType]
        
        return type
    }
    
    var selectedType: Int? = nil
    
    var selectedFood: Int? = nil
    
    var notifications: [NotificationMinutesType]? = []
    
    var dose: Int? = nil
    
    func deleteInterval(_ time: String) {
        let timeInterval = self.timeInterval?.convertToTime()
        guard let index = timeInterval?.firstIndex(of: time) else { return }
        self.timeInterval?.remove(at: index)
    }
    
    func deleteNotification(_ notify: String) {
        let notifications = self.notifications?.map({ $0.rawValue })
        guard let index = notifications?.firstIndex(of: notify) else { return }
        self.timeInterval?.remove(at: index)
    }
    
    func checkOptional(name: String?, 
                       description: String?) -> Bool {
        let reason1 = (timeInterval != [])
        let reason2 = (duration != nil)
        let reason3 = (frequency != nil)
        let reason4 = (selectedType != nil)
        let reason5 = (selectedFood != nil)
        let reason6 = (dose != nil)
        let reason7 = (name != nil) && (name?.trimmingCharacters(in: .whitespacesAndNewlines) != "")
        let reason8 = (description != nil) && (description?.trimmingCharacters(in: .whitespacesAndNewlines) != "")
        
        let result = reason1 && reason2 && reason3 && reason4 && reason5 && reason6 && reason7 && reason8
        
        return result
    }
}
