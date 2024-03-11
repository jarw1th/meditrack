import Foundation
import RealmSwift

final class DataService {
    private let storage: Realm?
    
    init(
        _ configuration: Realm.Configuration = Realm.Configuration()
    ) {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.storage = try? Realm(configuration: configuration)
    }
    
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(object, update: .all)
        }
    }
    
    func saveOrUpdateAllObjects(objects: [Object]) throws {
        try objects.forEach {
            try saveOrUpdateObject(object: $0)
        }
    }
    
    
    func delete(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.delete(object)
        }
    }
    
    func delete(objects: [Object]) throws {
        try objects.forEach {
            try delete(object: $0)
        }
    }
    
    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }
    
    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }
}

extension Results {
    func toArray() -> [Element] {
        .init(self)
    }
}

