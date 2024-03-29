import Foundation

enum NotificationMinutesType: String, CaseIterable {
    case m5, m10, m15, m20, m30, m45, m60
}

extension NotificationMinutesType {
    func getString() -> String {
        return "\(self.getNumberString()) \(Constants.Texts.enumNotificationsminutsSub)"
    }
    
    private func getNumberString() -> String {
        var string = self.rawValue
        string.removeFirst()
        return string
    }
}