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
            make.top.bottom.leading.trailing.equalToSuperview().inset(4)
        })
        stackView.addSubviews([typeImage, typeLabel])
        typeImage.snp.makeConstraints({ make in
            make.top.equalTo(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        })
        typeLabel.snp.makeConstraints({ make in
            make.bottom.equalTo(-8)
            make.centerX.equalToSuperview()
        })
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        layer.borderWidth = 4
        layer.cornerRadius = 10
    }
    
    // MARK: - Setup
    func setup(type: DrugType, isSelected: Bool) {
        self.backgroundColor = isSelected ? .white : Constants.Colors.grayBackground
        self.layer.borderColor = isSelected ? Constants.Colors.grayAccent?.cgColor : CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        
        typeLabel.text = type.rawValue
        typeLabel.font = Constants.Fonts.nunitoRegularSubtitle
        typeLabel.textColor = Constants.Colors.grayAccent
        typeLabel.textAlignment = .center

        let image = UIImage(data: GetImages().byType(type))
        typeImage.image = image
    }
}
