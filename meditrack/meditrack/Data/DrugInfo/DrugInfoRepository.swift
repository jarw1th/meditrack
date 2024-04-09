import Foundation
import RealmSwift

// MARK: - Protocol
protocol DrugInfoRepositoryProtocol {
    // Getting list of DrugInfo objects
    func getDrugList() -> [DrugInfo]
    
    // Save DrugInfo objects
    func saveDrugList(_ data: [DrugInfo])
    
    // Delete DrugInfo objects
    func deleteDrugList(_ data: [DrugInfo])
    
    // Delete DrugInfo objects by id
    func deleteDrugList(by id: String)
    
    // Clear everything
    func clearData()
}

// MARK: - Class
final class DrugInfoRepository: DrugInfoRepositoryProtocol {
    // MARK: Variables
    // General variables
    private let storage: DataService
    
    // MARK: Body
    // Initial
    init(storage: DataService = DataService()) {
        self.storage = storage
    }
    
    // MARK: Functions
    // Getting list of DrugInfo objects
    func getDrugList() -> [DrugInfo] {
        let data = storage.fetch(by: DrugInfoRealm.self)
        return data.map(DrugInfo.init)
    }
    
    // Save DrugInfo objects
    func saveDrugList(_ data: [DrugInfo]) {
        let objects = data.map(DrugInfoRealm.init)
        try? storage.saveOrUpdateAllObjects(objects: objects)
    }
    
    // Delete DrugInfo objects
    func deleteDrugList(_ data: [DrugInfo]) {
        var objcts: [DrugInfoRealm] = []
        for el in data {
            let items = fetchDrugs()
            let filteredItems = items.filter { $0._id.stringValue == el.id }
            guard let item = filteredItems.first else { continue }
            objcts.append(item)
        }
        try? storage.delete(objects: objcts)
    }
    
    // Delete DrugInfo objects by id
    func deleteDrugList(by id: String) {
        let data = storage.fetch(by: DrugInfoRealm.self)
        
        var sortedByIdData: [DrugInfoRealm] = []
        data.forEach { el in
            if el._id.stringValue == id {
                sortedByIdData.append(el)
            }
        }
        
        guard !sortedByIdData.isEmpty else { return }
        
        try? storage.delete(objects: sortedByIdData)
    }
    
    // Clear everything
    func clearData() {
        try? storage.deleteAll()
    }
    
    // MARK: Private functions
    // Fetching DrugInfoRealm objects
    private func fetchDrugs() -> [DrugInfoRealm] {
        return storage.fetch(by: DrugInfoRealm.self)
    }
}
