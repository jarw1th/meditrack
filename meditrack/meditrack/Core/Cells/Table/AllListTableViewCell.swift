import UIKit
import SnapKit

// MARK: - Delegate
protocol AllListTableViewCellDelegate {
    func tapped(_ indexPath: IndexPath)
    
    func buttonTapped(_ indexPath: IndexPath)
}

// MARK: - Class
final class AllListTableViewCell: UITableViewCell {
    // MARK: Variables
    // General variables
    private var delegate: AllListTableViewCellDelegate?
    
    // UI elements
    private let background = UIView()
    private let stackView = UIStackView()
    private let drugName = UILabel()
    private let drugInformation = UILabel()
    private let deleteImage = UIImageView()
    private let imageBackground = UIView()

    // MARK: Body
    // Initial
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, 
                   reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        setupUI()
        setupGestures()
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
        deleteImage.image = nil
    }
    
    // Identifier
    override var reuseIdentifier: String? {
        return Constants.System.allListTableViewCell
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
                                deleteImage])
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(23)
            make.leading.equalTo(28)
            make.trailing.equalTo(deleteImage.snp.leading).inset(-32)
        }
        imageBackground.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(stackView)
            make.trailing.equalTo(-28)
        }
        deleteImage.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(imageBackground)
            make.width.height.lessThanOrEqualTo(20)
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
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tapGestureAction))
        let deleteTapGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(deleteTapGestureAction))
        self.addGestureRecognizer(tapGesture)
        imageBackground.addGestureRecognizer(deleteTapGesture)
    }
    
    @objc private func tapGestureAction(_ gesture: UITapGestureRecognizer) {
        if let tableView = superview as? UITableView,
           let indexPath = tableView.indexPath(for: self) {
            delegate?.tapped(indexPath)
        }
    }
    
    @objc private func deleteTapGestureAction(_ gesture: UITapGestureRecognizer) {
        if let tableView = superview as? UITableView,
           let indexPath = tableView.indexPath(for: self) {
            delegate?.buttonTapped(indexPath)
        }
    }
    
    // MARK: Functions
    // Setting up
    func setup(name: String,
               drug: DrugType,
               dose: Int,
               food: FoodType,
               view: AllListTableViewCellDelegate) {
        self.delegate = view
        
        let backgroundColor = GetColors().byType(drug, style: .light)
        let grayPrimary = Constants.Colors.grayPrimary
        let graySecondary = Constants.Colors.graySecondary
        
        background.backgroundColor = backgroundColor
        
        drugName.font = Constants.Fonts.nunitoSemiBold16
        drugInformation.font = Constants.Fonts.nunitoMedium12
        drugName.textColor = grayPrimary
        drugInformation.textColor = graySecondary
        
        let foodString = food.getString()
        let food = (food == .noMatter) ? "" : "(\(foodString))"
        
        drugName.text = name
        drugInformation.text = "\(drug.getString(dose)) \(food)"
        
        let image = Constants.Images.trashIcon
        let color = Constants.Colors.deleteBackground
        let imageColor = Constants.Colors.deleteAccent
        deleteImage.image = image.withTintColor(imageColor,
                                                renderingMode: .alwaysOriginal)
        deleteImage.contentMode = .scaleAspectFit
        imageBackground.backgroundColor = color
        imageBackground.layer.cornerRadius = 8
    }
}
