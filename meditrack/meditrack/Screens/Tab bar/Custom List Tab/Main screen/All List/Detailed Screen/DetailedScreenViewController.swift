import UIKit
import SnapKit

// MARK: - Class
final class DetailedScreenViewController: UIViewController {
    // MARK: Variables
    // Genaral variables
    private var viewModel: DetailedScreenViewModelProtocol?
    
    // UI elements
    private let navigationBar = CustomNavigationBar()
    private let scrollView = UIScrollView()
    private let container = UIStackView()
    
    private let drugInfoContainer = UIStackView()
    private let drugNameLabel = UILabel()
    private let drugDescriptionLabel = UILabel()
    
    private let scheduleContainer = UIStackView()
    private let scheduleLabel = UILabel()
    private let intervalScrollView = UIScrollView()
    private let intervalStackView = UIStackView()
    
    private let detailsContainer = UIStackView()
    private let detailsLabel = UILabel()
    private let informationColumns = InformationColumns()
    
    private let notificationsContainer = UIStackView()
    private let notificationsLabel = UILabel()
    private let notificationsScrollView = UIScrollView()
    private let notificationsStackView = UIStackView()
    
    private let progressView = ProgressView()
 
    // MARK: Body
    // Initial
    convenience init(viewModel: DetailedScreenViewModelProtocol?,
                     selectedDrug: DrugInfo) {
        self.init()
        
        self.viewModel = viewModel
        self.viewModel?.selectedDrug = selectedDrug
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupUI()
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        let heightOfScrolls = view.frame.size.width / 11
        let heightOfProgress = view.frame.size.width / 5.5
        let widthOfScreenElements = view.frame.size.width - 48
        
        view.addSubviews([navigationBar,
                          scrollView])
        scrollView.addSubview(container)
        
        container.addArrangedSubview(drugInfoContainer)
        drugInfoContainer.addArrangedSubviews([drugNameLabel,
                                               drugDescriptionLabel])
        
        container.addArrangedSubview(scheduleContainer)
        scheduleContainer.addArrangedSubviews([scheduleLabel,
                                               intervalScrollView])
        intervalScrollView.addSubview(intervalStackView)
        
        container.addArrangedSubview(detailsContainer)
        detailsContainer.addArrangedSubviews([detailsLabel,
                                              informationColumns])
        
        container.addArrangedSubview(notificationsContainer)
        notificationsContainer.addArrangedSubviews([notificationsLabel,
                                                    notificationsScrollView])
        notificationsScrollView.addSubview(notificationsStackView)
        
        container.addArrangedSubview(progressView)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).inset(-16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.bottom.equalTo(-64)
        }
        
        drugInfoContainer.snp.makeConstraints { make in
            make.width.equalTo(widthOfScreenElements)
        }
        
