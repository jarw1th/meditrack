import UIKit
import SnapKit

class CalendarTableViewCell: UITableViewCell {
    private let background = UIView()
    private let stackView = UIStackView()
    private let drugName = UILabel()
    private let drugInformation = UILabel()
    private let drugImage = UIImageView()
    private let imageBackground = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [drugName, drugInformation].forEach({ $0.text = nil })
        [drugName, drugInformation].forEach({ $0.attributedText = nil })
        [drugName, drugInformation].forEach({ $0.layer.opacity = 1.0 })
        drugImage.image = nil
    }
    
    override var reuseIdentifier: String? {
        return "CalendarTableViewCell"
    }
    
    private func setupUI() {
        contentView.addSubview(background)
        background.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        background.addSubviews([stackView, imageBackground, drugImage])
        stackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(23)
            make.leading.equalTo(28)
            make.trailing.equalTo(drugImage.snp.leading).inset(-32)
        })
        imageBackground.snp.makeConstraints({ make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(stackView)
            make.trailing.equalTo(-28)
        })
        drugImage.snp.makeConstraints({ make in
            make.centerY.centerX.equalTo(imageBackground)
            make.width.height.lessThanOrEqualTo(28)
        })
        
        stackView.addArrangedSubviews([drugName, drugInformation])
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        self.backgroundColor = nil
        layer.cornerRadius = 20
        layer.borderWidth = 8
        layer.borderColor = Constants.Colors.white.cgColor
        background.layer.cornerRadius = 20
        background.backgroundColor = Constants.Colors.grayBackground
    }
    
    // MARK: - Setup
    func setup(name: String, drug: DrugType, dose: Int, food: FoodType, isCompleted: Bool) {
        drugName.font = Constants.Fonts.nunitoSemiBold16
        drugInformation.font = Constants.Fonts.nunitoMedium12
        drugName.textColor = Constants.Colors.grayPrimary
        drugInformation.textColor = Constants.Colors.graySecondary
        let food = (food == .noMatter) ? "" : "(\(food.getString()))"
        
        if isCompleted {
            var attributedString = NSAttributedString(string: name,
                                                      attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            drugName.attributedText = attributedString
            
            attributedString = NSAttributedString(string: "\(drug.getString(dose)) \(food)",
                                                  attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            drugInformation.attributedText = attributedString
            
            [drugName, drugInformation].forEach({ $0.layer.opacity = 0.5 })
        } else {
            var attributedString = NSAttributedString(string: name,
                                                      attributes: [.strikethroughStyle: nil])
            drugName.attributedText = attributedString
            
            attributedString = NSAttributedString(string: "\(drug.getString(dose)) \(food)",
                                                  attributes: [.strikethroughStyle: nil])
            drugInformation.attributedText = attributedString
            
            [drugName, drugInformation].forEach({ $0.layer.opacity = 1.0 })
            
        }
        
        let imageData = GetImages().byType(drug)
        let color = GetColors().byType(drug)
        drugImage.image = UIImage(data: imageData)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Colors.white)
        drugImage.contentMode = .scaleAspectFit
        imageBackground.backgroundColor = color
        imageBackground.layer.cornerRadius = 8
    }
}
