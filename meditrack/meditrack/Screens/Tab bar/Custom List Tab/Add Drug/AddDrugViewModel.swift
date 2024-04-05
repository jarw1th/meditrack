import Foundation

// MARK: - Protocol
protocol AddDrugViewModelProtocol {
    // Number of drug types
    var numberOfTypes: Int { get }
    
    // Number of food types
    var numberOfFood: Int { get }
    
    // Time interval array
    var timeInterval: [Date]? { get set }
    
    // Duration
    var duration: Int? { get set }
    
    // Frequency type
    var frequency: FrequencyType? { get set }
    
    // Drug type
    var drugType: DrugType? { get }
    
    // Food type
    var foodType: FoodType? { get }
    
    // Selected drug type
    var selectedType: Int? { get set }
    
    // Selected food type
    var selectedFood: Int? { get set }
    
    // Notifications array
    var notifications: [NotificationMinutesType]? { get set }
    
    // Dose
    var dose: Int? { get set }
    
    // Pop view controller
    func close(_ animated: Bool)
    
    // Dismiss view controller
    func dismiss()
    
    // Get drug type by indexpath
    func getType(at indexPath: IndexPath) -> DrugType
    
    // Get food type by indexpath
    func getFood(at indexPath: IndexPath) -> FoodType
    
    // Create DrugInfo object
    func createDrug(_ item: DrugInfo)
    
    // Get doses array
    func getDoses() -> [String]
    
    // Get durations array
    func getDurations() -> [String]
    
    // Get frequency array
    func getFrequency() -> [String]
    
    // Get notifications array
    func getNotifications() -> [String]
    
    // Convert duration from string to int
    func convertDuration(_ duration: String) -> Int

    // Remove time interval from array
    func deleteInterval(_ time: String)
    
    // Remove notification from array
    func deleteNotification(_ notify: String)
    
    // Check if fields ara filled
    func checkOptional(name: String?,
                       description: String?) -> Bool
}

// MARK: - Class
final class AddDrugViewModel: AddDrugViewModelProtocol {
    // MARK: Variables
    // Route
    typealias Routes = AddDrugRoute & Closable & Dismissable
    
    // Genaral variables
    private let router: Routes
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    private let model = PickerModel()
    
    // Number of drug types
    var numberOfTypes: Int {
        return DrugType.allCases.count
    }
    
    // Number of food types
    var numberOfFood: Int {
        return FoodType.allCases.count
    }
    
    // Time interval array
    var timeInterval: [Date]? = []
    
    // Duration
    var duration: Int? = nil
    
    // Frequency type
    var frequency: FrequencyType? = nil
    
    // Drug type
    var drugType: DrugType? {
        guard let selectedType = selectedType else { return nil }
        let type = DrugType.allCases[selectedType]
        
        return type
    }
    
    // Food type
    var foodType: FoodType? {
        guard let selectedType = selectedFood else { return nil }
        let type = FoodType.allCases[selectedType]
        
        return type
    }
    
    // Selected drug type
    var selectedType: Int? = nil
    
    // Selected food type
    var selectedFood: Int? = nil
    
    // Notifications array
    var notifications: [NotificationMinutesType]? = []
    
    // Dose
    var dose: Int? = nil
    
    // MARK: Body
    // Initial
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository(),
         router: Routes) {
        self.drugInfoRepository = drugInfoRepository
        self.router = router
    }
    
    // MARK: Functions
    // Popping view controller
    func close(_ animated: Bool) {
        router.close(animated: animated)
    }
    
    // Dismiss view controller
    func dismiss() {
        router.dismiss()
    }
    
    // Get drug type by indexpath
    func getType(at indexPath: IndexPath) -> DrugType {
        return DrugType.allCases[indexPath.row]
    }
    
    // Get food type by indexpath
    func getFood(at indexPath: IndexPath) -> FoodType {
        return FoodType.allCases[indexPath.row]
    }
    
    // Create DrugInfo object
    func createDrug(_ item: DrugInfo) {
        drugInfoRepository.saveDrugList([item])
    }
    
    // Get doses array
    func getDoses() -> [String] {
        let doses = model.doses
        return doses
    }
    
    // Get durations array
    func getDurations() -> [String] {
        let durations = model.duration
        return durations
    }
    
    // Get frequency array
    func getFrequency() -> [String] {
        let frequency = model.frequency
        return frequency
    }
    
    // Get notifications array
    func getNotifications() -> [String] {
        let notifications = model.notifications
        return notifications
    }
    
    // Convert duration from string to int
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
    
    // Remove time interval from array
    func deleteInterval(_ time: String) {
        let timeInterval = self.timeInterval?.convertToTime()
        guard let index = timeInterval?.firstIndex(of: time) else { return }
        self.timeInterval?.remove(at: index)
    }
    
    // Remove notification from array
    func deleteNotification(_ notify: String) {
        let notifications = self.notifications?.map({ $0.rawValue })
        guard let index = notifications?.firstIndex(of: notify) else { return }
        self.timeInterval?.remove(at: index)
    }
    
    // Check if fields ara filled
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
