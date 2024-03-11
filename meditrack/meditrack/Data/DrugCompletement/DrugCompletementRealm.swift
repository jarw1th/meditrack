import RealmSwift

class DrugCompletementRealm: Object {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var id: String
    @Persisted var isCompleted: Bool
    @Persisted var date: Date
    
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
