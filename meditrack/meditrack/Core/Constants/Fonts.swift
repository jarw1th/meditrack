import UIKit

// MARK: - Fonts
extension Constants {
    // rule: (font name)(weight)(size)
    enum Fonts {
        // Default value
        private static let _none_ = UIFont.systemFont(ofSize: 100)
        
        
        // Regular
        static let nunitoRegular12 = UIFont(name: "Nunito-Regular", size: 12) ?? _none_
        
        static let nunitoRegular16 = UIFont(name: "Nunito-Regular", size: 16) ?? _none_
        
        static let nunitoRegular24 = UIFont(name: "Nunito-Regular", size: 24) ?? _none_
        
        // Medium
        static let nunitoMedium12 = UIFont(name: "Nunito-Medium", size: 12) ?? _none_
        
        static let nunitoMedium16 = UIFont(name: "Nunito-Medium", size: 16) ?? _none_
        
        static let nunitoMedium20 = UIFont(name: "Nunito-Medium", size: 20) ?? _none_
        
        // SemiBold
        static let nunitoSemiBold16 = UIFont(name: "Nunito-SemiBold", size: 16) ?? _none_
        
        static let nunitoSemiBold20 = UIFont(name: "Nunito-SemiBold", size: 20) ?? _none_
        
        // Bold
        static let nunitoBold20 = UIFont(name: "Nunito-Bold", size: 20) ?? _none_
        
        static let nunitoBold32 = UIFont(name: "Nunito-Bold", size: 32) ?? _none_
    }
}
