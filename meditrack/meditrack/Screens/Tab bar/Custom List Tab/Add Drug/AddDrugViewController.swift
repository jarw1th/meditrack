import UIKit
import SnapKit

final class AddDrugViewController: UIViewController {
    // MARK: - Variables
    private var viewModel: AddDrugViewModelProtocol? {
        didSet {
            
        }
    }
    
    private let navigationBar = CustomNavigationBar()
    
    private let scrollView = UIScrollView()
    
    private let typeLabel = UILabel()
    private lazy var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    private let informationLabel = UILabel()
    private let nameTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let doseMenuButton = DropDownMenuButton()
    private let doseMenu = UITableView()
    
    private let timelineLabel = UILabel()
    private let intervalButton = UIButton()
    private let intervalPicker = TimePicker()
    private let intervalScrollView = UIScrollView()
    private let intervalStackView = UIStackView()
    
    
    // MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddDrugViewModel()
        
        setupUI()
        setCollectionAndTable()
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.backgroundColor = .white
        title = Constants.Texts.titleMedicationMain
        
        view.addSubviews([navigationBar, scrollView, intervalPicker])
        scrollView.addSubviews([typeLabel,
                                typeCollectionView,
                                informationLabel,
                                nameTextField,
                                descriptionTextField,
                                doseMenuButton,
                                doseMenu])
        scrollView.addSubviews([timelineLabel,
                                intervalButton,
                                intervalScrollView])
        intervalScrollView.addSubview(intervalStackView)
        
        navigationBar.snp.makeConstraints({ make in
            make.leading.trailing.top.equalToSuperview()
        })
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(navigationBar.snp.bottom).inset(-8)
            make.leading.trailing.bottom.equalToSuperview()
        })
        intervalPicker.snp.makeConstraints({ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        })
        
        typeLabel.snp.makeConstraints({ make in
            make.width.equalTo(self.view.frame.size.width - 48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalToSuperview()
        })
        typeCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(120)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(typeLabel.snp.bottom)
        })
        informationLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(typeCollectionView.snp.bottom).inset(-8)
        })
        nameTextField.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(informationLabel.snp.bottom).inset(-16)
        })
        descriptionTextField.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(nameTextField.snp.bottom).inset(-16)
        })
        doseMenuButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(descriptionTextField.snp.bottom).inset(-16)
        })
        doseMenu.snp.makeConstraints({ make in
            make.width.equalTo(100)
            make.height.equalTo(200)
            make.trailing.equalTo(doseMenuButton.snp.trailing)
            make.bottom.equalTo(doseMenuButton.snp.top)
        })
        
        timelineLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(doseMenuButton.snp.bottom).inset(-24)
        })
        intervalButton.snp.makeConstraints({ make in
            make.height.width.equalTo(36)
            make.leading.equalTo(24)
            make.top.equalTo(timelineLabel.snp.bottom).inset(-16)
        })
        intervalScrollView.snp.makeConstraints({ make in
            make.height.equalTo(36)
            make.top.equalTo(timelineLabel.snp.bottom).inset(-16)
            make.leading.equalTo(intervalButton.snp.trailing).inset(-16)
            make.trailing.equalTo(-24)
        })
        intervalStackView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleMedicationMain)
        navigationBar.setImage(.left, image: Constants.Images.backIcon!)
        navigationBar.setImage(.right, image: Constants.Images.qrIcon!)
        
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.contentSize = self.view.frame.size
        
        intervalPicker.setup(name: Constants.Texts.timepickerTimeintervalSub,
                             view: self)
        intervalPicker.isHidden = true
        
        
        typeLabel.text = Constants.Texts.labelTypeMain
        typeLabel.font = Constants.Fonts.nunitoBold20
        typeLabel.textColor = Constants.Colors.grayPrimary
        
        informationLabel.text = Constants.Texts.labelInformationMain
        informationLabel.font = Constants.Fonts.nunitoBold20
        informationLabel.textColor = Constants.Colors.grayPrimary
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: Constants.Texts.textfieldNameSub,
                                                                 attributes: [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12!,
                                                                              NSAttributedString.Key.foregroundColor: Constants.Colors.graySecondary!])
        nameTextField.textColor = Constants.Colors.grayPrimary
        nameTextField.font = Constants.Fonts.nunitoRegular12
        nameTextField.backgroundColor = Constants.Colors.grayBackground
        nameTextField.layer.cornerRadius = 12
        nameTextField.setHorizontalPaddings(left: 16, right: 16)
        
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: Constants.Texts.textfieldDescriptionSub,
                                                                        attributes: [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12!,
                                                                                     NSAttributedString.Key.foregroundColor: Constants.Colors.graySecondary!])
        descriptionTextField.textColor = Constants.Colors.grayPrimary
        descriptionTextField.font = Constants.Fonts.nunitoRegular12
        descriptionTextField.backgroundColor = Constants.Colors.grayBackground
        descriptionTextField.layer.cornerRadius = 12
        descriptionTextField.setHorizontalPaddings(left: 16, right: 16)
        
        doseMenuButton.layer.cornerRadius = 10
        doseMenuButton.setup(name: Constants.Texts.dropdownDoseSub,
                             buttonName: Constants.Texts.buttonDefaultchooseSub,
                             view: self,
                             type: .dose)
        
        timelineLabel.text = Constants.Texts.labelTimelineMain
        timelineLabel.font = Constants.Fonts.nunitoBold20
        timelineLabel.textColor = Constants.Colors.grayPrimary
        
        intervalButton.setImage(Constants.Images.plusIcon?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.white),
                                for: .normal)
        intervalButton.addTarget(self, action: #selector(intervalButtonAction), for: .touchUpInside)
        intervalButton.backgroundColor = Constants.Colors.greenAccent
        intervalButton.layer.cornerRadius = 8
        
        intervalScrollView.bounces = false
        intervalScrollView.isScrollEnabled = true
        intervalScrollView.showsHorizontalScrollIndicator = false
        intervalStackView.axis = .horizontal
        intervalStackView.spacing = 16
        intervalStackView.contentMode = .center
    }
    
    private func setCollectionAndTable() {
        typeCollectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: "TypeCollectionViewCell")
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        
        [doseMenu].forEach({
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            $0.delegate = self
            $0.dataSource = self
            $0.isHidden.toggle()
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 2
            $0.layer.borderColor = Constants.Colors.grayBackground?.cgColor
            $0.tintColor = Constants.Colors.grayPrimary
            $0.separatorColor = Constants.Colors.grayPrimary
        })
    }
    
    private func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonAction() {
        guard let dose = Int(doseMenuButton.getButtonName().first?.description ?? "0") else { return }
        let drugType = DrugType.allCases[viewModel?.selectedIndex ?? 0]
        let drug = DrugInfo(id: "",
                           name: nameTextField.text ?? "",
                           descriptionDrug: descriptionTextField.text ?? "",
                           timeInterval: viewModel?.timeValue ?? Date(),
                           duration: 0,
                            frequency: .daily,
                           drugType: drugType,
                           dose: dose,
                           startDate: Date())
        viewModel?.createDrug(drug)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func intervalButtonAction() {
        intervalPicker.appear()
    }
}

