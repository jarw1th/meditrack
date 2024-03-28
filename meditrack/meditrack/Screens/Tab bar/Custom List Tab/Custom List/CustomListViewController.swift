import UIKit
import SnapKit

final class CustomListViewController: UIViewController {
    // MARK: - Variables
    private var viewModel: CustomListViewModelProtocol? {
        didSet {
            setUI()
        }
    }
    
    private let addButton = UIButton()
    private let selectedDate = UILabel()
    private let nameLabel = UILabel()
    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    private let backgroundView = UIView()
    private let medicationTitleLabel = UILabel()
    private let tableView = UITableView()
 
    // MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CustomListViewModel()
        
        setupUI()
        setCollectionAndTable()
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.grayBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.isNavigationBarHidden = true
        
        view.addSubviews([addButton,
                          selectedDate,
                          nameLabel,
                          dateCollectionView,
                          backgroundView,
                          medicationTitleLabel,
                          tableView])
        addButton.snp.makeConstraints({ make in
            make.width.height.equalTo(40)
            make.trailing.equalTo(-24)
            make.top.equalTo(view.snp.top).inset(72)
        })
        selectedDate.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(view.snp.top).inset(112)
        })
        nameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(selectedDate.snp.bottom)
        })
        dateCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(100)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(nameLabel.snp.bottom)
        })
        backgroundView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(64)
            make.top.equalTo(dateCollectionView.snp.bottom).inset(-12)
        })
        medicationTitleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.top.equalTo(backgroundView.snp.top).inset(40)
        })
        tableView.snp.makeConstraints({ make in
            make.width.equalTo(361)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-24)
            make.top.equalTo(medicationTitleLabel.snp.bottom)
        })
        
        addButton.setImage(Constants.Images.plusIcon, for: .normal)
        addButton.tintColor = addButton.isSelected ? Constants.Colors.white : Constants.Colors.grayPrimary
        addButton.backgroundColor = addButton.isSelected ? Constants.Colors.grayBackground : Constants.Colors.graySecondaryLight
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addButton.layer.cornerRadius = 12
        addButton.addTarget(self, action: #selector(pushAddDrug), for: .touchUpInside)
        
        selectedDate.font = Constants.Fonts.nunitoRegular24
        selectedDate.textColor = Constants.Colors.graySecondary
        selectedDate.text = viewModel?.todayDate
        
        nameLabel.text = Constants.Texts.labelTodayRemidersMain
        nameLabel.font = Constants.Fonts.nunitoBold32
        nameLabel.textColor = Constants.Colors.grayPrimary
        
        dateCollectionView.backgroundColor = Constants.Colors.grayBackground
        
        medicationTitleLabel.text = Constants.Texts.labelMedicationMain
        medicationTitleLabel.font = Constants.Fonts.nunitoRegular16
        medicationTitleLabel.textColor = Constants.Colors.graySecondary
        
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 48
    }
    
    private func setCollectionAndTable() {
        dateCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        dateCollectionView.performBatchUpdates({
            dateCollectionView.reloadData()
        }, completion: { _ in
            self.dateCollectionView.scrollToItem(at: IndexPath(row: self.viewModel?.todayIndex ?? 0, section: 0),
                                        at: .centeredHorizontally,
                                        animated: false)
        })
    }
    
    private func setUI() {
        tableView.reloadData()
    }
    
    @objc private func pushAddDrug() {
        self.navigationController?.pushViewController(AddDrugViewController(), animated: true)
    }
}

// MARK: - TableView
extension CustomListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let number = viewModel?.numberOfSections else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfRows(in: section) else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell
        cell?.selectionStyle = .none
        
        viewModel?.getItemSetup(afterRowAt: indexPath, completion: { name, type, dose, foodType, isCompleted in
            cell?.setup(name: name, drug: type, dose: dose, food: foodType, isCompleted: isCompleted)
        })
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView = UIView()
        let title = UILabel()
        
        contentView.addSubview(title)
        title.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.top.equalToSuperview()
            make.trailing.equalTo(contentView.snp.leading).inset(128)
        })
        
        contentView.backgroundColor = Constants.Colors.white
        
        let string = viewModel?.getSectionTitle(for: section) ?? String()
        title.text = string
        title.font = Constants.Fonts.nunitoSemiBold16
        title.textColor = Constants.Colors.graySecondary
        
        return contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension CustomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var objectId = String()
        viewModel?.getItemId(afterRowAt: indexPath, completion: { id in
            objectId = id
        })
        var reason: Bool
        var id: String
        (reason, id) = viewModel?.getCompletedList()[objectId] ?? (false, String())
        if reason {
            viewModel?.setCompletement(objectId: id, id: objectId, value: false)
        } else {
            viewModel?.setCompletement(objectId: id, id: objectId, value: true)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - CollectionView
extension CustomListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfItems else {return 0}
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell

        viewModel?.getDate(afterRowAt: indexPath, completion: { date in
            let isSelected = self.viewModel?.selectedIndex == indexPath.row
            let isToday = self.viewModel?.todayIndex == indexPath.row
            cell.setup(date: date, isSelected: isSelected, isToday: isToday)
        })

        return cell
    }
}

extension CustomListViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let selectedIndex = IndexPath(row: viewModel?.selectedIndex ?? 0, section: 0)
        viewModel?.selectedIndex = indexPath.row
        
        let isToday = viewModel?.todayIndex == indexPath.row
        selectedDate.text = viewModel?.todayDate
        nameLabel.text = isToday ? Constants.Texts.labelTodayRemidersMain : Constants.Texts.labelRemidersMain
        
        collectionView.reloadItems(at: [indexPath, selectedIndex])
        tableView.reloadData()
    }
}

extension CustomListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
