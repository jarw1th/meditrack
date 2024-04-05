import UIKit
import SnapKit

// MARK: - Class
final class ProgressView: UIView {
    // MARK: Variables
    // UI elements
    private let background = UIView()
    
    private let stackView = UIStackView()
    private let progressLabel = UILabel()
    private let progressSubLabel = UILabel()
    
    private let percents = UILabel()
    
    // MARK: Body
    // Initial
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        self.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        background.addSubviews([stackView,
                                percents])
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        }
        percents.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        stackView.addArrangedSubviews([progressLabel,
                                       progressSubLabel])
    }
    
    // Setting up ui elements
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 4
        
        progressLabel.font = Constants.Fonts.nunitoSemiBold16
        progressLabel.textColor = Constants.Colors.grayPrimary
        progressLabel.text = Constants.Texts.labelProgressMain
        progressLabel.textAlignment = .left
        
        progressSubLabel.font = Constants.Fonts.nunitoMedium12
        progressSubLabel.textColor = Constants.Colors.graySecondary
        progressSubLabel.textAlignment = .left
        
        percents.font = Constants.Fonts.nunitoBold20
        percents.textAlignment = .right
    }
    
    // MARK: Internal functions
    // Setting up delegate
    func setup(type: DrugType,
               percent: Int,
               startDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMd"
        
        let backgroundColor = GetColors().byType(type,
                                                 style: .light)
        let color = GetColors().byType(type,
                                       style: .normal)
        let date = dateFormatter.string(from: startDate)
        let subText = Constants.Texts.labelProgressSub
        let percent = String(percent)
        
        background.backgroundColor = backgroundColor
        
        progressSubLabel.text = "\(subText) \(date)"
        
        percents.textColor = color
        percents.text = "\(percent)%"
    }
}


