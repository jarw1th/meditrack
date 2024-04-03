// MARK: - NotificationMinutesType Enum
enum NotificationMinutesType: String, CaseIterable {
    case m5, m10, m15, m20, m30, m45, m60
}

// MARK: - Extension Functions
extension NotificationMinutesType {
    // MARK: Functions
    // Getting string
    func getString() -> String {
        return "\(self.getNumberString()) \(Constants.Texts.enumNotificationsminutsSub)"
    }
    
    // MARK: Private Functions
    // Get number string
    private func getNumberString() -> String {
        var string = self.rawValue
        string.removeFirst()
        
        return string
    }
}
