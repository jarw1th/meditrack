import Foundation
import RealmSwift

protocol DrugInfoRepoProtocol {
    func getAirportList() -> [DrugInfo]
    func saveAirportList(_ data: [DrugInfo])
    func clearAirportList()
}

final class DrugInfoRepo: DrugInfoRepoProtocol {
    private let storage: DataService
    
    init(storage: DataService = DataService()) {
        self.storage = storage
    }
    
    func getAirportList() -> [DrugInfo] {
        let data = storage.fetch(by: DrugInfoRealm.self)
        return data.map(DrugInfo.init)
    }
    
    func saveAirportList(_ data: [DrugInfo]) {
        let objects = data.map(DrugInfoRealm.init)
        try? storage.saveOrUpdateAllObjects(objects: objects)
    }
    
    func clearAirportList() {
        try? storage.deleteAll()
    }
}
