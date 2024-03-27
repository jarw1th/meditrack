import UIKit
import SnapKit

class TypeCollectionViewCell: UICollectionViewCell {
    private let stackView = UIStackView()
    private let typeImage = UIImageView()
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
        [typeImage].forEach({ $0.image = nil })
    }
    
    override var reuseIdentifier: String? {
        return "TypeCollectionViewCell"
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(12)
        })
        stackView.addSubviews([typeImage, typeLabel])
        typeImage.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.height.lessThanOrEqualTo(40)
        })
        typeLabel.snp.makeConstraints({ make in
            make.top.equalTo(typeImage.snp.bottom).inset(-8)
            make.centerX.equalToSuperview()
        })
        
        stackView.axis = .vertical
        stackView.alignment = .center
        
        layer.cornerRadius = 12
    }
    
    // MARK: - Setup
    func setup(type: DrugType, isSelected: Bool) {
        let color = GetColors().byType(type)
        self.backgroundColor = isSelected ? color : Constants.Colors.grayBackground
        
        typeLabel.text = type.rawValue
        typeLabel.font = Constants.Fonts.nunitoRegular12
        typeLabel.textColor = isSelected ? Constants.Colors.white : Constants.Colors.graySecondary
        typeLabel.textAlignment = .center

        let image = UIImage(data: GetImages().byType(type))
        let normalImage = image?.withRenderingMode(.alwaysOriginal).withTintColor(color)
        let selectedImage = image?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.white)
        typeImage.image = isSelected ? selectedImage : normalImage
        typeImage.contentMode = .scaleAspectFit
    }
}
