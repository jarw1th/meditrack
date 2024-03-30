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
    private let doneButton = UIButton()
    
    private let typeLabel = UILabel()
    private lazy var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = Constants.Colors.white
        return collection
    }()
    private let informationLabel = UILabel()
    private let nameTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let doseField = ButtonField()
    
    private let timelineLabel = UILabel()
    private let intervalButton = UIButton()
    private let intervalScrollView = UIScrollView()
    private let intervalStackView = UIStackView()
    private let durationField = ButtonField()
    private let frequencyField = ButtonField()
    
    private let foodLabel = UILabel()
    private lazy var foodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = Constants.Colors.white
        return collection
    }()
    
    private let notificationsLabel = UILabel()
    private let notificationsButton = UIButton()
    private let notificationsScrollView = UIScrollView()
    private let notificationsStackView = UIStackView()
    
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
        
        view.addSubviews([navigationBar, scrollView, doneButton])
        scrollView.addSubviews([typeLabel,
                                typeCollectionView,
                                informationLabel,
                                nameTextField,
                                descriptionTextField,
                                doseField])
        scrollView.addSubviews([timelineLabel,
                                intervalButton,
                                intervalScrollView,
                                durationField,
                                frequencyField])
        intervalScrollView.addSubview(intervalStackView)
        scrollView.addSubviews([foodLabel,
                                foodCollectionView])
        scrollView.addSubviews([notificationsLabel,
                                notificationsButton,
                                notificationsScrollView])
        notificationsScrollView.addSubview(notificationsStackView)
        
        navigationBar.snp.makeConstraints({ make in
            make.leading.trailing.top.equalToSuperview()
        })
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(navigationBar.snp.bottom).inset(-8)
            make.leading.trailing.bottom.equalToSuperview()
        })
        doneButton.snp.makeConstraints({ make in
            make.height.equalTo(64)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.bottom.equalTo(-48)
        })
    
        typeLabel.snp.makeConstraints({ make in
            make.width.equalTo(view.frame.size.width - 48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalToSuperview()
        })
        typeCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(88)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(typeLabel.snp.bottom).inset(-16)
        })
        informationLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(typeCollectionView.snp.bottom).inset(-24)
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
        doseField.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(descriptionTextField.snp.bottom).inset(-16)
        })
        
        timelineLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(doseField.snp.bottom).inset(-24)
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
        durationField.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(intervalButton.snp.bottom).inset(-16)
        })
        frequencyField.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(durationField.snp.bottom).inset(-16)
        })
        
        foodLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(frequencyField.snp.bottom).inset(-24)
        })
        foodCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(64)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(foodLabel.snp.bottom).inset(-16)
        })
        
        notificationsLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(foodCollectionView.snp.bottom).inset(-24)
        })
        notificationsButton.snp.makeConstraints({ make in
            make.height.width.equalTo(36)
            make.leading.equalTo(24)
            make.top.equalTo(notificationsLabel.snp.bottom).inset(-16)
            make.bottom.equalTo(-120)
        })
        notificationsScrollView.snp.makeConstraints({ make in
            make.height.equalTo(36)
            make.top.equalTo(notificationsLabel.snp.bottom).inset(-16)
            make.leading.equalTo(notificationsButton.snp.trailing).inset(-16)
            make.trailing.equalTo(-24)
        })
        notificationsStackView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleMedicationMain)
        navigationBar.setImage(.left, image: Constants.Images.backIcon!)
        navigationBar.setImage(.right, image: Constants.Images.qrIcon!)
        
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(gesture)
        
        doneButton.setAttributedTitle(NSAttributedString(string: Constants.Texts.buttonDoneMain,
                                                         attributes: [NSAttributedString.Key.font: Constants.Fonts.nunitoBold20!,
                                                                      NSAttributedString.Key.foregroundColor: Constants.Colors.white]),
                                      for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        doneButton.backgroundColor = Constants.Colors.greenAccent
        doneButton.layer.cornerRadius = 16
        
        
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
        nameTextField.delegate = self
        
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: Constants.Texts.textfieldDescriptionSub,
                                                                        attributes: [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12!,
                                                                                     NSAttributedString.Key.foregroundColor: Constants.Colors.graySecondary!])
        descriptionTextField.textColor = Constants.Colors.grayPrimary
        descriptionTextField.font = Constants.Fonts.nunitoRegular12
        descriptionTextField.backgroundColor = Constants.Colors.grayBackground
        descriptionTextField.layer.cornerRadius = 12
        descriptionTextField.setHorizontalPaddings(left: 16, right: 16)
        descriptionTextField.delegate = self
        
        doseField.layer.cornerRadius = 12
        doseField.setup(name: Constants.Texts.dropdownDoseSub,
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
        
        durationField.layer.cornerRadius = 12
        durationField.setup(name: Constants.Texts.dropdownDurationSub,
                            buttonName: Constants.Texts.buttonDefaultchooseSub,
                            view: self,
                            type: .duration)
        
        frequencyField.layer.cornerRadius = 12
        frequencyField.setup(name: Constants.Texts.dropdownFrequencySub,
                             buttonName: Constants.Texts.buttonDefaultchooseSub,
                             view: self,
                             type: .frequency)
        
        
        foodLabel.text = Constants.Texts.labelFoodMain
        foodLabel.font = Constants.Fonts.nunitoBold20
        foodLabel.textColor = Constants.Colors.grayPrimary
        
        
        notificationsLabel.text = Constants.Texts.labelNotificationsMain
        notificationsLabel.font = Constants.Fonts.nunitoBold20
        notificationsLabel.textColor = Constants.Colors.grayPrimary
        
        notificationsButton.setImage(Constants.Images.plusIcon?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.white),
                                     for: .normal)
        notificationsButton.addTarget(self, action: #selector(notificationsButtonAction), for: .touchUpInside)
        notificationsButton.backgroundColor = Constants.Colors.greenAccent
        notificationsButton.layer.cornerRadius = 8
        
        notificationsScrollView.bounces = false
        notificationsScrollView.isScrollEnabled = true
        notificationsScrollView.showsHorizontalScrollIndicator = false
        notificationsStackView.axis = .horizontal
        notificationsStackView.spacing = 16
        notificationsStackView.contentMode = .center
    }
    
    private func setCollectionAndTable() {
        typeCollectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: "TypeCollectionViewCell")
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        
        foodCollectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCollectionViewCell")
        foodCollectionView.dataSource = self
        foodCollectionView.delegate = self
    }
    
    @objc private func doneButtonAction() {
        let name = nameTextField.text
        let description = descriptionTextField.text
        let checker = viewModel?.checkOptional(name: name, description: description) ?? false
        guard checker else {
            showAlert()
            return
        }
        let timeIntervalSet = viewModel?.timeInterval?.reduce(into: Set<Date>()) { (times, time) in
            times.insert(time)
        }
        let timeInterval = timeIntervalSet?.reduce(into: Array<Date>()) { (times, time) in
            times.append(time)
        }
        let duration = viewModel?.duration
        let frequency = viewModel?.frequency
        let drugType = viewModel?.drugType
        let foodType = viewModel?.foodType
        let notifications = viewModel?.notifications
        let dose = viewModel?.dose
        let drug = DrugInfo(id: nil,
                            name: name,
                            descriptionDrug: description,
                            timeInterval: timeInterval,
                            duration: duration,
                            frequency: frequency,
                            drugType: drugType,
                            foodType: foodType,
                            notifications: notifications,
                            dose: dose,
                            startDate: Date())
        viewModel?.createDrug(drug)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAlert() {
        let titleAttributedString = NSAttributedString(string: Constants.Texts.alertTitleMain,
                                                  attributes: [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16!,
                                                               NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary!])
        let alert = UIAlertController(title: titleAttributedString.string,
                                      message: "",
                                      preferredStyle: .alert)
        alert.setValue(titleAttributedString, forKey: "attributedTitle")
        let action = UIAlertAction(title: Constants.Texts.alertOkSub,
                                   style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @objc private func intervalButtonAction() {
        present(TimePicker(name: Constants.Texts.timepickerTimeintervalSub, view: self), animated: true)
    }
    
    @objc private func notificationsButtonAction() {
        present(DropDownMenu(name: Constants.Texts.pickerNotificationsSub,
                             elements: viewModel?.getNotifications() ?? [],
                             type: .none,
                             view: self),
                animated: true)
    }
    
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - CollectionView
extension AddDrugViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case typeCollectionView:
            return viewModel?.numberOfTypes ?? 0
        case foodCollectionView:
            return viewModel?.numberOfFood ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case typeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell",
                                                          for: indexPath) as! TypeCollectionViewCell
            let isSelected = self.viewModel?.selectedType == indexPath.row
            let type = viewModel?.getType(at: indexPath) ?? .capsule
            cell.setup(type: type, isSelected: isSelected)
            return cell
        case foodCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell",
                                                          for: indexPath) as! FoodCollectionViewCell
            let isSelected = self.viewModel?.selectedFood == indexPath.row
            let type = viewModel?.getFood(at: indexPath) ?? .noMatter
            cell.setup(type: type, isSelected: isSelected)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension AddDrugViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        switch collectionView {
        case typeCollectionView:
            let selectedIndex = IndexPath(row: viewModel?.selectedType ?? 0, section: 0)
            viewModel?.selectedType = indexPath.row
            collectionView.reloadItems(at: [indexPath, selectedIndex])
        case foodCollectionView:
            let selectedIndex = IndexPath(row: viewModel?.selectedFood ?? 0, section: 0)
            viewModel?.selectedFood = indexPath.row
            collectionView.reloadItems(at: [indexPath, selectedIndex])
        default:
            break
        }
    }
}

