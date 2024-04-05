import Foundation

// MARK: - Protocol
protocol DetailedScreenViewModelProtocol {
    var selectedDrug: DrugInfo? { get set }
    
    var precentsCompletement: Int { get }
    
    // Pop view controller
    func close(_ animated: Bool)
}

// MARK: - Class
final class DetailedScreenViewModel: DetailedScreenViewModelProtocol {
    // MARK: Variables
    // Route
    typealias Routes = DetailedScreenRoute & Closable
    
    // Genaral variables
    private let router: Routes
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    private let drugCompletementRepository: DrugCompletementRepositoryProtocol
    
    // Get number of sections
    var selectedDrug: DrugInfo? = nil
    
    var precentsCompletement: Int {
        guard let id = selectedDrug?.id else { return 0 }
        let list = drugCompletementRepository.getCompletementInfo(by: id)
        let trueItems = list.filter{ $0 }.count
        let falseItems = list.filter{ !$0 }.count
        if trueItems == 0 { return 0 }
        let number = Int(falseItems / trueItems)
        return number
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
    }
    
    // MARK: Functions
    // Pop view controller
    func close(_ animated: Bool) {
        router.close(animated: animated)
    }
    
    // MARK: Private functions
   
}
