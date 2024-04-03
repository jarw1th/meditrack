import UIKit
import SnapKit

// MARK: - Delegate
protocol PickerEditedDelegate {
    func backTapped()
    
    func doneTapped(_ value: Date)
}

// MARK: - Class
final class TimePicker: UIViewController {
    // MARK: Variables
    // General variables
    private var tapDelegate: PickerEditedDelegate?
    
    // UI elements
    private let backButton = UIButton()
    private let doneButton = UIButton()
    private let nameLabel = UILabel()
    private let picker = UIDatePicker()
    
    // MARK: Body
    // Initial
    convenience init(name: String,
                     view: PickerEditedDelegate) {
        self.init()
        
        nameLabel.text = name
        tapDelegate = view
    }
    
    // Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.frame = CGRect(x: 0,
                            y: view.bounds.height / 1.2,
                            width: view.bounds.width,
                            height: view.bounds.height / 1.4)
        view.layer.masksToBounds = true
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupUI()
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        view.addSubviews([backButton, 
                          nameLabel,
                          doneButton,
                          picker])
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.leading.equalTo(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.trailing.equalTo(-24)
        }
        picker.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        view.backgroundColor = Constants.Colors.white
        view.layer.cornerRadius = 12
        
        let buttonColor = Constants.Colors.greenAccent
        let buttonFont = Constants.Fonts.nunitoRegular16
        let attributes = [NSAttributedString.Key.foregroundColor: buttonColor,
                          NSAttributedString.Key.font: buttonFont]
        
        let backAttributedString = NSAttributedString(string: Constants.Texts.buttonBackMain,
                                                      attributes: attributes)
        backButton.setAttributedTitle(backAttributedString, 
                                      for: .normal)
        backButton.addTarget(self, 
                             action: #selector(backButtonAction),
                             for: .touchUpInside)
        
        nameLabel.textColor = Constants.Colors.grayPrimary
        nameLabel.font = Constants.Fonts.nunitoBold20
        nameLabel.textAlignment = .center
        
        let doneAttributedString = NSAttributedString(string: Constants.Texts.buttonDoneMain,
                                                      attributes: attributes)
        doneButton.setAttributedTitle(doneAttributedString, 
                                      for: .normal)
        doneButton.addTarget(self, 
                             action: #selector(doneButtonAction),
                             for: .touchUpInside)
        
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.setValue(Constants.Colors.grayPrimary, 
                        forKey: "textColor")
    }
    
    // Back button action
    @objc private func backButtonAction() {
        dismiss(animated: true) {
            self.tapDelegate?.backTapped()
        }
    }
    
    // Done button action
    @objc private func doneButtonAction() {
        dismiss(animated: true) {
            self.tapDelegate?.doneTapped(self.picker.date)
        }
    }
}
