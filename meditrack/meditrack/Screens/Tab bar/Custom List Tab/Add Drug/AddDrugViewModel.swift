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
    
    var selectedType: Int? { get set }
    
    var selectedFood: Int? { get set }
    
    var timeValue: Date? { get set }
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
    
    var timeValue: Date? = Date()
    
    var numberOfTypes: Int {
        return DrugType.allCases.count
    }
    
    var numberOfFood: Int {
        return FoodType.allCases.count
    }
    
    var selectedType: Int? = nil
    
    var selectedFood: Int? = nil
}
