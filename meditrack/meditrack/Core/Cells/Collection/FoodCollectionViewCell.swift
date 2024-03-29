import UIKit
import SnapKit

class FoodCollectionViewCell: UICollectionViewCell {
    private let typeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [typeLabel].forEach({ $0.text = nil })
    }
    
    override var reuseIdentifier: String? {
        return "FoodCollectionViewCell"
    }
    
    private func setupUI() {
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        
        layer.cornerRadius = 12
    }
    
    // MARK: - Setup
    func setup(type: FoodType, isSelected: Bool) {
        self.backgroundColor = isSelected ? Constants.Colors.greenAccent : Constants.Colors.grayBackground
        
        typeLabel.text = type.getString().capitalized.replacingOccurrences(of: " ", with: "\n")
        typeLabel.font = Constants.Fonts.nunitoRegular12
        typeLabel.textColor = isSelected ? Constants.Colors.white : Constants.Colors.graySecondary
        typeLabel.textAlignment = .center
        typeLabel.numberOfLines = 2
    }
}
