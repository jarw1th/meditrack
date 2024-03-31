import UIKit
import SnapKit

protocol PickerEditedDelegate {
    func backTapped()
    
    func doneTapped(_ value: Date)
}

final class TimePicker: UIViewController {
    private var tapDelegate: PickerEditedDelegate?
    
    private let backButton = UIButton()
    private let doneButton = UIButton()
    private let nameLabel = UILabel()
    private let picker = UIDatePicker()
    
    convenience init(name: String, view: PickerEditedDelegate) {
        self.init()
        nameLabel.text = name
        tapDelegate = view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.frame = CGRect(x: 0,
                            y: 480,
                            width: view.bounds.width,
                            height: 600)
        view.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews([backButton, nameLabel, doneButton, picker])
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
        
        view.backgroundColor = Constants.Colors.white
        view.layer.cornerRadius = 12
        
        let backAttributedString = NSAttributedString(string: Constants.Texts.buttonBackMain,
                                                      attributes: [
                                                        NSAttributedString.Key.foregroundColor: Constants.Colors.greenAccent,
                                                        NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16
                                                      ])
        backButton.setAttributedTitle(backAttributedString, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        nameLabel.textColor = Constants.Colors.grayPrimary
        nameLabel.font = Constants.Fonts.nunitoBold20
        nameLabel.textAlignment = .center
        
        let doneAttributedString = NSAttributedString(string: Constants.Texts.buttonDoneMain,
                                                      attributes: [
                                                        NSAttributedString.Key.foregroundColor: Constants.Colors.greenAccent,
                                                        NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16
                                                      ])
        doneButton.setAttributedTitle(doneAttributedString, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.setValue(Constants.Colors.grayPrimary, forKey: "textColor")
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true) {
            self.tapDelegate?.backTapped()
        }
    }
    
    @objc private func doneButtonAction() {
        dismiss(animated: true) {
            self.tapDelegate?.doneTapped(self.picker.date)
        }
    }
}
