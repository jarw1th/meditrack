import UIKit
import SnapKit

// MARK: - Class
final class AddDrugViewController: UIViewController {
    // MARK: Variables
    // Genaral variables
    private var viewModel: AddDrugViewModelProtocol?
    
    // UI elements
    private let navigationBar = CustomNavigationBar()
    private let scrollView = UIScrollView()
    private let doneButton = UIButton()
    
    private let typeLabel = UILabel()
    private lazy var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, 
                                          collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, 
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
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
        let collection = UICollectionView(frame: .zero, 
                                          collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, 
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = Constants.Colors.white
        return collection
    }()
    
    private let notificationsLabel = UILabel()
    private let notificationsButton = UIButton()
    private let notificationsScrollView = UIScrollView()
    private let notificationsStackView = UIStackView()
    
    // MARK: Body
    // Initial
    convenience init(viewModel: AddDrugViewModelProtocol?) {
        self.init()
        
        self.viewModel = viewModel
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupUI()
        setCollectionAndTable()
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        view.addSubviews([navigationBar,
                          scrollView,
                          doneButton])
        
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
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).inset(-8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.bottom.equalTo(-48)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width - 48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalToSuperview()
        }
        typeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(88)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(typeLabel.snp.bottom).inset(-16)
        }
        informationLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(typeCollectionView.snp.bottom).inset(-24)
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(informationLabel.snp.bottom).inset(-16)
        }
        descriptionTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(nameTextField.snp.bottom).inset(-16)
        }
        doseField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(descriptionTextField.snp.bottom).inset(-16)
        }
        
        timelineLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(doseField.snp.bottom).inset(-24)
        }
        intervalButton.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.leading.equalTo(24)
            make.top.equalTo(timelineLabel.snp.bottom).inset(-16)
        }
        intervalScrollView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(timelineLabel.snp.bottom).inset(-16)
            make.leading.equalTo(intervalButton.snp.trailing).inset(-16)
            make.trailing.equalTo(-24)
        }
        intervalStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        durationField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(intervalButton.snp.bottom).inset(-16)
        }
        frequencyField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(durationField.snp.bottom).inset(-16)
        }
        
        foodLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(frequencyField.snp.bottom).inset(-24)
        }
        foodCollectionView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(foodLabel.snp.bottom).inset(-16)
        }
        
        notificationsLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(foodCollectionView.snp.bottom).inset(-24)
        }
        notificationsButton.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.leading.equalTo(24)
            make.top.equalTo(notificationsLabel.snp.bottom).inset(-16)
            make.bottom.equalTo(-120)
        }
        notificationsScrollView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(notificationsLabel.snp.bottom).inset(-16)
            make.leading.equalTo(notificationsButton.snp.trailing).inset(-16)
            make.trailing.equalTo(-24)
        }
        notificationsStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        view.backgroundColor = .white
        title = Constants.Texts.titleMedicationMain
        
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleMedicationMain)
        navigationBar.setImage(.left, 
                               image: Constants.Images.backIcon)
        navigationBar.setImage(.right, 
                               image: Constants.Images.qrIcon)
        
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        let gesture = UITapGestureRecognizer(target: self, 
                                             action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        let swipeGesture = UISwipeGestureRecognizer(target: self, 
                                                    action: #selector(backButtonAction))
        swipeGesture.cancelsTouchesInView = false
        swipeGesture.direction = .right
        scrollView.addGestureRecognizer(gesture)
        scrollView.addGestureRecognizer(swipeGesture)
        
        let doneButtonAttributest = [NSAttributedString.Key.font: Constants.Fonts.nunitoBold20,
                                     NSAttributedString.Key.foregroundColor: Constants.Colors.white]
        doneButton.setAttributedTitle(NSAttributedString(string: Constants.Texts.buttonDoneMain,
                                                         attributes: doneButtonAttributest),
                                      for: .normal)
        doneButton.addTarget(self, 
                             action: #selector(doneButtonAction),
                             for: .touchUpInside)
        doneButton.backgroundColor = Constants.Colors.greenAccent
        doneButton.layer.cornerRadius = 16
        
        
        typeLabel.text = Constants.Texts.labelTypeMain
        typeLabel.font = Constants.Fonts.nunitoBold20
        typeLabel.textColor = Constants.Colors.grayPrimary
        
        informationLabel.text = Constants.Texts.labelInformationMain
        informationLabel.font = Constants.Fonts.nunitoBold20
        informationLabel.textColor = Constants.Colors.grayPrimary
        
        let textFieldAttributest = [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12,
                                        NSAttributedString.Key.foregroundColor: Constants.Colors.graySecondary]
        nameTextField.attributedPlaceholder = NSAttributedString(string: Constants.Texts.textfieldNameSub,
                                                                 attributes: textFieldAttributest)
        nameTextField.textColor = Constants.Colors.grayPrimary
        nameTextField.font = Constants.Fonts.nunitoRegular12
        nameTextField.backgroundColor = Constants.Colors.grayBackground
        nameTextField.layer.cornerRadius = 12
        nameTextField.setHorizontalPaddings(left: 16, 
                                            right: 16)
        nameTextField.delegate = self
        
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: Constants.Texts.textfieldDescriptionSub,
                                                                        attributes: textFieldAttributest)
        descriptionTextField.textColor = Constants.Colors.grayPrimary
        descriptionTextField.font = Constants.Fonts.nunitoRegular12
        descriptionTextField.backgroundColor = Constants.Colors.grayBackground
        descriptionTextField.layer.cornerRadius = 12
        descriptionTextField.setHorizontalPaddings(left: 16, 
                                                   right: 16)
        descriptionTextField.delegate = self
        
        doseField.layer.cornerRadius = 12
        doseField.setup(name: Constants.Texts.dropdownDoseSub,
                        buttonName: Constants.Texts.buttonDefaultchooseSub,
                        view: self,
                        type: .dose)
        
        
        timelineLabel.text = Constants.Texts.labelTimelineMain
        timelineLabel.font = Constants.Fonts.nunitoBold20
        timelineLabel.textColor = Constants.Colors.grayPrimary
        
        intervalButton.setImage(Constants.Images.plusIcon.withTintColor(Constants.Colors.white,
                                                                        renderingMode: .alwaysOriginal),
                                for: .normal)
        intervalButton.addTarget(self, 
                                 action: #selector(intervalButtonAction),
                                 for: .touchUpInside)
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
        
        notificationsButton.setImage(Constants.Images.plusIcon.withTintColor(Constants.Colors.white,
                                                                             renderingMode: .alwaysOriginal),
                                     for: .normal)
        notificationsButton.addTarget(self, 
                                      action: #selector(notificationsButtonAction),
                                      for: .touchUpInside)
        notificationsButton.backgroundColor = Constants.Colors.greenAccent
        notificationsButton.layer.cornerRadius = 8
        
        notificationsScrollView.bounces = false
        notificationsScrollView.isScrollEnabled = true
        notificationsScrollView.showsHorizontalScrollIndicator = false
        notificationsStackView.axis = .horizontal
        notificationsStackView.spacing = 16
        notificationsStackView.contentMode = .center
    }
    
    // Setting up collections and tables view
    private func setCollectionAndTable() {
        typeCollectionView.register(TypeCollectionViewCell.self, 
                                    forCellWithReuseIdentifier: Constants.System.typeCollectionViewCell)
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        
        foodCollectionView.register(FoodCollectionViewCell.self, 
                                    forCellWithReuseIdentifier: Constants.System.foodCollectionViewCell)
        foodCollectionView.dataSource = self
        foodCollectionView.delegate = self
    }
    
    // Done button action
    @objc private func doneButtonAction() {
        let name = nameTextField.text
        let description = descriptionTextField.text
        let checker = viewModel?.checkOptional(name: name, 
                                               description: description) ?? false
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
        
        viewModel?.close()
    }
    
    // Showing alert
    private func showAlert() {
        let attributes = [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16,
                          NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary]
        let titleAttributedString = NSAttributedString(string: Constants.Texts.alertTitleMain,
                                                  attributes: attributes)
        
        let alert = UIAlertController(title: titleAttributedString.string,
                                      message: "",
                                      preferredStyle: .alert)
        alert.setValue(titleAttributedString, forKey: "attributedTitle")
        
        let action = UIAlertAction(title: Constants.Texts.alertOkSub,
                                   style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // Interval button action
    @objc private func intervalButtonAction() {
        let timePicker = TimePicker(name: Constants.Texts.timepickerTimeintervalSub, 
                                    view: self)
        present(timePicker, animated: true)
    }
    
    // Notification button action
    @objc private func notificationsButtonAction() {
        let dropDownMenu = DropDownMenu(name: Constants.Texts.pickerNotificationsSub,
                                        elements: viewModel?.getNotifications() ?? [],
                                        type: .none,
                                        view: self)
        present(dropDownMenu,
                animated: true)
    }
    
    // Hide keyboard action by gesture
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - Collection View
extension AddDrugViewController: UICollectionViewDataSource, 
                                 UICollectionViewDelegate,
                                 UICollectionViewDelegateFlowLayout {
    // MARK: Functions
    // Number of items in section
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case typeCollectionView:
            return viewModel?.numberOfTypes ?? 0
        case foodCollectionView:
            return viewModel?.numberOfFood ?? 0
        default:
            return 0
        }
    }
    
    // Cell for item
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case typeCollectionView:
            let cell = typeCollectionViewCell(collectionView,
                                              cellForItemAt: indexPath)
            return cell
        case foodCollectionView:
            let cell = foodCollectionViewCell(collectionView,
                                              cellForItemAt: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Did select item
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
        
        switch collectionView {
        case typeCollectionView:
            let selectedIndex = IndexPath(row: viewModel?.selectedType ?? 0,
                                          section: 0)
            viewModel?.selectedType = indexPath.row
            collectionView.reloadItems(at: [indexPath, selectedIndex])
        case foodCollectionView:
            let selectedIndex = IndexPath(row: viewModel?.selectedFood ?? 0,
                                          section: 0)
            viewModel?.selectedFood = indexPath.row
            collectionView.reloadItems(at: [indexPath, selectedIndex])
        default:
            break
        }
    }
    
    // Minimum inter item spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Size for item
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case typeCollectionView:
            return CGSize(width: 88,
                          height: 88)
        case foodCollectionView:
            return CGSize(width: 64,
                          height: 64)
        default:
            return CGSize.zero
        }
    }
    
    // Minimum line spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // MARK: Private functions
    // Cell for type collection view item
    private func typeCollectionViewCell(_ collectionView: UICollectionView,
                                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = Constants.System.typeCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! TypeCollectionViewCell
        let isSelected = (self.viewModel?.selectedType == indexPath.row)
        let type = viewModel?.getType(at: indexPath) ?? .capsule
        cell.setup(type: type, 
                   isSelected: isSelected)
        
        return cell
    }
    
    // Cell for food collection view item
    private func foodCollectionViewCell(_ collectionView: UICollectionView,
                                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = Constants.System.foodCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! FoodCollectionViewCell
        let isSelected = (self.viewModel?.selectedFood == indexPath.row)
        let type = viewModel?.getFood(at: indexPath) ?? .noMatter
        cell.setup(type: type, 
                   isSelected: isSelected)
        
        return cell
    }
}

