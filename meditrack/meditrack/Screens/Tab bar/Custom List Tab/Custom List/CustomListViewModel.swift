import Foundation

protocol CustomListViewModelProtocol {
    func getItem(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (String, String, DrugType) -> Void
    )
    
    func deleteItem(
        afterRowAt indexPath: IndexPath,
        completion: @escaping () -> Void
    )
    
    var numberOfRows: Int { get }// number of rows in table view
    
    var numberOfItems: Int { get } // number of items in collection view
    
    var todayIndex: Int { get }
    
    var selectedIndex: Int { get set }
    
    func setCompletement(
        objectId: String,
        id: String,
        value: Bool
    )
    
    func getCompletedList() -> [String: (Bool, String)]
    
    func getDate(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (Date) -> Void
    )
}

final class CustomListViewModel: CustomListViewModelProtocol {
    // MARK: - Variables
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    private let drugCompletementRepository: DrugCompletementRepositoryProtocol
    
    private var model = DatesModel()
    
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository(),
         drugCompletementRepository: DrugCompletementRepositoryProtocol = DrugCompletementRepository()) {
        self.drugInfoRepository = drugInfoRepository
        self.drugCompletementRepository = drugCompletementRepository
        
//        let test = DrugInfo(id: "",
//                            name: "Test 0",
//                            descriptionDrug: "Null",
//                            timeInterval: 0,
//                            duration: 3,
//                            frequency: .daily,
//                            drugType: .inhale,
//                            dose: 0,
//                            startDate: nil)
//        drugInfoRepository.saveDrugList([test])
        
        drugCompletementRepository.checkCache(drugInfoRepository.getDrugList())
        
        self.model.addDates(getDays())
        
        selectedIndex = todayIndex

    }
    
    // MARK: - Functions
    
    func getItem(afterRowAt indexPath: IndexPath, completion: @escaping (String, String, DrugType) -> Void) {
        let list = getItems(for: model.dates[selectedIndex])
        let id = list[indexPath.row].id
        let name = list[indexPath.row].name
        let drugType = list[indexPath.row].drugType
        completion(id, name, drugType)
    }
    
    func deleteItem(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void) {
        let item = getDrugInfoList()[indexPath.row]
        drugInfoRepository.deleteDrugList([item])
        completion()
    }
    
    var numberOfRows: Int {
        return getItems(for: self.model.dates[self.selectedIndex]).count
    }
    
    var numberOfItems: Int {
        return model.dates.count
    }
    
    var todayIndex: Int {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let date = Calendar.current.date(from: comps) ?? Date()
        return model.dates.firstIndex(of: date) ?? 0
    }
    
    var selectedIndex: Int = 0
    
    func getCompletedList() -> [String: (Bool, String)] {
        let list = drugCompletementRepository.getCompletementList(date: model.dates[selectedIndex])
        print(selectedIndex)
        return list
    }
    
    func setCompletement(
        objectId: String,
        id: String,
        value: Bool
    ) {
        drugCompletementRepository.setCompletementInfo(by: id,
                                                       objectId: objectId,
                                                       date: model.dates[selectedIndex],
                                                       value: value)
    }
    
    func getDate(afterRowAt indexPath: IndexPath, completion: @escaping (Date) -> Void) {
        let date = model.dates[indexPath.row]
        completion(date)
    }
    
    // MARK: - Private Functions
    private func getDrugInfoList() -> [DrugInfo] {
        return drugInfoRepository.getDrugList()
    }
    
    private func getDays(for month: Date = Date()) -> [Date] {
        let cal = Calendar.current
        let monthRange = cal.range(of: .day, in: .month, for: month)!
        let comps = cal.dateComponents([.year, .month], from: month)
        var date = cal.date(from: comps) ?? Date()
        
        var dates: [Date] = []
        for _ in monthRange {
            dates.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
    
    private func getItems(for day: Date) -> [DrugInfo] {
        var list: [DrugInfo] = []
        drugInfoRepository.getDrugList().forEach({ el in
            let startDate = el.startDate
            let endDate = Calendar.current.date(byAdding: .weekOfYear, value: el.duration, to: startDate) ?? Date()
            if day.isBetween(start: startDate, end: endDate) {
                list.append(el)
            }
        })
        return list
    }
}
