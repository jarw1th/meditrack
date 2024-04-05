import Foundation
import RealmSwift

// MARK: - Protocol
protocol DrugCompletementRepositoryProtocol {
    // Get completment list by date
    func getCompletementList(date: Date) -> [String: (Bool, String)]
    
    // Get completment status by id and date
    func getCompletementInfo(by id: String,
                             date: Date) -> Bool
    
    // Get completment status by id
    func getCompletementInfo(by id: String) -> [Bool]
    
    // Set completment status by id, object id, date
    func setCompletementInfo(by id: String,
                             objectId: String,
                             date: Date,
                             value: Bool)
    
    // Check cache by DrugInfo
    func checkCache(_ data: [DrugInfo])
    
    // Clear everything
    func clearData()
}

// MARK: - Class
final class DrugCompletementRepository: DrugCompletementRepositoryProtocol {
    // MARK: Variables
    // General variables
    private let storage: DataService
    
    // MARK: Body
    // Initial
    init(storage: DataService = DataService()) {
        self.storage = storage
    }
    
    // MARK: Functions
    // Get completment list by date
    func getCompletementList(date: Date) -> [String: (Bool, String)] {
        let data = storage.fetch(by: DrugCompletementRealm.self)
        
        var sortedByIdData: [DrugCompletementRealm] = []
        data.forEach { el in
            if el.date.standartize() == date.standartize() {
                sortedByIdData.append(el)
            }
        }
        
        var resultData: [String: (Bool, String)] = [:]
        sortedByIdData.forEach { el in
            resultData.updateValue((el.isCompleted, el.objectId.stringValue), 
                                   forKey: el.id)
        }
        
        return resultData
    }
    
    // Get completment status by id and date
    func getCompletementInfo(by id: String,
                             date: Date) -> Bool {
        let data = storage.fetch(by: DrugCompletementRealm.self)
        
        var resultData: Bool = false
        data.forEach { el in
            if (el.id == id) && (el.date.standartize() == date.standartize()) {
                resultData = el.isCompleted
            }
        }
        
        return resultData
    }
    
    // Get completment status by id
    func getCompletementInfo(by id: String) -> [Bool] {
        let data = storage.fetch(by: DrugCompletementRealm.self)
        
        var resultData: [Bool] = []
        data.forEach { el in
            if (el.id == id) {
                resultData.append(el.isCompleted)
            }
        }
        
        return resultData
    }
    
    // Set completment status by id, object id, date
    func setCompletementInfo(by id: String,
                             objectId: String,
                             date: Date,
                             value: Bool) {
        let objectId = (try? ObjectId(string: objectId)) ?? ObjectId.generate()
        let object = DrugCompletementRealm(id: id,
                                           isCompleted: value,
                                           date: date.standartize(),
                                           objectId: objectId)
        try? storage.saveOrUpdateObject(object: object)
    }
    
    // Check cache by DrugInfo
    func checkCache(_ data: [DrugInfo]) {
        for drug in data {
            var startDate = drug.startDate
            let endDate = Calendar.current.date(byAdding: .weekOfYear,
                                                value: drug.duration,
                                                to: startDate) ?? Date()
            var byAdding: Calendar.Component = .day
            
            switch drug.frequency {
            case .daily:
                byAdding = .day
            case .weekly:
                byAdding = .weekOfMonth
            case .monthly:
                byAdding = .month
            case .annually:
                byAdding = .year
            }
            
            while startDate <= endDate {
                startDate =  Calendar.current.date(byAdding: byAdding,
                                                   value: 1,
                                                   to: startDate) ?? Date()
                let objects = storage.fetch(by: DrugCompletementRealm.self)
                let date = Calendar.current.date(byAdding: byAdding,
                                                 value: 1,
                                                 to: startDate)?.standartize() ?? Date()
                let object = DrugCompletementRealm(id: drug.id, isCompleted: false, date: date)
                let reason = checkExistens(objects: objects, object: object)
                
                if !reason { try? storage.saveOrUpdateAllObjects(objects: [object]) }
            }
        }
    }
    
    // Clear everything
    func clearData() {
        try? storage.deleteAll()
    }
    
    // MARK: Private functions
    // Check object existens
    private func checkExistens(objects: [DrugCompletementRealm],
                               object: DrugCompletementRealm) -> Bool {
        var resultBool = false
        objects.forEach { el in
            if (el.id == object.id && el.date == object.date) { resultBool = true }
        }
        
        return resultBool
    }
}
