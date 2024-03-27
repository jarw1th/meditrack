import UIKit
import SnapKit

protocol ButtonFieldDelegate {
    func tapped(_ type: FieldType)
}

enum FieldType {
    case dose, duration, frequency, none
}

final class ButtonField: UIView {
    private var tapDelegate: ButtonFieldDelegate?
    private var menuType: FieldType = .none
    
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
        
        nameLabel.textColor = Constants.Colors.grayPrimary
        nameLabel.font = Constants.Fonts.nunitoRegular12
        nameLabel.textAlignment = .left
        
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.setTitleColor(Constants.Colors.greenAccent, for: .normal)
        button.titleLabel?.font = Constants.Fonts.nunitoRegular12
        button.titleLabel?.textAlignment = .right
    }
    
    @objc private func tapped() {
        tapDelegate?.tapped(menuType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, buttonName: String, view: ButtonFieldDelegate, type: FieldType = .none) {
        tapDelegate = view
        nameLabel.text = name
        button.setTitle(buttonName, for: .normal)
        menuType = type
    }
    
    func changeButtonName(_ buttonName: String) {
        button.setTitle(buttonName, for: .normal)
    }
    
    func getButtonName() -> String {
        return button.title(for: .normal) ?? String()
    }
}
