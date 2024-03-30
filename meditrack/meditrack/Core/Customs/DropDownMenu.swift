import UIKit
import SnapKit

protocol DropDownMenuDelegate {
    func backButtonTapped()
    
    func doneButtonTapped(_ value: String, type: FieldType)
}

final class DropDownMenu: UIViewController {
    private var tapDelegate: DropDownMenuDelegate?
    private var elements: [String]?
    private var type: FieldType?
    
    private let backButton = UIButton()
    private let doneButton = UIButton()
    private let nameLabel = UILabel()
    private let picker = UIPickerView()
    
    convenience init(name: String, elements: [String], type: FieldType, view: DropDownMenuDelegate) {
        self.init()
        nameLabel.text = name
        self.elements = elements
        self.type = type
        tapDelegate = view
        picker.reloadAllComponents()
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
        
        picker.dataSource = self
        picker.delegate = self
        picker.setValue(Constants.Colors.grayPrimary, forKey: "textColor")
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true) {
            self.tapDelegate?.backButtonTapped()
        }
    }
    
    @objc private func doneButtonAction() {
        dismiss(animated: true) {
            let selectedRow = self.picker.selectedRow(inComponent: 0)
            let title = self.pickerView(self.picker, titleForRow: selectedRow, forComponent: 0) ?? ""
            self.tapDelegate?.doneButtonTapped(title,
                                               type: self.type ?? .none)
        }
    }
}

extension DropDownMenu: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let number = elements?.count else { return 0 }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let title = elements?[row] else { return "" }
        return title
    }
}



