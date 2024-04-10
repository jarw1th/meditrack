import UIKit
import SnapKit

// MARK: - Class
final class MainScreenViewController: UIViewController {
    // MARK: Variables
    // Genaral variables
    private var viewModel: MainScreenViewModelProtocol? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // UI elements
    private let addButton = UIButton()
    
    private let informationContainer = UIStackView()
    private let selectedDate = UILabel()
    private let nameLabel = UILabel()
    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, 
                                          collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, 
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private let backgroundView = UIView()
    
    private let topBarContainer = UIStackView()
    private let medicationTitleLabel = UILabel()
    private let allMedicationsButton = UIButton()
    
    private let tableView = UITableView()
 
    // MARK: Body
    // Initial
    convenience init(viewModel: MainScreenViewModelProtocol?) {
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
    
    // View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        let widthOfAddButton = view.frame.size.width / 9.5
        let topOfContainer = view.frame.size.width / 9.5
        let heightOfCollectionView = view.frame.size.width / 4
        
        view.addSubview(addButton)
        
        view.addSubviews([informationContainer,
                          dateCollectionView,
                          backgroundView])
        informationContainer.addArrangedSubviews([selectedDate,
                                             nameLabel])
        
        backgroundView.addSubviews([topBarContainer,
                                    tableView])
        topBarContainer.addArrangedSubviews([medicationTitleLabel,
                                             allMedicationsButton])
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(widthOfAddButton)
            make.trailing.equalTo(-24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
        }
        
        informationContainer.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(addButton.snp.bottom)
        }
        dateCollectionView.snp.makeConstraints { make in
            make.height.equalTo(heightOfCollectionView)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(informationContainer.snp.bottom)
        }
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(64)
            make.top.equalTo(dateCollectionView.snp.bottom).inset(-12)
        }
        
        topBarContainer.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(topOfContainer)
        }
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-64)
            make.top.equalTo(topBarContainer.snp.bottom)
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        view.backgroundColor = Constants.Colors.grayBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", 
                                                           style: .plain,
                                                           target: self,
                                                           action: nil)
        navigationController?.isNavigationBarHidden = true
        
        let white = Constants.Colors.white
        let grayPrimary = Constants.Colors.grayPrimary
        let grayBackground = Constants.Colors.grayBackground
        let graySecondaryLight = Constants.Colors.graySecondaryLight
        addButton.setImage(Constants.Images.plusIcon, 
                           for: .normal)
        addButton.tintColor = addButton.isSelected ? white : grayPrimary
        addButton.backgroundColor = addButton.isSelected ? grayBackground : graySecondaryLight
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.imageEdgeInsets = UIEdgeInsets(top: 10, 
                                                 left: 10, 
                                                 bottom: 10,
                                                 right: 10)
        addButton.layer.cornerRadius = 12
        addButton.addTarget(self, 
                            action: #selector(pushAddDrug),
                            for: .touchUpInside)
        
        
        informationContainer.axis = .vertical
        informationContainer.spacing = 0
        
        selectedDate.font = Constants.Fonts.nunitoRegular24
        selectedDate.textColor = Constants.Colors.graySecondary
        selectedDate.text = viewModel?.todayDate
        
        nameLabel.text = Constants.Texts.labelTodayRemidersMain
        nameLabel.font = Constants.Fonts.nunitoBold32
        nameLabel.textColor = Constants.Colors.grayPrimary
        
        dateCollectionView.backgroundColor = Constants.Colors.grayBackground
        
        backgroundView.backgroundColor = Constants.Colors.white
        backgroundView.layer.cornerRadius = 48
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(selectedIndexIncrement))
        leftSwipeGesture.cancelsTouchesInView = false
        leftSwipeGesture.direction = .right
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(selectedIndexDecrement))
        leftSwipeGesture.cancelsTouchesInView = false
        leftSwipeGesture.direction = .left
        backgroundView.addGestureRecognizer(leftSwipeGesture)
        backgroundView.addGestureRecognizer(rightSwipeGesture)
        
        
        topBarContainer.axis = .horizontal
        topBarContainer.spacing = 16
        
        medicationTitleLabel.text = Constants.Texts.labelMedicationMain
        medicationTitleLabel.font = Constants.Fonts.nunitoRegular16
        medicationTitleLabel.textColor = Constants.Colors.graySecondary
        
        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary,
                          NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16]
        let attributedString = NSAttributedString(string: Constants.Texts.buttonAllmedicationsSub,
                                                  attributes: attributes)
        allMedicationsButton.setAttributedTitle(attributedString, 
                                                for: .normal)
        let image = Constants.Images.rightArrow.withTintColor(Constants.Colors.grayPrimary,
                                                              renderingMode: .alwaysOriginal)
        allMedicationsButton.addTarget(self, 
                                       action: #selector(pushAllDrugs),
                                       for: .touchUpInside)
        allMedicationsButton.setImage(image, 
                                      for: .normal)
        allMedicationsButton.semanticContentAttribute = .forceRightToLeft
    }
    
    // Setting up collections and tables view
    private func setCollectionAndTable() {
        dateCollectionView.register(DateCollectionViewCell.self, 
                                    forCellWithReuseIdentifier: Constants.System.dateCollectionViewCell)
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        
        tableView.register(CalendarTableViewCell.self, 
                           forCellReuseIdentifier: Constants.System.calendarTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.Colors.white
        
        dateCollectionView.performBatchUpdates({
            dateCollectionView.reloadData()
        }) { _ in
            self.dateCollectionView.scrollToItem(at: IndexPath(row: self.viewModel?.todayIndex ?? 0, 
                                                               section: 0),
                                                 at: .centeredHorizontally,
                                                 animated: false)
        }
    }
    
    // Push add drug screen action
    @objc private func pushAddDrug() {
        viewModel?.goToAddDrug()
    }
    
    // Push all drugs screen action
    @objc private func pushAllDrugs() {
        viewModel?.goToAllList()
    }
    
    @objc private func selectedIndexIncrement() {
        viewModel?.selectedIndexIncrement()
        reloadData()
    }
    
    @objc private func selectedIndexDecrement() {
        viewModel?.selectedIndexDecrement()
        reloadData()
    }
    
    private func reloadData() {
        UIView.animate(withDuration: 0.4, animations: {
            self.dateCollectionView.reloadData()
            self.tableView.reloadData()
            self.dateCollectionView.scrollToItem(at: IndexPath(row: self.viewModel?.selectedIndex ?? 0,
                                                               section: 0),
                                            at: .centeredHorizontally,
                                            animated: false)
        })
    }
}

