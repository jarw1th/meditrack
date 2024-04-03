import UIKit
import SnapKit

// MARK: - Class
final class FoodCollectionViewCell: UICollectionViewCell {
    // MARK: Variables
    // UI elements
    private let typeLabel = UILabel()

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
        
        typeLabel.text = nil
    }
    
    // Identifier
    override var reuseIdentifier: String? {
        return Constants.System.foodCollectionViewCell
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        contentView.addSubview(typeLabel)
        
        typeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        layer.cornerRadius = 12
    }
    
    // MARK: Functions
    // Setting up
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