        intervalScrollView.snp.makeConstraints { make in
            make.height.equalTo(heightOfScrolls)
        }
        intervalStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        notificationsScrollView.snp.makeConstraints { make in
            make.height.equalTo(heightOfScrolls)
        }
        notificationsStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.height.equalTo(heightOfProgress)
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        view.backgroundColor = Constants.Colors.white
        navigationController?.isNavigationBarHidden = true
        
        
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleMedicationdetailsMain)
        navigationBar.setImage(.left,
                               image: Constants.Images.backIcon)
        navigationBar.setImage(.right,
                               image: Constants.Images.settingsIcon)
        navigationBar.setBackgroundColor(Constants.Colors.white)
        
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        
        container.axis = .vertical
        container.spacing = 24
        
        
        drugInfoContainer.axis = .vertical
        drugInfoContainer.spacing = 16
        
        scheduleContainer.axis = .vertical
        scheduleContainer.spacing = 16
        
        detailsContainer.axis = .vertical
        detailsContainer.spacing = 16
        
        notificationsContainer.axis = .vertical
        notificationsContainer.spacing = 16
        
        
        drugNameLabel.text = viewModel?.selectedDrug?.name
        drugNameLabel.font = Constants.Fonts.nunitoBold20
        drugNameLabel.textColor = Constants.Colors.greenAccent
        
        drugDescriptionLabel.text = viewModel?.selectedDrug?.descriptionDrug
        drugDescriptionLabel.font = Constants.Fonts.nunitoRegular12
        drugDescriptionLabel.textColor = Constants.Colors.grayPrimary
        
        
        scheduleLabel.text = Constants.Texts.labelScheduleMain
        scheduleLabel.font = Constants.Fonts.nunitoBold20
        scheduleLabel.textColor = Constants.Colors.grayPrimary
        
        intervalScrollView.bounces = false
        intervalScrollView.isScrollEnabled = true
        intervalScrollView.showsHorizontalScrollIndicator = false
        intervalScrollView.showsVerticalScrollIndicator = false
        intervalStackView.axis = .horizontal
        intervalStackView.spacing = 16
        intervalStackView.contentMode = .center
        
        
        detailsLabel.text = Constants.Texts.labelDetailsMain
        detailsLabel.font = Constants.Fonts.nunitoBold20
        detailsLabel.textColor = Constants.Colors.grayPrimary
        
        informationColumns.setup(type: viewModel?.selectedDrug?.drugType,
                                 duration: viewModel?.selectedDrug?.duration,
                                 frequency: viewModel?.selectedDrug?.frequency,
                                 food: viewModel?.selectedDrug?.foodType)
        
        
        notificationsLabel.text = Constants.Texts.labelNotificationsMain
        notificationsLabel.font = Constants.Fonts.nunitoBold20
        notificationsLabel.textColor = Constants.Colors.grayPrimary
        
        notificationsScrollView.bounces = false
        notificationsScrollView.isScrollEnabled = true
        notificationsScrollView.showsHorizontalScrollIndicator = false
        notificationsScrollView.showsVerticalScrollIndicator = false
        notificationsStackView.axis = .horizontal
        notificationsStackView.spacing = 16
        notificationsStackView.contentMode = .center
        
        
        intervalScrollView.isHidden = viewModel?.selectedDrug?.timeInterval.isEmpty ?? true
        notificationsScrollView.isHidden = viewModel?.selectedDrug?.notifications.isEmpty ?? true
        
    
        progressView.setup(type: viewModel?.selectedDrug?.drugType ?? .capsule,
                           percent: viewModel?.precentsCompletement ?? 0,
                           startDate: viewModel?.selectedDrug?.startDate ?? Date())
        
        if let intervals = viewModel?.selectedDrug?.timeInterval {
            intervals.forEach {
                self.createInterval($0.convertToTime())
            }
        }
        if let notifications = viewModel?.selectedDrug?.notifications {
            notifications.forEach {
                self.createNotification($0.getString())
            }
        }
    }
    
    // Creating time interval
    private func createInterval(_ title: String) {
        let button = UIButton()
        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary,
                         NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12]
        let attributedString = NSAttributedString(string: title,
                                                  attributes: attributes)
        button.setAttributedTitle(attributedString,
                                  for: .normal)
        button.backgroundColor = Constants.Colors.grayBackground
        let topAndBottom = view.frame.width / 40
        let leftAndRight = view.frame.width / 25
        button.contentEdgeInsets = UIEdgeInsets(top: topAndBottom,
                                                left: leftAndRight,
                                                bottom: topAndBottom,
                                                right: leftAndRight)
        button.layer.cornerRadius = 8
        
        intervalStackView.addArrangedSubview(button)
    }
    
    // Creating notification
    private func createNotification(_ title: String) {
        let button = UIButton()
        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary,
                          NSAttributedString.Key.font: Constants.Fonts.nunitoRegular12]
        let attributedString = NSAttributedString(string: title,
                                                  attributes: attributes)
        button.setAttributedTitle(attributedString,
                                  for: .normal)
        button.backgroundColor = Constants.Colors.grayBackground
        let topAndBottom = view.frame.width / 40
        let leftAndRight = view.frame.width / 25
        button.contentEdgeInsets = UIEdgeInsets(top: topAndBottom,
                                                left: leftAndRight,
                                                bottom: topAndBottom,
                                                right: leftAndRight)
        button.layer.cornerRadius = 8
        notificationsStackView.addArrangedSubview(button)
    }
}

// MARK: - CustomNavigationBarDelegate
extension DetailedScreenViewController: CustomNavigationBarDelegate {
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
