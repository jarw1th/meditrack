import UIKit
import SnapKit

class TypeCollectionViewCell: UICollectionViewCell {
    private let stackView = UIStackView()
    private let typeImage = UIImageView()
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
        typeImage.image = nil
    }
    
    override var reuseIdentifier: String? {
        return "TypeCollectionViewCell"
    }
    
    private func setupConstraints() {
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(12)
        }
        
        stackView.addSubviews([typeImage,
                               typeLabel])
        
        typeImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.lessThanOrEqualTo(36)
        }
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(typeImage.snp.bottom).inset(-8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupUI() {
        stackView.axis = .vertical
        stackView.alignment = .center
        
        layer.cornerRadius = 12
    }
    
    // MARK: - Setup
    func setup(type: DrugType, 
               isSelected: Bool) {
        let color = GetColors().byType(type, style: .normal)
        let grayBackground = Constants.Colors.grayBackground
        let graySecondary = Constants.Colors.graySecondary
        let white = Constants.Colors.white
        
        self.backgroundColor = isSelected ? color : grayBackground
        
        typeLabel.text = type.rawValue
        typeLabel.font = Constants.Fonts.nunitoRegular12
        typeLabel.textColor = isSelected ? white : graySecondary
        typeLabel.textAlignment = .center

        let imageData = GetImages().byType(type)
        let image = UIImage(data: imageData)
        let normalImage = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        let selectedImage = image?.withTintColor(white, renderingMode: .alwaysOriginal)
        typeImage.image = isSelected ? selectedImage : normalImage
        typeImage.contentMode = .scaleAspectFit
    }
}
