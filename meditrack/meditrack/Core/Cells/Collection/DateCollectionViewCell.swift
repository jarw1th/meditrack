import UIKit
import SnapKit

// MARK: - Class
final class DateCollectionViewCell: UICollectionViewCell {
    // MARK: Variables
    // UI elements
    private let weekDayLabel = UILabel()
    private let dateLabel = UILabel()
    private let selectedBackground = UIView()

    // MARK: Body
    // Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let elementsArray = [weekDayLabel, 
                             dateLabel]
        elementsArray.forEach { $0.text = nil }
    }
    
    // Identifier
    override var reuseIdentifier: String? {
        return Constants.System.dateCollectionViewCell
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        contentView.addSubviews([weekDayLabel, 
                                 selectedBackground,
                                 dateLabel])
        
        weekDayLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        selectedBackground.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(weekDayLabel.snp.bottom).inset(-8)
            make.centerX.bottom.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(selectedBackground.snp.centerX)
            make.centerY.equalTo(selectedBackground.snp.centerY)
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        selectedBackground.isHidden = true
        selectedBackground.backgroundColor = Constants.Colors.greenAccent
        selectedBackground.layer.cornerRadius = 8
    }
    
    // MARK: Functions
    // Setting up
    func setup(date: Date,
               isSelected: Bool,
               isToday: Bool) {
        let formatter = DateFormatter()
        
        let graySecondary = Constants.Colors.graySecondary
        let grayPrimary = Constants.Colors.grayPrimary
        let white = Constants.Colors.white
        let green = Constants.Colors.greenAccent
        
        selectedBackground.backgroundColor = (isToday && !isSelected) ? graySecondary : green
        selectedBackground.isHidden = !isSelected && !isToday
        
        formatter.dateFormat = "dd"
        dateLabel.text = formatter.string(from: date)
        dateLabel.font = Constants.Fonts.nunitoSemiBold16
        dateLabel.textColor = (isSelected || isToday) ? white : grayPrimary

        formatter.dateFormat = "EEE"
        weekDayLabel.text = formatter.string(from: date).capitalized
        weekDayLabel.font = Constants.Fonts.nunitoMedium16
        weekDayLabel.textColor = Constants.Colors.graySecondary
    }
}
