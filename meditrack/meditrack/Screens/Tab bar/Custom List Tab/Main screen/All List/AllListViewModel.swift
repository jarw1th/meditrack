import Foundation

// MARK: - Protocol
protocol AllListViewModelProtocol {
    // Get number of sections
    var numberOfSections: Int { get }
    
    // Pop view controller
    func close()
    
    // Dismiss view controller
    func dismiss()
    
    // Get item setup information by indexpath
    func getItemSetup(at indexPath: IndexPath,
                      completion: @escaping (String, DrugType, Int, FoodType, Bool) -> Void)
    
    // Get section title by section index
    func getSectionTitle(for section: Int) -> NSMutableAttributedString
    
    // Get number of rows by section index
    func numberOfRows(in section: Int) -> Int
}

// MARK: - Class
final class AllListViewModel: AllListViewModelProtocol {
    // MARK: Variables
    // Route
    typealias Routes = AllListRoute & Closable & Dismissable
    
    // Genaral variables
    private let router: Routes
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    private let drugCompletementRepository: DrugCompletementRepositoryProtocol
    private var model = DrugTypeModel()
    
    // Get number of sections
    var numberOfSections: Int {
        let sections = model.sections
        return sections.count
    }
    
    // MARK: Body
    // Initial
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository(),
         drugCompletementRepository: DrugCompletementRepositoryProtocol = DrugCompletementRepository(),
         router: Routes) {
        self.drugInfoRepository = drugInfoRepository
        self.drugCompletementRepository = drugCompletementRepository
        self.router = router
        
        drugCompletementRepository.checkCache(drugInfoRepository.getDrugList())
        
        model.addSections(getDrugsTypes())
    }
    
    // MARK: Functions
    // Pop view controller
    func close() {
        router.close()
    }
    
    // Dismiss view controller
    func dismiss() {
        router.dismiss()
    }
    
    // Get item setup information by indexpath
    func getItemSetup(at indexPath: IndexPath,
                      completion: @escaping (String, DrugType, Int, FoodType, Bool) -> Void) {
        let drug = getItems(in: indexPath.section)[indexPath.row]
        completion(drug.name, 
                   drug.drugType,
                   drug.dose,
                   drug.foodType,
                   false)
    }
    
    // Get section title by section index
    func getSectionTitle(for section: Int) -> NSMutableAttributedString {
        let string = model.sections[section].rawValue
        let attributedString = NSMutableAttributedString(string: string)
        
        let font = Constants.Fonts.nunitoRegular16
        let color = Constants.Colors.white
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font,
                                      range: NSMakeRange(0, 
                                                         attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: color,
                                      range: NSMakeRange(0, 
                                                         attributedString.length))
        
        return attributedString
    }
    
    // Get number of rows by section index
    func numberOfRows(in section: Int) -> Int {
        return getItems(in: section).count
    }
    
    // MARK: Private functions
    // Get DrugInfo objects by section index
    private func getItems(in section: Int) -> [DrugInfo] {
        var list: [DrugInfo] = []
        let section = model.sections[section]
        drugInfoRepository.getDrugList().forEach { drug in
            if (drug.drugType == section) {
                list.append(drug)
            }
        }
        
        return list
    }
    
    // Get DrugType array
    private func getDrugsTypes() -> [DrugType] {
        var list: Set<DrugType> = []
        drugInfoRepository.getDrugList().forEach { drug in
            list.insert(drug.drugType)
        }
        let resultList = Array(list).sorted { $0.rawValue > $1.rawValue }
        
        return resultList
    }
}
