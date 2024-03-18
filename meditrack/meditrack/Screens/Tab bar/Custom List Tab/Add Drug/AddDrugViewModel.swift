import Foundation

protocol AddDrugViewModelProtocol {
    func getItem(afterRowAt indexPath: IndexPath) -> DrugType
    
    func createDrug(_ item: DrugInfo)
    
    func getDose(at row: Int) -> String
    
    func getDuration(at row: Int) -> String
    
    func getFrequency(at row: Int) -> String
    
    func convertDuration(_ duration: String) -> Int
    
    var numberOfItems: Int { get }
    
    var numberOfDoseRows: Int { get }
    
    var numberOfDurationRows: Int { get }
    
    var numberOfFrequencyRows: Int { get }
    
    var selectedIndex: Int? { get set }
    
    var timeValue: Date? { get set }
}

final class AddDrugViewModel: AddDrugViewModelProtocol {
    // MARK: - Variables
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    
    private let model = PickerModel()
    
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository()) {
        self.drugInfoRepository = drugInfoRepository
    }
    
    func getItem(afterRowAt indexPath: IndexPath) -> DrugType {
        return DrugType.allCases[indexPath.row]
    }
    
    func createDrug(_ item: DrugInfo) {
        drugInfoRepository.saveDrugList([item])
    }
    
    func getDose(at row: Int) -> String {
        let dose = model.doses[row]
        return dose
    }
    
    func getDuration(at row: Int) -> String {
        let duration = model.duration[row]
        return duration
    }
    
    func getFrequency(at row: Int) -> String {
        let frequency = model.frequency[row]
        return frequency
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
    
    var numberOfItems: Int {
        return DrugType.allCases.count
    }
    
    var numberOfDoseRows: Int {
        let doses = model.doses
        return doses.count
    }
    
    var numberOfDurationRows: Int {
        let duration = model.duration
        return duration.count
    }
    
    var numberOfFrequencyRows: Int {
        let frequency = model.frequency
        return frequency.count
    }
    
    var selectedIndex: Int? = nil
}
