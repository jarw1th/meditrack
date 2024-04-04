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
    private var initPosition = CGPoint.zero
    private var previousViewControllerSnapshot: UIView?
    
    // UI elements
    private let navigationBar = CustomNavigationBar()
    
    private let backgroundView = UIView()
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
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePan))
        panGesture.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(panGesture)
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
    
    // Swipe back animation
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            initPosition = view.center
            if let previousViewController = navigationController?.viewControllers.dropLast().last,
               let snapshot = previousViewController.view.snapshotView(afterScreenUpdates: true) {
                let overlay = UIView()
                overlay.frame = view.bounds
                overlay.backgroundColor = Constants.Colors.grayBackground
                view.addSubview(overlay)
                view.sendSubviewToBack(overlay)
                
                snapshot.frame = view.bounds
                view.addSubview(snapshot)
                view.sendSubviewToBack(snapshot)
                previousViewControllerSnapshot = snapshot
            }
        case .changed:
            let translation = gesture.translation(in: view)
            view.center.x = initPosition.x + translation.x
            view.center.x = max(view.center.x, view.bounds.width / 2)
            previousViewControllerSnapshot?.center.x = initPosition.x - translation.x
        case .ended, .cancelled:
            let shouldDismiss = (view.center.x > view.bounds.width * 0.75)
            UIView.animate(withDuration: 0.3) {
                if shouldDismiss {
                    self.view.center.x += self.view.bounds.width
                    self.previousViewControllerSnapshot?.center.x -= self.view.bounds.width
                } else {
                    self.view.center = self.initPosition
                    self.previousViewControllerSnapshot?.center = self.initPosition
                }
            } completion: { _ in
                if shouldDismiss {
                    self.viewModel?.close(false)
                }
            }
        default:
            break
        }
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
        viewModel?.close(true)
    }
}
