import UIKit
import SnapKit

// MARK: - Class
final class CalendarTableViewCell: UITableViewCell {
    // MARK: Variables
    // UI elements
    private let background = UIView()
    private let stackView = UIStackView()
    private let drugName = UILabel()
    private let drugInformation = UILabel()
    private let drugImage = UIImageView()
    private let imageBackground = UIView()

    // MARK: Body
    // Initial
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
    
    // Prepare for reuse
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
    
    // Identifier
    override var reuseIdentifier: String? {
        return Constants.System.calendarTableViewCell
    }
    
    // MARK: Private functions
    // Setting up constraints
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
    
    // Setting up ui elements
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 4
        
        self.backgroundColor = Constants.Colors.white
        layer.cornerRadius = 20
        layer.borderWidth = 8
        layer.borderColor = Constants.Colors.white.cgColor
        background.layer.cornerRadius = 20
    }
    
    // MARK: Functions
    // Setting up
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
        
        var nameAttributedString: NSAttributedString = NSAttributedString()
        var infoAttributedString: NSAttributedString = NSAttributedString()
        if isCompleted {
            let attributes = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            
            nameAttributedString = NSAttributedString(string: name,
                                                  attributes: attributes)
            
            infoAttributedString = NSAttributedString(string: "\(drug.getString(dose)) \(food)",
                                                  attributes: attributes)
        } else {
            let attributes = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle()] as [NSAttributedString.Key : Any]
            
            nameAttributedString = NSAttributedString(string: name,
                                                  attributes: attributes)
            
            infoAttributedString = NSAttributedString(string: "\(drug.getString(dose)) \(food)",
                                                  attributes: attributes)
        }
        drugName.attributedText = nameAttributedString
        drugInformation.attributedText = infoAttributedString
        
        let imageData = GetImages().byType(drug)
        let image = UIImage(data: imageData)
        let color = GetColors().byType(drug, style: .normal)
        drugImage.image = image?.withTintColor(white, renderingMode: .alwaysOriginal)
        drugImage.contentMode = .scaleAspectFit
        imageBackground.backgroundColor = isCompleted ? backgroundColor : color
        imageBackground.layer.cornerRadius = 8
    }
}
