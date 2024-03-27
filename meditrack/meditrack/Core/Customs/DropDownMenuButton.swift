import UIKit
import SnapKit

protocol DropDownMenuDelegate {
    func backButtonTapped()
    
    func doneButtonTapped(_ value: String, type: FieldType)
}

final class DropDownMenu: UIView {
    private var tapDelegate: DropDownMenuDelegate?
    private var elements: [String]?
    private var type: FieldType?
    
    private let mainBackground = UIView()
    private let subBackground = UIView()
    private let backButton = UIButton()
    private let doneButton = UIButton()
    private let nameLabel = UILabel()
    private let picker = UIPickerView()
    
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
        
        picker.dataSource = self
        picker.delegate = self
    }
    
    @objc private func backButtonAction() {
        tapDelegate?.backButtonTapped()
    }
    
    @objc private func doneButtonAction() {
        let selectedRow = picker.selectedRow(inComponent: 0)
        let title = pickerView(picker, titleForRow: selectedRow, forComponent: 0) ?? ""
        tapDelegate?.doneButtonTapped(title,
                                      type: type ?? .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(view: DropDownMenuDelegate) {
        tapDelegate = view
    }
    
    func appear(name: String, elements: [String], type: FieldType) {
        nameLabel.text = name
        self.elements = elements
        self.type = type
        picker.reloadAllComponents()
        
        
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