// MARK: - TableView
extension MainScreenViewController: UITableViewDataSource,
                                    UITableViewDelegate {
    // MARK: Functions
    // Number of sectios
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let number = viewModel?.numberOfSections else {return 0}
        return number
    }
    
    // Number of rows in section
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfRows(in: section) else {return 0}
        return number
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = Constants.System.calendarTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath) as? CalendarTableViewCell
        cell?.selectionStyle = .none
        
        viewModel?.getItemSetup(at: indexPath) { name, type, dose, foodType, isCompleted in
            cell?.setup(name: name, 
                        drug: type,
                        dose: dose,
                        food: foodType,
                        isCompleted: isCompleted)
        }
        
        return cell ?? UITableViewCell()
    }
    
    // View for header
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let contentView = UIView()
        let background = UIView()
        let title = UILabel()
        
        contentView.addSubview(background)
        background.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        background.addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        contentView.backgroundColor = Constants.Colors.white
        contentView.autoresizingMask = []
        background.backgroundColor = Constants.Colors.greenAccent
        background.layer.cornerRadius = 8
        
        let attributedString = viewModel?.getSectionTitle(for: section)
        title.attributedText = attributedString
        title.textAlignment = .center
        
        return contentView
    }
    
    // Height for header in section
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    // Select row
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        var objectId = String()
        viewModel?.getItemId(at: indexPath) { id in
            objectId = id
        }
        
        var reason: Bool
        var id: String
        let list = viewModel?.getCompletedList()[objectId] ?? (false, String())
        (reason, id) = list
        
        viewModel?.setCompletement(objectId: id,
                                   id: objectId,
                                   value: !reason)
        
        tableView.reloadRows(at: [indexPath],
                             with: .automatic)
    }
}

// MARK: - CollectionView
extension MainScreenViewController: UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {
    // MARK: Functions
    // Number of items
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfItems else {return 0}
        return number
    }
    
    // Cell for item
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = Constants.System.dateCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! DateCollectionViewCell

        viewModel?.getDate(at: indexPath) { date in
            let isSelected = (self.viewModel?.selectedIndex == indexPath.row)
            let isToday = (self.viewModel?.todayIndex == indexPath.row)
            cell.setup(date: date,
                       isSelected: isSelected,
                       isToday: isToday)
        }

        return cell
    }
    
    // Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Select item
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
        
        let selectedIndex = IndexPath(row: viewModel?.selectedIndex ?? 0,
                                      section: 0)
        viewModel?.selectedIndex = indexPath.row
        
        let isToday = (viewModel?.todayIndex == indexPath.row)
        selectedDate.text = viewModel?.todayDate
        
        let todayString = Constants.Texts.labelTodayRemidersMain
        let string = Constants.Texts.labelRemidersMain
        nameLabel.text = isToday ? todayString : string
        
        collectionView.reloadItems(at: [indexPath, selectedIndex])
        tableView.reloadData()
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
        let height = view.frame.size.width / 5
        let width = view.frame.size.width / 8
        return CGSize(width: width,
                      height: height)
    }
    
    // Minimum line spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
