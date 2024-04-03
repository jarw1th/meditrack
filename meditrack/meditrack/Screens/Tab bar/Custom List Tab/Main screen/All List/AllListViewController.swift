import UIKit
import SnapKit

// MARK: - Class
final class AllListViewController: UIViewController {
    // MARK: Variables
    // Genaral variables
    private var viewModel: AllListViewModelProtocol? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // UI elements
    private let navigationBar = CustomNavigationBar()
    
    private let backgroundView = UIView()
    private let tableView = UITableView()
 
    // MARK: Body
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AllListViewModel()
        
        setupConstraints()
        setupUI()
        setCollectionAndTable()
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        view.addSubviews([navigationBar,
                          backgroundView])
        
        backgroundView.addSubviews([tableView])
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(64)
            make.top.equalTo(navigationBar.snp.bottom).inset(-12)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-64)
            make.top.equalTo(16)
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        view.backgroundColor = Constants.Colors.grayBackground
        
        navigationController?.isNavigationBarHidden = true
        
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleMedicationMain)
        navigationBar.setImage(.left, 
                               image: Constants.Images.backIcon)
        navigationBar.setBackgroundColor(Constants.Colors.grayBackground)
        
        backgroundView.backgroundColor = Constants.Colors.white
        backgroundView.layer.cornerRadius = 48
        let swipeGesture = UISwipeGestureRecognizer(target: self, 
                                                    action: #selector(backButtonAction))
        swipeGesture.cancelsTouchesInView = false
        swipeGesture.direction = .right
        backgroundView.addGestureRecognizer(swipeGesture)
    }
    
    // Setting up collections and tables view
    private func setCollectionAndTable() {
        tableView.register(CalendarTableViewCell.self, 
                           forCellReuseIdentifier: Constants.System.calendarTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.Colors.white
    }
}

// MARK: - TableView
extension AllListViewController: UITableViewDataSource,
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
        background.backgroundColor = Constants.Colors.graySecondary
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
        
    }
    
    // Edit row
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - CustomNavigationBarDelegate
extension AllListViewController: CustomNavigationBarDelegate {
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
        navigationController?.popViewController(animated: true)
    }
}
