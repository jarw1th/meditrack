import Foundation

struct DrugCompletement {
    let id: String
    let isCompleted: Bool
    let date: Date // this date
    
    init(id: String,
         isCompleted: Bool,
         date: Date
    ) {
        self.id = id
        self.isCompleted = isCompleted
        self.date = date
    }
    
    init(object: DrugCompletementRealm) {
        self.init(id: object.id,
                  isCompleted: object.isCompleted,
                  date: object.date)
    }
}
