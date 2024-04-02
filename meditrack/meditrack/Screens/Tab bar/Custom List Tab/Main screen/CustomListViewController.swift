import UIKit
import SnapKit

final class CustomListViewController: UIViewController {
    // MARK: - Variables
    private var viewModel: CustomListViewModelProtocol? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let addButton = UIButton()
    
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
    private let medicationTitleLabel = UILabel()
    private let allMedicationsButton = UIButton()
    private let tableView = UITableView()
 
    // MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CustomListViewModel()
        
        setupConstraints()
        setupUI()
        setCollectionAndTable()
    }
    
    // MARK: - Functions
    private func setupConstraints() {
        view.addSubview(addButton)
        
        view.addSubviews([selectedDate,
                          nameLabel,
                          dateCollectionView,
                          backgroundView])
        
        backgroundView.addSubviews([medicationTitleLabel,
                                    allMedicationsButton,
                                    tableView])
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalTo(-24)
            make.top.equalTo(view.snp.top).inset(72)
        }
        
        selectedDate.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(view.snp.top).inset(112)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(selectedDate.snp.bottom)
        }
        dateCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(64)
            make.top.equalTo(dateCollectionView.snp.bottom).inset(-12)
        }
        
        medicationTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.top.equalTo(40)
        }
        allMedicationsButton.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.top.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-64)
            make.top.equalTo(medicationTitleLabel.snp.bottom)
        }
    }
    
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
        
        
        selectedDate.font = Constants.Fonts.nunitoRegular24
        selectedDate.textColor = Constants.Colors.graySecondary
        selectedDate.text = viewModel?.todayDate
        
        nameLabel.text = Constants.Texts.labelTodayRemidersMain
        nameLabel.font = Constants.Fonts.nunitoBold32
        nameLabel.textColor = Constants.Colors.grayPrimary
        
        dateCollectionView.backgroundColor = Constants.Colors.grayBackground
        
        backgroundView.backgroundColor = Constants.Colors.white
        backgroundView.layer.cornerRadius = 48
        
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
    
    @objc private func pushAddDrug() {
        navigationController?.pushViewController(AddDrugViewController(), 
                                                 animated: true)
    }
    
    @objc private func pushAllDrugs() {
        navigationController?.pushViewController(AllListViewController(), 
                                                 animated: true)
    }
}

// MARK: - TableView
extension CustomListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let number = viewModel?.numberOfSections else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfRows(in: section) else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = Constants.System.typeCollectionViewCell
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
    
    func tableView(_ tableView: UITableView, 
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}

extension CustomListViewController: UITableViewDelegate {
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
                                   value: reason)
        
        tableView.reloadRows(at: [indexPath], 
                             with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, 
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - CollectionView
extension CustomListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfItems else {return 0}
        return number
    }
    
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
}

extension CustomListViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
}

extension CustomListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, 
                      height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
