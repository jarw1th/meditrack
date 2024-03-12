import UIKit
import SnapKit

final class DropDownMenuButton: UIView {
    private let backgroundView = UIView()
    private let nameLabel = UILabel()
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubviews([backgroundView, nameLabel, button])
        backgroundView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        nameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        })
        button.snp.makeConstraints({ make in
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        })
        
        backgroundView.backgroundColor = Constants.Colors.grayBackground
        backgroundView.layer.cornerRadius = 10
        
        nameLabel.textColor = Constants.Colors.grayAccent
        nameLabel.font = Constants.Fonts.nunitoRegularSubtitle
        nameLabel.layer.opacity = 0.6
        nameLabel.textAlignment = .left
        
        button.setTitleColor(Constants.Colors.grayAccent, for: .normal)
        button.titleLabel?.font = Constants.Fonts.nunitoRegularSubtitle
        button.titleLabel?.textAlignment = .right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, buttonName: String) {
        nameLabel.text = name
        button.setTitle(buttonName, for: .normal)
    }
    
    func changeButtonName(_ buttonName: String) {
        button.setTitle(buttonName, for: .normal)
    }
    
    func getButtonName() -> String {
        return button.titleLabel?.text ?? String()
    }
}
