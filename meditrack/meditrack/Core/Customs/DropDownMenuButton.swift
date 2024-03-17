import UIKit
import SnapKit

final class DropDownMenuButton: UIView {
    private let backgroundView = UIView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubviews([backgroundView, nameLabel])
        backgroundView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        nameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        })
        
        backgroundView.backgroundColor = Constants.Colors.grayBackground
        backgroundView.layer.cornerRadius = 10
        
        nameLabel.textColor = Constants.Colors.grayAccent
        nameLabel.font = Constants.Fonts.nunitoRegularSubtitle
        nameLabel.layer.opacity = 0.6
        nameLabel.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, buttonName: String) {
        nameLabel.text = name
    }
}
