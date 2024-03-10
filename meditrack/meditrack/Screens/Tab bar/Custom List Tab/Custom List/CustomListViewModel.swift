import Foundation

protocol CustomListViewModelProtocol {
    func getItem(
        index: Int,
        afterRowAt indexPath: IndexPath,
        completion: @escaping (String, DrugType) -> Void
    )
    
    func deleteItem(
        afterRowAt indexPath: IndexPath,
        completion: @escaping () -> Void
    )
    
    var numberOfRows: (_ index: Int) -> Int { get }// number of rows in table view
    
    var numberOfItems: Int { get } // number of items in collection view
    
    var todayIndex: Int { get }
    
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
//                            duration: 3,
//                            frequency: .daily,
//                            drugType: .inhale,
//                            dose: 0,
//                            startDate: nil)
//        drugInfoRepository.saveDrugList([test])
    }
    
    func getItem(index: Int, afterRowAt indexPath: IndexPath, completion: @escaping (String, DrugType) -> Void) {
        let list = getItems(for: model.dates[index])
        let name = list[indexPath.row].name
        let drugType = list[indexPath.row].drugType
        completion(name, drugType)
    }
    
    func deleteItem(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void) {
        let item = getDrugInfoList()[indexPath.row]
        drugInfoRepository.deleteDrugList([item])
        completion()
    }
    
    lazy var numberOfRows: (Int) -> Int = getItemsNumber
    
    var numberOfItems: Int {
        return model.dates.count
    }
    
    var todayIndex: Int {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var date = Calendar.current.date(from: comps) ?? Date()
        return model.dates.firstIndex(of: date) ?? 0
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

    private func getItemsNumber(_ index: Int) -> Int {
        let rows = getItems(for: model.dates[index]).count
        return rows
    }
}
