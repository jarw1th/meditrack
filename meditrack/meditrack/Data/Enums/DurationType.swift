import Foundation

enum DurationType: String, CaseIterable {
    case w1, w2, w3, m1, m2, m3, m4, m5, y1
}

extension DurationType {
    func getString() -> String {
        return "\(self.getNumberString()) \(Constants.Texts.enumNotificationsminutsSub)"
    }
    
    private func getNumberString() -> String {
        var string = self.rawValue
        string.removeFirst()
        
        return string
    }
}
