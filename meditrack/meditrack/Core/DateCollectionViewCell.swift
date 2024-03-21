import UIKit
import SnapKit

class DateCollectionViewCell: UICollectionViewCell {
    private let weekDayLabel = UILabel()
    private let dateLabel = UILabel()
    private let selectedBackground = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [weekDayLabel, dateLabel].forEach({ $0.text = nil })
    }
    
    override var reuseIdentifier: String? {
        return "DateCollectionViewCell"
    }
    
    private func setupUI() {
        contentView.addSubviews([weekDayLabel, selectedBackground, dateLabel])
        weekDayLabel.snp.makeConstraints({ make in
            make.top.centerX.equalToSuperview()
        })
        selectedBackground.snp.makeConstraints({ make in
            make.width.height.equalTo(32)
            make.top.equalTo(weekDayLabel.snp.bottom).inset(-8)
            make.centerX.bottom.equalToSuperview()
        })
        dateLabel.snp.makeConstraints({ make in
            make.centerX.equalTo(selectedBackground.snp.centerX)
            make.centerY.equalTo(selectedBackground.snp.centerY)
        })
        
        selectedBackground.isHidden = true
        selectedBackground.backgroundColor = Constants.Colors.greenAccent
        selectedBackground.layer.cornerRadius = 8
    }
    
    // MARK: - Setup
    func setup(date: Date, isSelected: Bool, isToday: Bool) {
        let formatter = DateFormatter()
        
        selectedBackground.backgroundColor = isToday && !isSelected ? Constants.Colors.graySecondary : Constants.Colors.greenAccent
        selectedBackground.isHidden = !isSelected && !isToday
        
        formatter.dateFormat = "dd"
        dateLabel.text = formatter.string(from: date)
        dateLabel.font = Constants.Fonts.nunitoSemiBold16
        dateLabel.textColor = isSelected || isToday ? Constants.Colors.white : Constants.Colors.grayPrimary

        formatter.dateFormat = "EEE"
        weekDayLabel.text = formatter.string(from: date).capitalized
        weekDayLabel.font = Constants.Fonts.nunitoMedium16
        weekDayLabel.textColor = Constants.Colors.graySecondary
    }
}