// MARK: - ButtonFieldDelegate
extension AddDrugViewController: ButtonFieldDelegate {
    // MARK: Functions
    // Button action
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
extension AddDrugViewController: PickerEditedDelegate {
    // MARK: Functions
    // Back button action
    func backTapped() {
       
    }
    
    // Done button action
    func doneTapped(_ value: Date) {
        viewModel?.timeInterval?.append(value)
        let title = value.convertToTime()
        createInterval(title,
                       value: value)
    }
    
    // MARK: Private functions
    // Delete interval action
    @objc private func deleteInterval(sender: UIButton) {
        let title = sender.attributedTitle(for: .normal)?.string ?? ""
        viewModel?.deleteInterval(title)
        sender.removeFromSuperview()
    }
    
    // Creating button by interval title and value
    private func createInterval(_ title: String, value: Date) {
        let button = UIButton()
        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary,
                         NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12]
        let attributedString = NSAttributedString(string: title,
                                                  attributes: attributes)
        button.setAttributedTitle(attributedString, 
                                  for: .normal)
        button.addTarget(self, 
                         action: #selector(deleteInterval),
                         for: .touchUpInside)
        button.backgroundColor = Constants.Colors.grayBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 10, 
                                                left: 16,
                                                bottom: 10,
                                                right: 16)
        button.layer.cornerRadius = 8
        
