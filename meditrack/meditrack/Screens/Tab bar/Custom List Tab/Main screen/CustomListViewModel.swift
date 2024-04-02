import Foundation

protocol CustomListViewModelProtocol {
    func getItemId(at indexPath: IndexPath,
                   completion: @escaping (String) -> Void) // getting id of item
    
    func getItemSetup(at indexPath: IndexPath,
                      completion: @escaping (String, DrugType, Int, FoodType, Bool) -> Void) // getting name, drugtype, dose, iscompleted of item
    
    func getSectionTitle(for section: Int) -> NSMutableAttributedString // section title
    
    func numberOfRows(in section: Int) -> Int // number of rows in table view
    
    func setCompletement(objectId: String,
                         id: String,
                         value: Bool) // setting completement of item
    
    func getCompletedList() -> [String: (Bool, String)] // getting list of completed items
    
    func getDate(at indexPath: IndexPath,
                 completion: @escaping (Date) -> Void)
    
    var numberOfSections: Int { get } // number of sections in table view
    
    var numberOfItems: Int { get } // number of items in collection view
    
    var todayIndex: Int { get }
    
    var todayDate: String { get }
    
    var selectedIndex: Int { get set }
}

final class CustomListViewModel: CustomListViewModelProtocol {
    // MARK: - Variables
    private let drugInfoRepository: DrugInfoRepositoryProtocol
    private let drugCompletementRepository: DrugCompletementRepositoryProtocol
    
    private var datesModel = CustomListDatesModel()
    private var sectionModel = CustomListSectionModel()
    
    init(drugInfoRepository: DrugInfoRepositoryProtocol = DrugInfoRepository(),
         drugCompletementRepository: DrugCompletementRepositoryProtocol = DrugCompletementRepository()) {
        self.drugInfoRepository = drugInfoRepository
        self.drugCompletementRepository = drugCompletementRepository
        
        drugCompletementRepository.checkCache(drugInfoRepository.getDrugList())
        
        self.datesModel.addDates(getDays())
        
        selectedIndex = todayIndex
    }
    
    // MARK: - Functions
    func getItemId(at indexPath: IndexPath, 
                   completion: @escaping (String) -> Void) {
        let lists = getItems(for: selectedDate,
                            in: indexPath.section)
        let list = lists[indexPath.row]
        completion(list.id)
    }
    
    func getItemSetup(at indexPath: IndexPath, 
                      completion: @escaping (String, DrugType, Int, FoodType, Bool) -> Void
    ) {
        let drugs = getItems(for: selectedDate,
                            in: indexPath.section)
        let drug = drugs[indexPath.row]
        let filteredList = getCompletedList().filter { $0.key == drug.id }
        let filteredValue = filteredList.first?.value ?? (false, String())
        var isCompleted: Bool
        (isCompleted, _) = filteredValue
        completion(drug.name, 
                   drug.drugType,
                   drug.dose,
                   drug.foodType,
                   isCompleted)
    }
    
    func getSectionTitle(for section: Int) -> NSMutableAttributedString {
        let section = sectionModel.sections[section]
        let converted = section.convertToTime()
        let attributedString = NSMutableAttributedString(string: converted)
        let font = Constants.Fonts.nunitoRegular16
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font,
                                      range: NSMakeRange(0, 
                                                         attributedString.length))
        
