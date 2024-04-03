import RealmSwift

// MARK: - Class
final class DataService {
    // MARK: Variables
    // General variables
    private let storage: Realm?
    
    // MARK: Body
    // Initial
    init(
        _ configuration: Realm.Configuration = Realm.Configuration()
    ) {
        if let realmLocation = Realm.Configuration.defaultConfiguration.fileURL {
            let string = "Realm location := \(realmLocation)"
            print(string)
        }
        
        self.storage = try? Realm(configuration: configuration)
    }
    
    // MARK: Functions
    // Save or update single object
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(object, 
                        update: .all)
        }
    }
    
    // Save or update multiple objects
    func saveOrUpdateAllObjects(objects: [Object]) throws {
        try objects.forEach {
            try saveOrUpdateObject(object: $0)
        }
    }
    
    // Delete single object
    func delete(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.delete(object)
        }
    }
    
    // Delete multiple objects
    func delete(objects: [Object]) throws {
        try objects.forEach {
            try delete(object: $0)
        }
    }
    
    // Delete everything
    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }
    
    // Fetch objects by Realm object type
    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }
}

// MARK: - Results
extension Results {
    // Creatting array
    func toArray() -> [Element] {
        .init(self)
    }
}

