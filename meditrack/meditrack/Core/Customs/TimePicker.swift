import UIKit
import SnapKit

protocol PickerEditedDelegate {
    func backTapped()
    
    func doneTapped(_ value: Date)
}

final class TimePicker: UIView {
    private var tapDelegate: PickerEditedDelegate?
    
    private let mainBackground = UIView()
    private let subBackground = UIView()
    private let backButton = UIButton()
    private let doneButton = UIButton()
    private let nameLabel = UILabel()
    private let picker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubviews([mainBackground, subBackground])
        mainBackground.snp.makeConstraints({ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        })
        subBackground.snp.makeConstraints({ make in
            make.height.equalTo(300)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).inset(-300)
        })
        subBackground.addSubviews([backButton, nameLabel, doneButton, picker])
        backButton.snp.makeConstraints({ make in
            make.top.equalTo(24)
            make.leading.equalTo(24)
        })
        nameLabel.snp.makeConstraints({ make in
            make.width.equalTo(200)
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
        })
        doneButton.snp.makeConstraints({ make in
            make.top.equalTo(24)
            make.trailing.equalTo(-24)
        })
        picker.snp.makeConstraints({ make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
        })
        
        mainBackground.backgroundColor = Constants.Colors.black
        mainBackground.layer.opacity = 0
        
        subBackground.backgroundColor = Constants.Colors.white
        subBackground.layer.cornerRadius = 12
        
        let backAttributedString = NSAttributedString(string: Constants.Texts.buttonBackMain,
                                                      attributes: [
                                                        NSAttributedString.Key.foregroundColor: Constants.Colors.greenAccent!,
                                                        NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16!
                                                      ])
        backButton.setAttributedTitle(backAttributedString, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        nameLabel.textColor = Constants.Colors.grayPrimary
        nameLabel.font = Constants.Fonts.nunitoBold20
        nameLabel.textAlignment = .center
        
        let doneAttributedString = NSAttributedString(string: Constants.Texts.buttonDoneMain,
                                                      attributes: [
                                                        NSAttributedString.Key.foregroundColor: Constants.Colors.greenAccent!,
                                                        NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16!
                                                      ])
        doneButton.setAttributedTitle(doneAttributedString, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.setValue(Constants.Colors.grayPrimary, forKey: "textColor")
    }
    
    @objc private func backButtonAction() {
        tapDelegate?.backTapped()
    }
    
    @objc private func doneButtonAction() {
        tapDelegate?.doneTapped(picker.date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, view: PickerEditedDelegate) {
        tapDelegate = view
        nameLabel.text = name
    }
    
    func appear() {
        subBackground.snp.remakeConstraints({ make in
            make.height.equalTo(300)
            make.leading.trailing.bottom.equalToSuperview()
        })
        self.isHidden.toggle()
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.mainBackground.layer.opacity = 0.4
            self?.layoutIfNeeded()
        })
    }
    
    func disappear() {
        subBackground.snp.remakeConstraints({ make in
            make.height.equalTo(300)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).inset(-300)
        })
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.mainBackground.layer.opacity = 0
            self?.layoutIfNeeded()
        }, completion: { _ in
            self.isHidden = true
        })
    }
}
