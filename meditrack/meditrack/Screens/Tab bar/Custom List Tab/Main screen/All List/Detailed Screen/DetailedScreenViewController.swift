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
    
    private let drugNameLabel = UILabel()
    private let drugDescriptionLabel = UILabel()
    
    private let scheduleLabel = UILabel()
    private let intervalScrollView = UIScrollView()
    private let intervalStackView = UIStackView()
    
    private let detailsLabel = UILabel()
    private let informationColumns = InformationColumns()
    
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
        view.addSubviews([navigationBar,
                          scrollView])
        
        scrollView.addSubviews([drugNameLabel,
                                drugDescriptionLabel])
        
        scrollView.addSubviews([scheduleLabel,
                                intervalScrollView])
        intervalScrollView.addSubview(intervalStackView)
        
        scrollView.addSubviews([detailsLabel,
                                informationColumns])
        
        scrollView.addSubviews([notificationsLabel,
                                notificationsScrollView])
        notificationsScrollView.addSubview(notificationsStackView)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).inset(-8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        drugNameLabel.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width - 48)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalToSuperview()
        }
        drugDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(drugNameLabel.snp.bottom).inset(-16)
        }
        
        scheduleLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(drugDescriptionLabel.snp.bottom).inset(-24)
        }
        intervalScrollView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(scheduleLabel.snp.bottom).inset(-16)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
        }
        intervalStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(scheduleLabel.snp.bottom).inset(-76)
        }
        informationColumns.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(detailsLabel.snp.bottom).inset(-16)
        }
        
        notificationsLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(informationColumns.snp.bottom).inset(-24)
        }
        notificationsScrollView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(notificationsLabel.snp.bottom).inset(-16)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
        }
        notificationsStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
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
        
        
        drugNameLabel.text = viewModel?.selectedDrug?.name
        drugNameLabel.font = Constants.Fonts.nunitoBold20
        drugNameLabel.textColor = Constants.Colors.grayPrimary
        
        drugDescriptionLabel.text = viewModel?.selectedDrug?.descriptionDrug
        drugDescriptionLabel.font = Constants.Fonts.nunitoRegular12
        drugDescriptionLabel.textColor = Constants.Colors.grayPrimary
        
        
        scheduleLabel.text = Constants.Texts.labelScheduleMain
        scheduleLabel.font = Constants.Fonts.nunitoBold20
        scheduleLabel.textColor = Constants.Colors.grayPrimary
        
        intervalScrollView.bounces = false
        intervalScrollView.isScrollEnabled = true
        intervalScrollView.showsHorizontalScrollIndicator = false
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
        notificationsStackView.axis = .horizontal
        notificationsStackView.spacing = 16
        notificationsStackView.contentMode = .center
        
    
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
        button.contentEdgeInsets = UIEdgeInsets(top: 10,
                                                left: 16,
                                                bottom: 10,
                                                right: 16)
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
        button.contentEdgeInsets = UIEdgeInsets(top: 10,
                                                left: 16,
                                                bottom: 10,
                                                right: 16)
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
