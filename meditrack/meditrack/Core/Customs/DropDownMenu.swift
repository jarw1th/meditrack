import UIKit
import SnapKit

// MARK: - Delegate
protocol DropDownMenuDelegate {
    func backButtonTapped()
    
    func doneButtonTapped(_ value: String, 
                          type: FieldType)
}

// MARK: - Class
final class DropDownMenu: UIViewController {
    // MARK: Variables
    // General variables
    private var tapDelegate: DropDownMenuDelegate?
    private var elements: [String] = []
    private var type: FieldType?
    
    // UI elements
    private let backButton = UIButton()
    private let doneButton = UIButton()
    private let nameLabel = UILabel()
    private let picker = UIPickerView()
    
    // MARK: Body
    // Initial
    convenience init(name: String, 
                     elements: [String],
                     type: FieldType,
                     view: DropDownMenuDelegate) {
        self.init()
        
        nameLabel.text = name
        self.elements = elements
        self.type = type
        tapDelegate = view
        picker.reloadAllComponents()
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
    // Setting up constaraints
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
        
        picker.dataSource = self
        picker.delegate = self
        picker.setValue(Constants.Colors.grayPrimary, 
                        forKey: "textColor")
    }
    
    // Back button action
    @objc private func backButtonAction() {
        dismiss(animated: true) {
            self.tapDelegate?.backButtonTapped()
        }
    }
    
    // Done button action
    @objc private func doneButtonAction() {
        dismiss(animated: true) {
            let selectedRow = self.picker.selectedRow(inComponent: 0)
            let title = self.pickerView(self.picker, 
                                        titleForRow: selectedRow,
                                        forComponent: 0) ?? ""
            self.tapDelegate?.doneButtonTapped(title,
                                               type: self.type ?? .none)
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension DropDownMenu: UIPickerViewDataSource, UIPickerViewDelegate {
    // Components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Rows
    func pickerView(_ pickerView: UIPickerView, 
                    numberOfRowsInComponent component: Int) -> Int {
        let number = elements.count
        return number
    }
    
    // Titles
    func pickerView(_ pickerView: UIPickerView, 
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let title = elements[row]
        return title
    }
}



