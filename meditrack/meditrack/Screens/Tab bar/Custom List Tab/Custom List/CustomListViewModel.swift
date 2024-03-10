import Foundation

protocol CustomListViewModelProtocol {
    func getItem(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (String, DrugType) -> Void
    )
    
    func deleteItem(
        afterRowAt indexPath: IndexPath,
        completion: @escaping () -> Void
    )
    
    var numberOfRows: Int { get } // number of rows in table view
    
    var numberOfItems: Int { get } // number of items in collection view
    
    func getDate(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (Date) -> Void
    )
}

final class CustomListViewModel: CustomListViewModelProtocol {
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    
    private var model = DatesModel()
    
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository()) {
        self.drugInfoRepository = drugInfoRepository
        self.model.addDates(getDays())
//        let test = DrugInfo(id: "",
//                            name: "Test 0",
//                            descriptionDrug: "Null",
//                            timeInterval: 0,
//                            duration: 0,
//                            frequency: .daily,
//                            drugType: .inhale,
//                            dose: 0,
//                            startDate: nil)
//        drugInfoRepository.saveDrugList([test])
    }
    
    func getItem(afterRowAt indexPath: IndexPath, completion: @escaping (String, DrugType) -> Void) {
        let name = drugInfoRepository.getDrugList()[indexPath.row].name
        let drugType = drugInfoRepository.getDrugList()[indexPath.row].drugType
        completion(name, drugType)
    }
    
    func deleteItem(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void) {
        let item = getDrugInfoList()[indexPath.row]
        drugInfoRepository.deleteDrugList([item])
        completion()
    }
    
    var numberOfRows: Int {
        return getDrugInfoList().count
    }
    
    var numberOfItems: Int {
        return model.dates.count
    }
    
    func getDate(afterRowAt indexPath: IndexPath, completion: @escaping (Date) -> Void) {
        let date = model.dates[indexPath.row]
        completion(date)
    }
    
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
}
