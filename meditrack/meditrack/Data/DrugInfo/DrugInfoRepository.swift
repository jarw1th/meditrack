import Foundation
import RealmSwift

protocol DrugInfoRepositoryProtocol {
    func getDrugList() -> [DrugInfo]
    
    func saveDrugList(_ data: [DrugInfo])
    
    func deleteDrugList(_ data: [DrugInfo])
    
    func clearData()
}

final class DrugInfoRepository: DrugInfoRepositoryProtocol {
    private let storage: DataService
    
    init(storage: DataService = DataService()) {
        self.storage = storage
    }
    
    func getDrugList() -> [DrugInfo] {
        let data = storage.fetch(by: DrugInfoRealm.self)
        return data.map(DrugInfo.init)
    }
    
    func saveDrugList(_ data: [DrugInfo]) {
        let objects = data.map(DrugInfoRealm.init)
        try? storage.saveOrUpdateAllObjects(objects: objects)
    }
    
    func deleteDrugList(_ data: [DrugInfo]) {
        var objcts: [DrugInfoRealm] = []
        for el in data {
            guard let item = fetchDrugs().filter({ $0._id.stringValue == el.id }).first else {continue}
            objcts.append(item)
        }
        try? storage.delete(objects: objcts)
    }
    
    func clearData() {
        try? storage.deleteAll()
    }
    
    private func fetchDrugs() -> [DrugInfoRealm] {
        return storage.fetch(by: DrugInfoRealm.self)
    }
}
