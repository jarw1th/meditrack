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
    private let timelineLabel = UILabel()
    
    private let doseMenuButton = DropDownMenuButton()
    private let doseMenu = UITableView()
    private let durationMenuButton = DropDownMenuButton()
    private let durationMenu = UITableView()
    private let frequencyMenuButton = DropDownMenuButton()
    private let frequencyMenu = UITableView()
    private let intervalMenuButton = TimePicker()
    
    
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
        
        view.addSubviews([navigationBar,
                          typeLabel,
                          typeCollectionView,
                          informationLabel,
                          nameTextField,
                          descriptionTextField,
                          timelineLabel,
                          doseMenuButton,
                          doseMenu,
                          durationMenuButton,
                          durationMenu,
                          frequencyMenuButton,
                          frequencyMenu,
                          intervalMenuButton])
        navigationBar.snp.makeConstraints({ make in
            make.leading.trailing.top.equalToSuperview()
        })
        typeLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(navigationBar.snp.bottom).inset(-8)
        })
        typeCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(120)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(typeLabel.snp.bottom)
        })
        informationLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(typeCollectionView.snp.bottom).inset(-24)
        })
        nameTextField.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(informationLabel.snp.bottom).inset(-16)
        })
        descriptionTextField.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(nameTextField.snp.bottom).inset(-8)
        })
        timelineLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(descriptionTextField.snp.bottom).inset(-24)
        })
        doseMenuButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(timelineLabel.snp.bottom).inset(-16)
        })
        durationMenuButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(doseMenuButton.snp.bottom).inset(-8)
        })
        frequencyMenuButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(durationMenuButton.snp.bottom).inset(-8)
        })
        intervalMenuButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(frequencyMenuButton.snp.bottom).inset(-8)
        })
        doseMenu.snp.makeConstraints({ make in
            make.width.equalTo(100)
            make.height.equalTo(200)
            make.trailing.equalTo(doseMenuButton.snp.trailing)
            make.bottom.equalTo(doseMenuButton.snp.top)
        })
        durationMenu.snp.makeConstraints({ make in
            make.width.equalTo(100)
            make.height.equalTo(200)
            make.trailing.equalTo(durationMenuButton.snp.trailing)
            make.bottom.equalTo(durationMenuButton.snp.top)
        })
        frequencyMenu.snp.makeConstraints({ make in
            make.width.equalTo(100)
            make.height.equalTo(200)
            make.trailing.equalTo(frequencyMenuButton.snp.trailing)
            make.bottom.equalTo(frequencyMenuButton.snp.top)
        })
        
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleMedicationMain)
        navigationBar.setImage(.left, image: Constants.Images.backIcon!)
        navigationBar.setImage(.right, image: Constants.Images.qrIcon!)
        
        typeLabel.text = Constants.Texts.labelTypeMain
        typeLabel.font = Constants.Fonts.nunitoBold20
        typeLabel.textColor = Constants.Colors.grayPrimary
        
        informationLabel.text = Constants.Texts.labelInformationMain
        informationLabel.font = Constants.Fonts.nunitoRegularTitle
        informationLabel.textColor = Constants.Colors.grayAccent
        
        nameTextField.placeholder = Constants.Texts.textfieldNameSub
        nameTextField.textColor = Constants.Colors.grayAccent
        nameTextField.backgroundColor = Constants.Colors.grayBackground
        nameTextField.layer.cornerRadius = 10
        nameTextField.setHorizontalPaddings(left: 16, right: 16)
        
        descriptionTextField.placeholder = Constants.Texts.textfieldDescriptionSub
        descriptionTextField.textColor = Constants.Colors.grayAccent
        descriptionTextField.backgroundColor = Constants.Colors.grayBackground
        descriptionTextField.layer.cornerRadius = 10
        descriptionTextField.setHorizontalPaddings(left: 16, right: 16)
        
        timelineLabel.text = Constants.Texts.labelTimelineMain
        timelineLabel.font = Constants.Fonts.nunitoRegularTitle
        timelineLabel.textColor = Constants.Colors.grayAccent
        
        doseMenuButton.layer.cornerRadius = 10
        doseMenuButton.setup(name: Constants.Texts.dropdownDoseSub, 
                             buttonName: Constants.Texts.buttonDefaultchooseSub,
                             view: self,
                             type: .dose)
        
        durationMenuButton.layer.cornerRadius = 10
        durationMenuButton.setup(name: Constants.Texts.dropdownDurationSub, 
                                 buttonName: Constants.Texts.buttonDefaultchooseSub,
                                 view: self,
                                 type: .duration)
        
        frequencyMenuButton.layer.cornerRadius = 10
        frequencyMenuButton.setup(name: Constants.Texts.dropdownFrequencySub, 
                                  buttonName: Constants.Texts.buttonDefaultchooseSub,
                                  view: self,
                                  type: .frequency)
        
        intervalMenuButton.layer.cornerRadius = 10
        intervalMenuButton.setup(name: Constants.Texts.timepickerTimeintervalSub,
                                 view: self)
    }
    
    private func setCollectionAndTable() {
        typeCollectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: "TypeCollectionViewCell")
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        
        [doseMenu, durationMenu, frequencyMenu].forEach({
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            $0.delegate = self
            $0.dataSource = self
            $0.isHidden.toggle()
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 2
            $0.layer.borderColor = Constants.Colors.grayBackground?.cgColor
            $0.tintColor = Constants.Colors.grayAccent
            $0.separatorColor = Constants.Colors.grayAccent
        })
    }
    
    private func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonAction() {
        guard let duration = viewModel?.convertDuration(durationMenuButton.getButtonName()) else { return }
        guard let frequency = FrequencyType(rawValue: frequencyMenuButton.getButtonName()) else { return }
        guard let dose = Int(doseMenuButton.getButtonName().first?.description ?? "0") else { return }
        let drugType = DrugType.allCases[viewModel?.selectedIndex ?? 0]
        if dose <= 1 {
            let drug = DrugInfo(id: "",
                               name: nameTextField.text ?? "",
                               descriptionDrug: descriptionTextField.text ?? "",
                               timeInterval: viewModel?.timeValue ?? Date(),
                               duration: duration,
                               frequency: frequency,
                               drugType: drugType,
                               dose: dose,
                               startDate: Date())
            viewModel?.createDrug(drug)
        } else {
            for element in 1...dose {
                let drug = DrugInfo(id: "",
                                   name: nameTextField.text ?? "",
                                   descriptionDrug: descriptionTextField.text ?? "",
                                   timeInterval: viewModel?.timeValue ?? Date(),
                                   duration: duration,
                                   frequency: frequency,
                                   drugType: drugType,
                                   dose: element,
                                   startDate: Date())
                viewModel?.createDrug(drug)
            }
        }
        self.navigationController?.popViewController(animated: true)
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
        case durationMenu:
            return viewModel?.numberOfDurationRows ?? 0
        case frequencyMenu:
            return viewModel?.numberOfFrequencyRows ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as UITableViewCell

        switch tableView {
        case doseMenu:
            cell.textLabel?.text = viewModel?.getDose(at: indexPath.row)
        case durationMenu:
            cell.textLabel?.text = viewModel?.getDuration(at: indexPath.row)
        case frequencyMenu:
            cell.textLabel?.text = viewModel?.getFrequency(at: indexPath.row)
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
        case durationMenu:
            let buttonName = viewModel?.getDuration(at: indexPath.row) ?? String()
            durationMenuButton.changeButtonName(buttonName)
            durationMenu.isHidden.toggle()
        case frequencyMenu:
            let buttonName = viewModel?.getFrequency(at: indexPath.row) ?? String()
            frequencyMenuButton.changeButtonName(buttonName)
            frequencyMenu.isHidden.toggle()
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
        case .duration:
            durationMenu.isHidden.toggle()
        case .frequency:
            frequencyMenu.isHidden.toggle()
        case .none:
            break
        }
    }
}

// MARK: - PickerEditedDelegate
extension AddDrugViewController: PickerEditedDelegate {
    func tap(_ value: Date) {
        viewModel?.timeValue = value
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
