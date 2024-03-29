import Foundation

protocol CustomListViewModelProtocol {
    func getItemId(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (String) -> Void
    ) // getting id of item
    
    func getItemSetup(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (String, DrugType, Int, FoodType, Bool) -> Void
    ) // getting name, drugtype, dose, iscompleted of item
    
    func getSectionTitle(
        for section: Int
    ) -> String // section title
    
    func numberOfRows(
        in section: Int
    ) -> Int // number of rows in table view
    
    func setCompletement(
        objectId: String,
        id: String,
        value: Bool
    ) // setting completement of item
    
    func getCompletedList() -> [String: (Bool, String)] // getting list of completed items
    
    func getDate(
        afterRowAt indexPath: IndexPath,
        completion: @escaping (Date) -> Void
    ) 
    
    var numberOfSections: Int { get } // number of sections in table view
    
    var numberOfItems: Int { get } // number of items in collection view
    
    var todayIndex: Int { get }
    
    var todayDate: String { get }
    
    var selectedIndex: Int { get set }
    
    var filterValue: DrugType { get set }
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
    func getItemId(afterRowAt indexPath: IndexPath, completion: @escaping (String) -> Void) {
        let list = getItems(for: date(), in: indexPath.section)[indexPath.row]
        completion(list.id)
    }
    
    func getItemSetup(afterRowAt indexPath: IndexPath, completion: @escaping (String, DrugType, Int, FoodType, Bool) -> Void
    ) {
        let drug = getItems(for: date(), in: indexPath.section)[indexPath.row]
        let filteredList = getCompletedList().filter({ $0.key == drug.id }).first?.value ?? (false, String())
        var isCompleted: Bool
        (isCompleted, _) = filteredList
        completion(drug.name, drug.drugType, drug.dose, drug.foodType, isCompleted)
    }
    
    func getSectionTitle(for section: Int) -> String {
        let section = sectionModel.sections[section]
        let converted = section.convertToTime()
        return converted
    }
    
    func numberOfRows(in section: Int) -> Int {
        return getItems(for: date(), in: section).count
    }
    
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
    
    // MARK: - Protocol Variables
    var numberOfSections: Int {
        sectionModel.addSections(getItemsInterval(for: date()))
        return sectionModel.sections.count
    }
    
    var numberOfItems: Int {
        return datesModel.dates.count
    }
    
    var todayIndex: Int {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let date = Calendar.current.date(from: comps) ?? Date()
        return datesModel.dates.firstIndex(of: date) ?? 0
    }
    
    var todayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        let date = datesModel.dates[selectedIndex]
        let selectedDateText = formatter.string(from: date)
        return selectedDateText
    }
    
    var selectedIndex: Int = 0
    
    var filterValue: DrugType = .all
    
    // MARK: - Private Functions
    // All drugs
    private func getDrugInfoList() -> [DrugInfo] {
        return drugInfoRepository.getDrugList()
    }
    
    // All days of month
    private func getDays(for day: Date = Date()) -> [Date] {
        let cal = Calendar.current
        var startDate = cal.date(byAdding: .day, value: -14, to: day) ?? Date()
        let endDate = cal.date(byAdding: .day, value: 14, to: day) ?? Date()
        let range = DateInterval(start: startDate, end: endDate)
        
        var dates: [Date] = []
        while range.contains(startDate) {
            dates.append(startDate.standartize())
            startDate = cal.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
    
    // Drugs for day in section
    private func getItems(for day: Date, in section: Int) -> [DrugInfo] {
        var list: [DrugInfo] = []
        drugInfoRepository.getDrugList().forEach({ el in
            let startDate = el.startDate
            let endDate = Calendar.current.date(byAdding: .weekOfYear, value: el.duration, to: startDate) ?? Date()
            let difference = Calendar.current.dateComponents([.day], from: startDate, to: day).day ?? 1
            if (checkFrequency(for: difference,
                               frequency: el.frequency)) &&
                (el.timeInterval.contains(sectionModel.sections[section])) &&
                (day.isBetween(start: startDate, end: endDate)) {
                list.append(el)
            }
        })
        return list
    }
    
    // Selected date
    private func date() -> Date {
        return datesModel.dates[selectedIndex]
    }
    
    // Time intervals for selected day
    private func getItemsInterval(for day: Date) -> [Date] {
        var list: Set<Date> = []
        drugInfoRepository.getDrugList().forEach { el in
            el.timeInterval.forEach { timeInterval in
                let startDate = el.startDate
                let endDate = Calendar.current.date(byAdding: .weekOfYear, value: el.duration, to: startDate) ?? Date()
                let difference = Calendar.current.dateComponents([.day], from: startDate, to: day).day ?? 1
                if (checkFrequency(for: difference, frequency: el.frequency)) &&
                    (day.isBetween(start: startDate, end: endDate)) {
                    list.insert(timeInterval)
                }
            }
        }
        let resultList = Array(list.sorted())
        return resultList
    }
    
    // Checking if date is in frequency position
    private func checkFrequency(for difference: Int, frequency: FrequencyType) -> Bool {
        var addNumber: Int = 1
        switch frequency {
        case .annually:
            addNumber = 365
        case .monthly:
            addNumber = datesModel.dates.count
        case .weekly:
            addNumber = 7
        case .daily:
            addNumber = 1
        }
        let result = (difference % addNumber == 0)
        return result
    }
}
