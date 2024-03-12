import UIKit
import SnapKit

final class CustomListViewController: UIViewController {
    // MARK: - Variables
    private var viewModel: CustomListViewModelProtocol? {
        didSet {
            setUI()
        }
    }
    
    private let nameLabel = UILabel()
    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    private let tableView = UITableView()
    private let backgroundView = UIView()
    private let subnameLabel = UILabel()
    
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
        
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.grayBackground
        title = nil
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushAddDrug))
        navigationController?.navigationBar.tintColor = Constants.Colors.grayAccent
        
        tableView.separatorStyle = .none
        
        view.addSubviews([nameLabel, dateCollectionView, backgroundView, subnameLabel, tableView])
        nameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(48)
        })
        dateCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(100)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(nameLabel.snp.bottom)
        })
        backgroundView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(64)
            make.top.equalTo(dateCollectionView.snp.bottom).inset(-12)
        })
        subnameLabel.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(backgroundView.snp.top).inset(16)
        })
        tableView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(-16)
            make.top.equalTo(subnameLabel.snp.bottom).inset(-16)
        })
        
        nameLabel.text = Constants.Texts.labelRemidersMain
        nameLabel.font = Constants.Fonts.nunitoMediumHeader1
        nameLabel.textColor = Constants.Colors.grayAccent
        
        dateCollectionView.backgroundColor = Constants.Colors.grayBackground
        
        subnameLabel.text = Constants.Texts.labelMedicationSub
        subnameLabel.font = Constants.Fonts.nunitoRegularTitle
        subnameLabel.textColor = Constants.Colors.grayAccent
        subnameLabel.layer.opacity = 0.8
        
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 30
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = viewModel?.numberOfRows else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell
        cell?.selectionStyle = .none
        
        viewModel?.getItem(afterRowAt: indexPath, completion: { id, name, drugType in
            let filteredList = self.viewModel?.getCompletedList().filter({ $0.key == id }).first?.value ?? (false, String())
            var isCompleted: Bool
            (isCompleted, _) = filteredList
            cell?.setup(name: name, drug: drugType, isCompleted: isCompleted)
        })
        return cell ?? UITableViewCell()
    }
}

extension CustomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var objectId = String()
        viewModel?.getItem(afterRowAt: indexPath, completion: { id, name, type in
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
            cell.setup(date: date, isSelected: isSelected)
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