        if section.isBetween(start: Date(timeIntervalSince1970: 0), end: Date()) {
            let color = Constants.Colors.white
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: color,
                                          range: NSMakeRange(0, 
                                                             attributedString.length))
        } else {
            let color = Constants.Colors.white
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: color,
                                          range: NSMakeRange(0, 
                                                             attributedString.length))
        }
        
        return attributedString
    }
    
    func numberOfRows(in section: Int) -> Int {
        let items = getItems(for: selectedDate,
                             in: section)
        
        return items.count
    }
    
    func getCompletedList() -> [String: (Bool, String)] {
        let date = datesModel.dates[selectedIndex]
        let list = drugCompletementRepository.getCompletementList(date: date)
        
        return list
    }
    
    func setCompletement(objectId: String,
                         id: String,
                         value: Bool) {
        let date = datesModel.dates[selectedIndex]
        drugCompletementRepository.setCompletementInfo(by: id,
                                                       objectId: objectId,
                                                       date: date,
                                                       value: value)
    }
    
    func getDate(at indexPath: IndexPath, 
                 completion: @escaping (Date) -> Void) {
        let date = datesModel.dates[indexPath.row]
        
        completion(date)
    }
    
    // MARK: - Protocol Variables
    var numberOfSections: Int {
        sectionModel.addSections(getItemsInterval(for: selectedDate))
        
        return sectionModel.sections.count
    }
    
    var numberOfItems: Int {
        return datesModel.dates.count
    }
    
    var todayIndex: Int {
        let comps = Calendar.current.dateComponents([.year, .month, .day], 
                                                    from: Date())
        let date = Calendar.current.date(from: comps) ?? Date()
        let index = datesModel.dates.firstIndex(of: date) ?? 0
        
        return index
    }
    
    var todayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        let date = datesModel.dates[selectedIndex]
        let selectedDateText = formatter.string(from: date)
        
        return selectedDateText
    }
    
    var selectedIndex: Int = 0
    
    // MARK: - Private Functions
    // All drugs
    private func getDrugInfoList() -> [DrugInfo] {
        return drugInfoRepository.getDrugList()
    }
    
    // All days of month
    private func getDays(for day: Date = Date()) -> [Date] {
        let cal = Calendar.current
        var startDate = cal.date(byAdding: .day, 
                                 value: -14,
                                 to: day) ?? Date()
        let endDate = cal.date(byAdding: .day, 
                               value: 14,
                               to: day) ?? Date()
        let range = DateInterval(start: startDate, 
                                 end: endDate)
        
        var dates: [Date] = []
        while range.contains(startDate) {
            dates.append(startDate.standartize())
            startDate = cal.date(byAdding: .day, 
                                 value: 1,
                                 to: startDate)!
        }
        
        return dates
    }
    
    // Drugs for day in section
    private func getItems(for day: Date, 
                          in section: Int) -> [DrugInfo] {
        var list: [DrugInfo] = []
        drugInfoRepository.getDrugList().forEach { drug in
            let startDate = drug.startDate
            let endDate = Calendar.current.date(byAdding: .weekOfYear,
                                                value: drug.duration,
                                                to: startDate) ?? Date()
            let difference = Calendar.current.dateComponents([.day], 
                                                             from: startDate,
                                                             to: day).day ?? 1
            
            let reason1 = checkFrequency(for: difference,
                                         frequency: drug.frequency)
            let reason2 = drug.timeInterval.contains(sectionModel.sections[section])
            let reason3 = day.isBetween(start: startDate,
                                        end: endDate)
            
            if (reason1) && (reason2) && (reason3) {
                list.append(drug)
            }
        }
        
        return list
    }
    
    // Selected date
    private var selectedDate: Date {
        return datesModel.dates[selectedIndex]
    }
    
    // Time intervals for selected day
    private func getItemsInterval(for day: Date) -> [Date] {
        var list: Set<Date> = []
        drugInfoRepository.getDrugList().forEach { drug in
            drug.timeInterval.forEach { timeInterval in
                let startDate = drug.startDate
                let endDate = Calendar.current.date(byAdding: .weekOfYear, 
                                                    value: drug.duration, 
                                                    to: startDate) ?? Date()
                let difference = Calendar.current.dateComponents([.day], 
                                                                 from: startDate,
                                                                 to: day).day ?? 1
                
                let reason1 = checkFrequency(for: difference,
                                             frequency: drug.frequency)
                let reason2 = day.isBetween(start: startDate,
                                            end: endDate)
                
                if (reason1) && (reason2) {
                    list.insert(timeInterval)
                }
            }
        }
        let resultList = Array(list).sorted { $0 < $1 }
        
        return resultList
    }
    
    // Checking if date is in frequency position
    private func checkFrequency(for difference: Int, 
                                frequency: FrequencyType) -> Bool {
        var addNumber: Int = 1
        switch frequency {
        case .annually:
            addNumber = 365
        case .monthly:
            addNumber = 30
        case .weekly:
            addNumber = 7
        case .daily:
            addNumber = 1
        }
        let result = (difference % addNumber == 0)
        
        return result
    }
}