extension AddDrugViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case typeCollectionView:
            return CGSize(width: 88, height: 88)
        case foodCollectionView:
            return CGSize(width: 64, height: 64)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - ButtonFieldDelegate
extension AddDrugViewController: ButtonFieldDelegate {
    func tapped(_ type: FieldType) {
        switch type {
        case .dose:
            present(DropDownMenu(name: Constants.Texts.dropdownDoseSub,
                                 elements: viewModel?.getDoses() ?? [],
                                 type: type,
                                 view: self),
                    animated: true)
        case .duration:
            present(DropDownMenu(name: Constants.Texts.dropdownDurationSub,
                                 elements: viewModel?.getDurations() ?? [],
                                 type: type,
                                 view: self),
                    animated: true)
        case .frequency:
            present(DropDownMenu(name: Constants.Texts.dropdownFrequencySub,
                                 elements: viewModel?.getFrequency() ?? [],
                                 type: type,
                                 view: self),
                    animated: true)
        case .none:
            break
        }
    }
}

// MARK: - PickerEditedDelegate
extension AddDrugViewController {
    @objc private func deleteInterval(sender: UIButton) {
        let title = sender.attributedTitle(for: .normal)?.string ?? ""
        viewModel?.deleteInterval(title)
        sender.removeFromSuperview()
    }
    
