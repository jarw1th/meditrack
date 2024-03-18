import Foundation

protocol CustomListViewModelProtocol {
    func getItem(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (DrugInfo) -> Void
    )
    
    func deleteItem(
        afterRowAt indexPath: IndexPath,
        completion: @escaping () -> Void
    )
    
    func getSectionTitle(for section: Int) -> String
    
    var numberOfSections: Int { get } // number of sections in table view
    
    func numberOfRowsInSection(in section: Int) -> Int // number of rows in table view
    
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
    
    private var datesModel = DatesModel()
    private var sectionModel = SectionModel()
    
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository(),
         drugCompletementRepository: DrugCompletementRepositoryProtocol = DrugCompletementRepository()) {
        self.drugInfoRepository = drugInfoRepository
        self.drugCompletementRepository = drugCompletementRepository
        
        drugCompletementRepository.checkCache(drugInfoRepository.getDrugList())
        
        self.datesModel.addDates(getDays())
        
        selectedIndex = todayIndex
    }
    
    // MARK: - Functions
    
    func getItem(afterRowAt indexPath: IndexPath, completion: @escaping (DrugInfo) -> Void) {
        let list = getItems(for: date(), in: indexPath.section)[indexPath.row]
        completion(list)
    }
    
    func deleteItem(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void) {
        let item = getDrugInfoList()[indexPath.row]
        drugInfoRepository.deleteDrugList([item])
        completion()
    }
    
    func getSectionTitle(for section: Int) -> String {
        let section = sectionModel.sections[section]
        return timeIntervalConverter(for: section)
    }
    
    var numberOfSections: Int {
        sectionModel.addSections(getItemsInterval(for: date()))
        return sectionModel.sections.count
    }
    
    func numberOfRowsInSection(in section: Int) -> Int {
        return getItems(for: date(), in: section).count
    }
    
    var numberOfItems: Int {
        return datesModel.dates.count
    }
    
    var todayIndex: Int {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let date = Calendar.current.date(from: comps) ?? Date()
        return datesModel.dates.firstIndex(of: date) ?? 0
    }
    
    var selectedIndex: Int = 0
    
    func getCompletedList() -> [String: (Bool, String)] {
        let list = drugCompletementRepository.getCompletementList(date: datesModel.dates[selectedIndex])
        return list
    }
    
    func setCompletement(
        objectId: String,
        id: String,
        value: Bool
    ) {
        drugCompletementRepository.setCompletementInfo(by: id,
                                                       objectId: objectId,
                                                       date: datesModel.dates[selectedIndex],
                                                       value: value)
    }
    
    func getDate(afterRowAt indexPath: IndexPath, completion: @escaping (Date) -> Void) {
        let date = datesModel.dates[indexPath.row]
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
    
    private func getItems(for day: Date, in section: Int) -> [DrugInfo] {
        var list: [DrugInfo] = []
        drugInfoRepository.getDrugList().forEach({ el in
            var addNumber: Int = 1
            switch el.frequency {
            case .annually:
                addNumber = 365
            case .monthly:
                addNumber = datesModel.dates.count
            case .weekly:
                addNumber = 7
            case .daily:
                addNumber = 1
            }
            let startDate = el.startDate
            let endDate = Calendar.current.date(byAdding: .weekOfYear, value: el.duration, to: startDate) ?? Date()
            let difference = Calendar.current.dateComponents([.day], from: startDate, to: day).day ?? 1
            if (difference % addNumber == 0) && 
                (el.timeInterval == sectionModel.sections[section]) &&
                (day.isBetween(start: startDate, end: endDate)) {
                list.append(el)
            }
        })
        return list
    }
    
    private func date() -> Date {
        return datesModel.dates[selectedIndex]
    }
    
    private func getItemsInterval(for day: Date) -> [Date] {
        var list: Set<Date> = []
        drugInfoRepository.getDrugList().forEach({ el in
            var addNumber: Int = 1
            switch el.frequency {
            case .annually:
                addNumber = 365
            case .monthly:
                addNumber = datesModel.dates.count
            case .weekly:
                addNumber = 7
            case .daily:
                addNumber = 1
            }
            let startDate = el.startDate
            let endDate = Calendar.current.date(byAdding: .weekOfYear, value: el.duration, to: startDate) ?? Date()
            let difference = Calendar.current.dateComponents([.day], from: startDate, to: day).day ?? 1
            if (difference % addNumber == 0) && (day.isBetween(start: startDate, end: endDate)) {
                list.insert(el.timeInterval)
            }
        })
        let resultList = Array(list.sorted())
        return resultList
    }
    
    private func timeIntervalConverter(for start: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startString = dateFormatter.string(from: start)
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: start) ?? Date()
        let endString = dateFormatter.string(from: endDate)
        
        let resultString = "\(startString) - \(endString)"
        return resultString
    }
}
