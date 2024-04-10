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
    
    private let topBarContainer = UIStackView()
    private let medicationTitleLabel = UILabel()
    private let allMedicationsButton = UIButton()
    
    private let tableView = UITableView()
 
    // MARK: Body
    // Initial
    convenience init(viewModel: AllListViewModelProtocol?) {
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
        let topOfContainer = view.frame.size.width / 9.5
        
        view.addSubviews([navigationBar,
                          backgroundView])
        
        backgroundView.addSubviews([topBarContainer,
                                    tableView])
        
        topBarContainer.addArrangedSubviews([medicationTitleLabel, 
                                             allMedicationsButton])
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(64)
            make.top.equalTo(navigationBar.snp.bottom).inset(-12)
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
        
        navigationController?.isNavigationBarHidden = true
        
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleAllmedicationsMain)
        navigationBar.setImage(.left,
                               image: Constants.Images.backIcon)
        navigationBar.setBackgroundColor(Constants.Colors.grayBackground)
        navigationBar.setBackgroundLayerColor(Constants.Colors.grayBackground)
        
        backgroundView.backgroundColor = Constants.Colors.white
        backgroundView.layer.cornerRadius = 48
        
        
        topBarContainer.axis = .horizontal
        topBarContainer.spacing = 16
        
        medicationTitleLabel.text = Constants.Texts.labelMedicationMain
        medicationTitleLabel.font = Constants.Fonts.nunitoRegular16
        medicationTitleLabel.textColor = Constants.Colors.graySecondary
        
        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.deleteAccent,
                          NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16]
        let attributedString = NSAttributedString(string: Constants.Texts.buttonDeleteallSub,
                                                  attributes: attributes)
        allMedicationsButton.setAttributedTitle(attributedString,
                                                for: .normal)
        allMedicationsButton.addTarget(self,
                                       action: #selector(clearData),
                                       for: .touchUpInside)
        allMedicationsButton.titleLabel?.textAlignment = .right
    }
    
    // Clearing all data
    @objc private func clearData() {
        showAlertAll()
    }
    
    // Showing alert for clearing all data
    private func showAlertAll() {
        let attributes = [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16,
                          NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary]
        let titleAttributedString = NSAttributedString(string: Constants.Texts.alertDeleteallMain,
                                                  attributes: attributes)
        
        let alert = UIAlertController(title: titleAttributedString.string,
                                      message: "",
                                      preferredStyle: .alert)
        alert.setValue(titleAttributedString, forKey: "attributedTitle")
        alert.backgroundColor = Constants.Colors.white
        
        let action = UIAlertAction(title: Constants.Texts.alertCancelSub,
                                   style: .cancel)
        alert.addAction(action)
        
        let deleteAction = UIAlertAction(title: Constants.Texts.alertDeleteSub,
                                         style: .destructive) { action in
            self.viewModel?.clearData()
            self.tableView.reloadData()
        }
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    // Showing alert for deleting one drug
    private func showAlertSingle(_ indexPath: IndexPath) {
        let attributes = [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16,
                          NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary]
        let titleAttributedString = NSAttributedString(string: Constants.Texts.alertDeleteMain,
                                                  attributes: attributes)
        
        let alert = UIAlertController(title: titleAttributedString.string,
                                      message: "",
                                      preferredStyle: .alert)
        alert.setValue(titleAttributedString, forKey: "attributedTitle")
        alert.backgroundColor = Constants.Colors.white
        
        let action = UIAlertAction(title: Constants.Texts.alertCancelSub,
                                   style: .cancel)
        alert.addAction(action)
        
        let deleteAction = UIAlertAction(title: Constants.Texts.alertDeleteSub,
                                         style: .destructive) { _ in
            self.viewModel?.deleteItem(at: indexPath)
            self.tableView.reloadData()
        }
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    // Setting up collections and tables view
    private func setCollectionAndTable() {
        tableView.register(AllListTableViewCell.self, 
                           forCellReuseIdentifier: Constants.System.allListTableViewCell)
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
        let identifier = Constants.System.allListTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath) as? AllListTableViewCell
        cell?.selectionStyle = .none
        
        viewModel?.getItemSetup(at: indexPath) { name, type, dose, foodType in
            cell?.setup(name: name, 
                        drug: type,
                        dose: dose,
                        food: foodType,
                        view: self)
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
}

// MARK: - AllListTableViewCellDelegate
extension AllListViewController: AllListTableViewCellDelegate {
    func tapped(_ indexPath: IndexPath) {
        guard let item = viewModel?.getItem(at: indexPath) else { return }
        viewModel?.goToDetailedScreen(item)
    }
    
    func buttonTapped(_ indexPath: IndexPath) {
        showAlertSingle(indexPath)
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
        viewModel?.close(true)
    }
}