// MARK: - CollectionView
extension AddDrugViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfItems else { return 0 }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as! TypeCollectionViewCell
        
        let isSelected = self.viewModel?.selectedIndex == indexPath.row
        let type = viewModel?.getItem(afterRowAt: indexPath) ?? .capsule
        cell.setup(type: type, isSelected: isSelected)

        return cell
    }
}

extension AddDrugViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let selectedIndex = IndexPath(row: viewModel?.selectedIndex ?? 0, section: 0)
        viewModel?.selectedIndex = indexPath.row
        collectionView.reloadItems(at: [indexPath, selectedIndex])
    }
}

extension AddDrugViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - TableView
extension AddDrugViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case doseMenu:
            return viewModel?.numberOfDoseRows ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as UITableViewCell

        switch tableView {
        case doseMenu:
            cell.textLabel?.text = viewModel?.getDose(at: indexPath.row)
        default:
            cell.textLabel?.text = String()
        }
        
        return cell
    }
}

extension AddDrugViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case doseMenu:
            let buttonName = viewModel?.getDose(at: indexPath.row) ?? String()
            doseMenuButton.changeButtonName(buttonName)
            doseMenu.isHidden.toggle()
        default:
            return
        }
    }
}

// MARK: - ButtonTapDelegate
extension AddDrugViewController: ButtonTapDelegate {
    func tap(type: DropDownMenuType) {
        switch type {
        case .dose:
            doseMenu.isHidden.toggle()
        default:
            break
        }
    }
}

// MARK: - PickerEditedDelegate
extension AddDrugViewController {
    @objc private func deleteInterval(sender: UIButton) {
        sender.removeFromSuperview()
    }
    
    private func createInterval(_ title: String) {
        let button = UIButton()
        let attributedString = NSAttributedString(string: title,
                                                  attributes: [
                                                    NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary!,
                                                    NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12!
                                                  ])
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(deleteInterval), for: .touchUpInside)
        button.backgroundColor = Constants.Colors.grayBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.layer.cornerRadius = 8
        intervalStackView.addArrangedSubview(button)
    }
}

extension AddDrugViewController: PickerEditedDelegate {
    func backTapped() {
        intervalPicker.disappear()
    }
    
    func doneTapped(_ value: Date) {
        viewModel?.timeValue = value
        intervalPicker.disappear()
        let title = value.convertToTime()
        createInterval(title)
    }
}

// MARK: - CustomNavigationBarDelegate
extension AddDrugViewController: CustomNavigationBarDelegate {
    func tapped(_ button: ButtonType) {
        switch button {
        case .left:
            backButtonAction()
        case .right:
            break
        }
    }
}
