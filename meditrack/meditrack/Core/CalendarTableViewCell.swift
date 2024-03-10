import UIKit
import SnapKit

class CalendarTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let drugName = UILabel()
    private let drugType = UILabel()
    private let drugImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [drugName, drugType].forEach({ $0.text = nil })
    }
    
    override var reuseIdentifier: String? {
        return "CalendarTableViewCell"
    }
    
    private func setupUI() {
        contentView.addSubviews([stackView, drugImage])
        stackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview()
        })
        stackView.addSubviews([drugName, drugType])
        drugName.snp.makeConstraints({ make in
            make.top.equalTo(8)
            make.leading.equalTo(16)
            make.trailing.equalTo(drugImage.snp.leading).inset(-16)
        })
        drugType.snp.makeConstraints({ make in
            make.top.equalTo(drugName.snp.bottom).inset(-4)
            make.bottom.equalTo(-8)
            make.leading.equalTo(16)
            make.trailing.equalTo(drugImage.snp.leading).inset(-16)
        })
        drugImage.snp.makeConstraints({ make in
            make.width.height.equalTo(60)
            make.centerY.equalTo(stackView)
            make.trailing.equalTo(-16)
        })
        
        stackView.axis = .vertical
        
        self.backgroundColor = Constants.Colors.grayBackground
        layer.cornerRadius = 10
    }
    
    // MARK: - Setup
    func setup(name: String, drug: DrugType, isCompleted: Bool) {
        drugName.font = Constants.Fonts.nunitoRegularTitle
        drugType.font = Constants.Fonts.nunitoRegularSubtitle
        [drugName, drugType].forEach({ $0.textColor = Constants.Colors.grayAccent })
        
        if isCompleted {
            var attributedString = NSAttributedString(string: name,
                                                      attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            drugName.attributedText = attributedString
            
            attributedString = NSAttributedString(string: drug.rawValue,
                                                  attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            drugType.attributedText = attributedString
            
            [drugName, drugType].forEach({ $0.layer.opacity = 0.5 })
        } else {
            drugName.text = name
            drugType.text = drug.rawValue
        }
        
        let imageData = GetImages().byType(drug)
        drugImage.image = UIImage(data: imageData)
        drugImage.layer.cornerRadius = 10
    }
}
