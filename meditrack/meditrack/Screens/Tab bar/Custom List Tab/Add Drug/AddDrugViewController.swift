import UIKit
import SnapKit

final class AddDrugViewController: UIViewController {
    // MARK: - Variables
    private var viewModel: AddDrugViewModelProtocol? {
        didSet {
            
        }
    }
    
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
    
    private let doseButton = UIButton()
    private let durationButton = UIButton()
    private let frequencyButton = UIButton()
    
    private let doneButton = UIButton()
    
    
    // MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddDrugViewModel()
        
        setupUI()
        
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
        })
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.backgroundColor = .white
        title = Constants.Texts.titleMedicationMain
        
        navigationController?.navigationBar.tintColor = Constants.Colors.grayAccent
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.Colors.grayAccent!,
                                                                   .font: Constants.Fonts.nunitoRegularTitle!]
        
        view.addSubviews([typeLabel, 
                          typeCollectionView,
                          informationLabel,
                          nameTextField,
                          descriptionTextField,
                          timelineLabel,
                          doneButton,
                          doseMenuButton,
                          doseButton,
                          doseMenu,
                          durationMenuButton,
                          durationButton,
                          durationMenu,
                          frequencyMenuButton,
                          frequencyButton,
                          frequencyMenu])
        typeLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
        })
        typeCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(120)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(typeLabel.snp.bottom).inset(-16)
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
        doseButton.snp.makeConstraints({ make in
            make.trailing.equalTo(doseMenuButton.snp.trailing).inset(16)
            make.centerY.equalTo(doseMenuButton.snp.centerY)
        })
        durationMenuButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(doseMenuButton.snp.bottom).inset(-8)
        })
        durationButton.snp.makeConstraints({ make in
            make.trailing.equalTo(durationMenuButton.snp.trailing).inset(16)
            make.centerY.equalTo(durationMenuButton.snp.centerY)
        })
        frequencyMenuButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(durationMenuButton.snp.bottom).inset(-8)
        })
        frequencyButton.snp.makeConstraints({ make in
            make.trailing.equalTo(frequencyMenuButton.snp.trailing).inset(16)
            make.centerY.equalTo(frequencyMenuButton.snp.centerY)
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
        doneButton.snp.makeConstraints({ make in
            make.height.equalTo(64)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(36)
        })
        
        typeLabel.text = Constants.Texts.labelTypeMain
        typeLabel.font = Constants.Fonts.nunitoRegularTitle
        typeLabel.textColor = Constants.Colors.grayAccent
        
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
        
        doneButton.setTitle(Constants.Texts.buttonDoneMain, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        doneButton.backgroundColor = Constants.Colors.greenAccent
        doneButton.titleLabel?.font = Constants.Fonts.nunitoMediumHeader1
        doneButton.layer.cornerRadius = 10
        
        doseMenuButton.layer.cornerRadius = 10
        doseMenuButton.setup(name: Constants.Texts.dropdownDoseSub, buttonName: Constants.Texts.buttonDefaultchooseSub)
        
        durationMenuButton.layer.cornerRadius = 10
        durationMenuButton.setup(name: Constants.Texts.dropdownDurationSub, buttonName: Constants.Texts.buttonDefaultchooseSub)
        
        frequencyMenuButton.layer.cornerRadius = 10
        frequencyMenuButton.setup(name: Constants.Texts.dropdownFrequencySub, buttonName: Constants.Texts.buttonDefaultchooseSub)
        
        [doseButton, durationButton, frequencyButton].forEach({
            $0.setTitle("Choose", for: .normal)
            $0.setTitleColor(Constants.Colors.grayAccent, for: .normal)
            $0.titleLabel?.font = Constants.Fonts.nunitoRegularSubtitle
            $0.titleLabel?.textAlignment = .right
        })
        doseButton.addTarget(self, action: #selector(doseButtonAction), for: .touchUpInside)
        durationButton.addTarget(self, action: #selector(durationButtonAction), for: .touchUpInside)
        frequencyButton.addTarget(self, action: #selector(frequencyButtonAction), for: .touchUpInside)
    }
    
    @objc private func doseButtonAction() {
        doseMenu.isHidden.toggle()
    }
    
    @objc private func durationButtonAction() {
        durationMenu.isHidden.toggle()
    }
    
    @objc private func frequencyButtonAction() {
        frequencyMenu.isHidden.toggle()
    }
    
    @objc private func doneButtonAction() {
        guard let duration = Int(durationButton.title(for: .normal)?.first?.description ?? "") else { return }
        guard let frequency = FrequencyType(rawValue: frequencyButton.title(for: .normal) ?? "") else { return }
        guard let dose = Int(doseButton.title(for: .normal)?.first?.description ?? "") else { return }
        let drugType = DrugType.allCases[viewModel?.selectedIndex ?? 0]
        let drug = DrugInfo(id: "",
                            name: nameTextField.text ?? "",
                            descriptionDrug: descriptionTextField.text ?? "",
                            timeInterval: Date(),
                            duration: duration,
                            frequency: frequency,
                            drugType: drugType,
                            dose: dose,
                            startDate: Date())
        viewModel?.createDrug(drug)
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
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
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
            doseButton.setTitle(buttonName, for: .normal)
            doseMenu.isHidden.toggle()
        case durationMenu:
            let buttonName = viewModel?.getDuration(at: indexPath.row) ?? String()
            durationButton.setTitle(buttonName, for: .normal)
            durationMenu.isHidden.toggle()
        case frequencyMenu:
            let buttonName = viewModel?.getFrequency(at: indexPath.row) ?? String()
            frequencyButton.setTitle(buttonName, for: .normal)
            frequencyMenu.isHidden.toggle()
        default:
            return
        }
    }
}
