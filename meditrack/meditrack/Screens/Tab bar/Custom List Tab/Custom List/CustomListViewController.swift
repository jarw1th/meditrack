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
    private let timeTitleLabel = UILabel()
    private let medicationTitleLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CustomListViewModel()
        
        setupUI()
        
        dateCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        dateCollectionView.performBatchUpdates({
            dateCollectionView.reloadData()
        }, completion: { _ in
            self.dateCollectionView.scrollToItem(at: IndexPath(row: self.viewModel?.todayIndex ?? 0, section: 0),
                                        at: .centeredHorizontally,
                                        animated: false)
        })
        
        tableView.performBatchUpdates({
            tableView.reloadData()
        }, completion: { _ in
            for section in 0...self.tableView.numberOfSections - 1 {
                guard let cellView = self.tableView.cellForRow(at: IndexPath(row: 0, section: section)) else { break }
                
                let rows = self.tableView.numberOfRows(inSection: section)
                var height: CGFloat = 0
                for row in 1...rows {
                    height += cellView.frame.height * CGFloat(row)
                }
                
                
                let title = UILabel()
                let rectBar = UIImageView()
                
                self.view.addSubviews([title, rectBar])
                title.snp.makeConstraints({ make in
                    make.leading.equalTo(24)
                    make.top.equalTo(cellView.snp.top).inset(8)
                })
                rectBar.snp.makeConstraints({ make in
                    make.width.equalTo(2)
                    make.height.equalTo(height)
                    make.top.equalTo(cellView.snp.top).inset(8)
                    make.trailing.equalTo(cellView.snp.leading).inset(-10)
                })
                
                let string = self.viewModel?.getSectionTitle(for: section).replacingOccurrences(of: " ", with: "\n") ?? String()
                let attributedString = NSMutableAttributedString(string: string)
                let timeAttributes = [NSAttributedString.Key.font: Constants.Fonts.nunitoSemiBold20,
                                      NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary] as! [NSAttributedString.Key: Any]
                let postfixAttributes = [NSAttributedString.Key.font: Constants.Fonts.nunitoSemiBold16,
                                         NSAttributedString.Key.foregroundColor: Constants.Colors.graySecondary]  as! [NSAttributedString.Key: Any]
                if let commaIndex = string.firstIndex(of: "\n") {
                    attributedString.addAttributes(timeAttributes, range: NSRange(string.startIndex ..< commaIndex, in: string))
                    attributedString.addAttributes(postfixAttributes, range: NSRange(commaIndex ..< string.endIndex, in: string))
                }
                title.attributedText = attributedString
                title.numberOfLines = 2
                
                rectBar.image = Constants.Images.rect
            }
        })
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.grayBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.separatorStyle = .none
        
        view.addSubviews([addButton,
                          selectedDate,
                          nameLabel,
                          dateCollectionView,
                          backgroundView,
                          timeTitleLabel,
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
        timeTitleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(24)
            make.top.equalTo(backgroundView.snp.top).inset(40)
        })
        medicationTitleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(timeTitleLabel.snp.trailing).inset(-37)
            make.top.equalTo(backgroundView.snp.top).inset(40)
        })
        tableView.snp.makeConstraints({ make in
            make.width.equalTo(280)
            make.trailing.equalTo(-24)
            make.bottom.equalTo(-24)
            make.top.equalTo(timeTitleLabel.snp.bottom)
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
        
        timeTitleLabel.text = Constants.Texts.labelTimeMain
        timeTitleLabel.font = Constants.Fonts.nunitoRegular16
        timeTitleLabel.textColor = Constants.Colors.graySecondary
        
        medicationTitleLabel.text = Constants.Texts.labelMedicationMain
        medicationTitleLabel.font = Constants.Fonts.nunitoRegular16
        medicationTitleLabel.textColor = Constants.Colors.graySecondary
        
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 48
        
        tableView.bounces = false
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
        guard let number = viewModel?.numberOfRowsInSection(in: section) else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell
        cell?.selectionStyle = .none
        
        viewModel?.getItem(afterRowAt: indexPath, completion: { drug in
            let filteredList = self.viewModel?.getCompletedList().filter({ $0.key == drug.id }).first?.value ?? (false, String())
            var isCompleted: Bool
            (isCompleted, _) = filteredList
            cell?.setup(name: drug.name, drug: drug.drugType, dose: drug.dose, isCompleted: isCompleted)
        })
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let number = (section == 0) ? 0 : 8
        return CGFloat(number)
    }
}

extension CustomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var objectId = String()
        viewModel?.getItem(afterRowAt: indexPath, completion: { drug in
            objectId = drug.id
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteItem(afterRowAt: indexPath, completion: { [weak self] in
                self?.tableView.reloadData()
            })
        }
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