        intervalStackView.addArrangedSubview(button)
    }
}

// MARK: - ButtonTapDelegate
extension AddDrugViewController: DropDownMenuDelegate {
    // MARK: Functions
    // Back button action
    func backButtonTapped() {
       
    }
    
    // Done button action
    func doneButtonTapped(_ value: String,
                          type: FieldType) {
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
            let notification = value.getNotificationMinutesType()
            viewModel?.notifications?.append(notification)
            createNotification(value)
        }
    }
    
    // MARK: Private functions
    // Delete notification action
    @objc private func deleteNotification(sender: UIButton) {
        let title = sender.attributedTitle(for: .normal)?.string ?? ""
        viewModel?.deleteNotification(title)
        sender.removeFromSuperview()
    }
    
    // Creating button by notification title
    private func createNotification(_ title: String) {
        let button = UIButton()
        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary,
                          NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12]
        let attributedString = NSAttributedString(string: title,
                                                  attributes: attributes)
        button.setAttributedTitle(attributedString, 
                                  for: .normal)
        button.addTarget(self, 
                         action: #selector(deleteNotification),
                         for: .touchUpInside)
        button.backgroundColor = Constants.Colors.grayBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 10, 
                                                left: 16,
                                                bottom: 10,
                                                right: 16)
        button.layer.cornerRadius = 8
        notificationsStackView.addArrangedSubview(button)
    }
}

// MARK: - UITextFieldDelegate
extension AddDrugViewController: UITextFieldDelegate {
    // MARK: Functions
    // Text field action on pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

// MARK: - CustomNavigationBarDelegate
extension AddDrugViewController: CustomNavigationBarDelegate {
    // MARK: Functions
    // Button action passing by button
    func tapped(_ button: ButtonType) {
        switch button {
        case .left:
            backButtonAction()
        case .right:
            break
        }
    }
    
    // MARK: Private functions
    // Button action
    @objc private func backButtonAction() {
        viewModel?.close()
    }
}
