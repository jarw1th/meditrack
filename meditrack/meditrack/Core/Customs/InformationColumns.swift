import UIKit
import SnapKit

// MARK: - Class
final class InformationColumns: UIView {
    // MARK: Variables
    // UI elements
    private let labelsStackView = UIStackView()
    private let valuesStackView = UIStackView()
    
    private let typeLabel = UILabel()
    private let durationLabel = UILabel()
    private let frequencyLabel = UILabel()
    private let foodLabel = UILabel()
    
    private let typeValue = UILabel()
    private let durationValue = UILabel()
    private let frequencyValue = UILabel()
    private let foodValue = UILabel()
    
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
        self.addSubview(labelsStackView)
        
        labelsStackView.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.leading.top.bottom.equalToSuperview()
        }
        
        self.addSubview(valuesStackView)
        
        valuesStackView.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.trailing.top.bottom.equalToSuperview()
        }
        
        labelsStackView.addArrangedSubviews([typeLabel,
                                             durationLabel,
                                             frequencyLabel,
                                             foodLabel])
        valuesStackView.addArrangedSubviews([typeValue,
                                             durationValue,
                                             frequencyValue,
                                             foodValue])
    }
    
    // Setting up ui elements
    private func setupUI() {
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 12
        
        valuesStackView.axis = .vertical
        valuesStackView.spacing = 12
        
        [typeLabel,
         durationLabel,
         frequencyLabel,
         foodLabel].forEach {
            $0.font = Constants.Fonts.nunitoRegular12
            $0.textColor = Constants.Colors.graySecondary
            $0.textAlignment = .left
        }
        
        [typeValue,
         durationValue,
         frequencyValue,
         foodValue].forEach {
            $0.font = Constants.Fonts.nunitoRegular12
            $0.textColor = Constants.Colors.grayPrimary
            $0.textAlignment = .right
        }
        
        typeLabel.text = Constants.Texts.labelTypeMain
        durationLabel.text = Constants.Texts.dropdownDurationSub
        frequencyLabel.text = Constants.Texts.dropdownFrequencySub
        foodLabel.text = Constants.Texts.labelFoodMain
    }
    
    // MARK: Internal functions
    // Setting up delegate
    func setup(type: DrugType?,
               duration: Int?,
               frequency: FrequencyType?,
               food: FoodType?) {
        typeValue.text = type?.rawValue
        durationValue.text = String(duration ?? 0)
        frequencyValue.text = frequency?.rawValue
        foodValue.text = food?.rawValue
    }
}


