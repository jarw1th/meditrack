import RealmSwift

// MARK: - Object
final class DrugCompletementRealm: Object {
    // MARK: Variables
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var id: String
    @Persisted var isCompleted: Bool
    @Persisted var date: Date
    
    // MARK: Body
    // Initial
    convenience init(
        id: String,
        isCompleted: Bool,
        date: Date,
        objectId: ObjectId = ObjectId.generate()
    ) {
        self.init()
        self.id = id
        self.isCompleted = isCompleted
        self.date = date
        self.objectId = objectId
    }
}
