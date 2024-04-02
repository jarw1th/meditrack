import UIKit
import SnapKit

class CalendarTableViewCell: UITableViewCell {
    private let background = UIView()
    private let stackView = UIStackView()
    private let drugName = UILabel()
    private let drugInformation = UILabel()
    private let drugImage = UIImageView()
    private let imageBackground = UIView()

    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, 
                   reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let elementsArray = [drugName,
                             drugInformation]
        elementsArray.forEach {
            $0.text = nil
            $0.attributedText = nil
            $0.layer.opacity = 1.0
        }
        drugImage.image = nil
    }
    
    override var reuseIdentifier: String? {
        return Constants.System.calendarTableViewCell
    }
    
    private func setupConstraints() {
        contentView.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        background.addSubviews([stackView, 
                                imageBackground,
                                drugImage])
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(23)
            make.leading.equalTo(28)
            make.trailing.equalTo(drugImage.snp.leading).inset(-32)
        }
        imageBackground.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(stackView)
            make.trailing.equalTo(-28)
        }
        drugImage.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(imageBackground)
            make.width.height.lessThanOrEqualTo(28)
        }
        
        stackView.addArrangedSubviews([drugName, 
                                       drugInformation])
    }
    
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 4
        
        self.backgroundColor = Constants.Colors.white
        layer.cornerRadius = 20
        layer.borderWidth = 8
        layer.borderColor = Constants.Colors.white.cgColor
        background.layer.cornerRadius = 20
    }
    
    // MARK: - Setup
    func setup(name: String, 
               drug: DrugType,
               dose: Int,
               food: FoodType,
               isCompleted: Bool) {
        let backgroundColor = GetColors().byType(drug, style: .light)
        let grayBackground = Constants.Colors.grayBackground
        let graySecondaryLight = Constants.Colors.graySecondaryLight
        let grayPrimary = Constants.Colors.grayPrimary
        let graySecondary = Constants.Colors.graySecondary
        let white = Constants.Colors.white
        
        background.backgroundColor = isCompleted ? grayBackground : backgroundColor
        
        drugName.font = Constants.Fonts.nunitoSemiBold16
        drugInformation.font = Constants.Fonts.nunitoMedium12
        drugName.textColor = isCompleted ? graySecondaryLight : grayPrimary
        drugInformation.textColor = isCompleted ? graySecondaryLight : graySecondary
        let foodString = food.getString()
        let food = (food == .noMatter) ? "" : "(\(foodString))"
        
        var attributedString: NSAttributedString = NSAttributedString()
        if isCompleted {
            let attributes = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            
            attributedString = NSAttributedString(string: name,
                                                  attributes: attributes)
            
            attributedString = NSAttributedString(string: "\(drug.getString(dose)) \(food)",
                                                  attributes: attributes)
        } else {
            let attributes = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle()] as [NSAttributedString.Key : Any]
            
            attributedString = NSAttributedString(string: name,
                                                  attributes: attributes)
            
            attributedString = NSAttributedString(string: "\(drug.getString(dose)) \(food)",
                                                  attributes: attributes)
        }
        drugName.attributedText = attributedString
        drugInformation.attributedText = attributedString
        
        let imageData = GetImages().byType(drug)
        let image = UIImage(data: imageData)
        let color = GetColors().byType(drug, style: .normal)
        drugImage.image = image?.withTintColor(white, renderingMode: .alwaysOriginal)
        drugImage.contentMode = .scaleAspectFit
        imageBackground.backgroundColor = isCompleted ? backgroundColor : color
        imageBackground.layer.cornerRadius = 8
    }
}
