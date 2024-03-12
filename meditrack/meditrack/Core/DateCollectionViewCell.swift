import UIKit
import SnapKit

class DateCollectionViewCell: UICollectionViewCell {
    private let stackView = UIStackView()
    private let weekDayLabel = UILabel()
    private let dateLabel = UILabel()

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
        contentView.addSubviews([stackView])
        stackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview()
        })
        stackView.addArrangedSubviews([weekDayLabel, dateLabel])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        
        layer.cornerRadius = 10
    }
    
    // MARK: - Setup
    func setup(date: Date, isSelected: Bool) {
        let formatter = DateFormatter()
        
        self.backgroundColor = isSelected ? Constants.Colors.grayAccent : Constants.Colors.grayBackground
        
        formatter.dateFormat = "dd"
        dateLabel.text = formatter.string(from: date)
        dateLabel.font = Constants.Fonts.nunitoRegularSubtitle
        dateLabel.textColor = isSelected ? Constants.Colors.grayBackground : Constants.Colors.grayAccent

        formatter.dateFormat = "EEE"
        weekDayLabel.text = formatter.string(from: date).uppercased()
        weekDayLabel.font = Constants.Fonts.nunitoRegularSubtitle
        weekDayLabel.textColor =  isSelected ? Constants.Colors.grayBackground : Constants.Colors.grayAccent
    }
}
