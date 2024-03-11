import Foundation
import RealmSwift

protocol DrugCompletementRepositoryProtocol {
    func getCompletementList(date: Date) -> [String: (Bool, String)]
    
    func getCompletementInfo(by id: String, date: Date) -> Bool
    
    func setCompletementInfo(by id: String, objectId: String, date: Date, value: Bool)
    
    func checkCache(_ data: [DrugInfo])
    
    func clearData()
}

final class DrugCompletementRepository: DrugCompletementRepositoryProtocol {
    private let storage: DataService
    
    init(storage: DataService = DataService()) {
        self.storage = storage
    }
    
    func getCompletementList(date: Date) -> [String: (Bool, String)] {
        let data = storage.fetch(by: DrugCompletementRealm.self)
        var sortedByIdData: [DrugCompletementRealm] = []
        data.forEach({ el in
            if el.date.standartize() == date.standartize() { sortedByIdData.append(el) }
        })
        var resultData: [String: (Bool, String)] = [:]
        sortedByIdData.forEach({ el in
            resultData.updateValue((el.isCompleted, el.objectId.stringValue), forKey: el.id)
        })
        return resultData
    }
    
    func getCompletementInfo(by id: String, date: Date) -> Bool {
        let data = storage.fetch(by: DrugCompletementRealm.self)
        var resultData: Bool = false
        data.forEach({ el in
            if (el.id == id && el.date.standartize() == date.standartize()) { resultData = el.isCompleted }
        })
        return resultData
    }
    
    func setCompletementInfo(by id: String, objectId: String, date: Date, value: Bool) {
        let objectId = (try? ObjectId(string: objectId)) ?? ObjectId.generate()
        let object = DrugCompletementRealm(id: id,
                                           isCompleted: value,
                                           date: date.standartize(),
                                           objectId: objectId)
        try? storage.saveOrUpdateObject(object: object)
        
    }
    
    func checkCache(_ data: [DrugInfo]) {
        for drug in data {
            var startDate = drug.startDate
            let endDate = Calendar.current.date(byAdding: .weekOfYear,
                                                value: drug.duration,
                                                to: startDate) ?? Date()
            while startDate <= endDate {
                startDate =  Calendar.current.date(byAdding: .day,
                                                   value: 1,
                                                   to: startDate) ?? Date()
                let objects = storage.fetch(by: DrugCompletementRealm.self)
                let date = Calendar.current.date(byAdding: .day,
                                                 value: 1,
                                                 to: startDate)?.standartize() ?? Date()
                let object = DrugCompletementRealm(id: drug.id, isCompleted: false, date: date)
                let reason = checkExistens(objects: objects, object: object)
                
                if !reason { try? storage.saveOrUpdateAllObjects(objects: [object]) }
            }
        }
        
    }
    
    func clearData() {
        try? storage.deleteAll()
    }
    
    private func checkExistens(objects: [DrugCompletementRealm], object: DrugCompletementRealm) -> Bool {
        var resultBool = false
        objects.forEach({ el in
            if (el.id == object.id && el.date == object.date) { resultBool = true }
        })
        return resultBool
    }
}
