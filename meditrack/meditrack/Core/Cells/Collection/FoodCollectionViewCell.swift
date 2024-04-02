import UIKit
import SnapKit

class FoodCollectionViewCell: UICollectionViewCell {
    private let typeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        typeLabel.text = nil
    }
    
    override var reuseIdentifier: String? {
        return Constants.System.foodCollectionViewCell
    }
    
    private func setupConstraints() {
        contentView.addSubview(typeLabel)
        
        typeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
    }
    
    // MARK: - Setup
    func setup(type: FoodType, 
               isSelected: Bool) {
        let graySecondary = Constants.Colors.graySecondary
        let grayBackground = Constants.Colors.grayBackground
        let white = Constants.Colors.white
        let green = Constants.Colors.greenAccent
        
        self.backgroundColor = isSelected ? green : grayBackground
        
        let typeString = type.getString().capitalized
        
        typeLabel.text = typeString.replacingOccurrences(of: " ", with: "\n")
        typeLabel.font = Constants.Fonts.nunitoRegular12
        typeLabel.textColor = isSelected ? white : graySecondary
        typeLabel.textAlignment = .center
        typeLabel.numberOfLines = 2
    }
}