    private func createInterval(_ title: String, value: Date) {
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
       
    }
    
    func doneTapped(_ value: Date) {
        print(1)
        viewModel?.timeInterval?.append(value)
        let title = value.convertToTime()
        createInterval(title, value: value)
    }
}

// MARK: - ButtonTapDelegate
extension AddDrugViewController {
    @objc private func deleteNotification(sender: UIButton) {
        let title = sender.attributedTitle(for: .normal)?.string ?? ""
        viewModel?.deleteNotification(title)
        sender.removeFromSuperview()
    }
    
    private func createNotification(_ title: String) {
        let button = UIButton()
        let attributedString = NSAttributedString(string: title,
                                                  attributes: [
                                                    NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary!,
                                                    NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12!
                                                  ])
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(deleteNotification), for: .touchUpInside)
        button.backgroundColor = Constants.Colors.grayBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.layer.cornerRadius = 8
        notificationsStackView.addArrangedSubview(button)
    }
}

extension AddDrugViewController: DropDownMenuDelegate {
    func backButtonTapped() {
       
    }
    
    func doneButtonTapped(_ value: String, type: FieldType) {
        switch type {
        case .dose:
            viewModel?.dose = value.getDose()
            doseField.changeButtonName(value)
        case .duration:
            viewModel?.duration = value.convertDuration()
            durationField.changeButtonName(value)
        case .frequency:
            viewModel?.frequency = FrequencyType(rawValue: value)
            frequencyField.changeButtonName(value)
        case .none:
            viewModel?.notifications?.append(value.getNotificationMinutesType())
            createNotification(value)
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddDrugViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

// MARK: - CustomNavigationBarDelegate
extension AddDrugViewController {
    private func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

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
