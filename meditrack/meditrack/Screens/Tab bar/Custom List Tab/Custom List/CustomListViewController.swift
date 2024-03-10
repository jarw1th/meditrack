import UIKit
import SnapKit

final class CustomListViewController: UIViewController {
    private var viewModel: CustomListViewModelProtocol? {
        didSet {
            setUI()
        }
    }
    
    private let nameLabel = UILabel()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    private let tableView = UITableView()
    
    private var selectedIndex: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CustomListViewModel()
        
        setupUI()
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.grayBackground
        title = nil
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationController?.navigationBar.tintColor = Constants.Colors.grayAccent
        
        view.addSubviews([nameLabel, collectionView, tableView])
        nameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(48)
        })
        collectionView.snp.makeConstraints({ make in
            make.height.equalTo(80)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(nameLabel.snp.bottom).inset(-16)
        })
        tableView.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-16)
            make.top.equalTo(collectionView.snp.bottom).inset(-16)
        })
        
        nameLabel.text = Constants.Texts.labelRemidersMain
        nameLabel.font = Constants.Fonts.nunitoMediumHeader1
        nameLabel.textColor = Constants.Colors.grayAccent
        
        collectionView.backgroundColor = Constants.Colors.grayBackground
    }
    
    private func setUI() {
        tableView.reloadData()
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        viewModel?.getItem(afterRowAt: indexPath, completion: { name, drugType in
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = drugType.rawValue
        })
        return cell
    }
}

extension CustomListViewController: UITableViewDelegate {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell


        viewModel?.getDate(afterRowAt: indexPath, completion: { date in
            let isSelected = self.selectedIndex == indexPath.row
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
        let selectedIndex = IndexPath(row: self.selectedIndex, section: 0)
        self.selectedIndex = indexPath.row
        collectionView.reloadItems(at: [indexPath, selectedIndex])
    }
}

extension CustomListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
