import UIKit
import SnapKit

class CalendarTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let drugName = UILabel()
    private let drugDose = UILabel()
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
        
        [drugName, drugDose].forEach({ $0.text = nil })
        [drugName, drugDose].forEach({ $0.attributedText = nil })
        [drugName, drugDose].forEach({ $0.layer.opacity = 1.0 })
        drugImage.image = nil
    }
    
    override var reuseIdentifier: String? {
        return "CalendarTableViewCell"
    }
    
    private func setupUI() {
        contentView.addSubviews([stackView, drugImage])
        stackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(20)
            make.trailing.equalTo(drugImage.snp.leading).inset(-32)
        })
        drugImage.snp.makeConstraints({ make in
            make.width.height.equalTo(32)
            make.centerY.equalTo(stackView)
            make.trailing.equalTo(-20)
        })
        
        stackView.addArrangedSubviews([drugName, drugDose])
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        self.backgroundColor = Constants.Colors.grayBackground
        layer.cornerRadius = 16
        layer.borderWidth = 8
        layer.borderColor = Constants.Colors.white.cgColor
    }
    
    // MARK: - Setup
    func setup(name: String, drug: DrugType, dose: Int, isCompleted: Bool) {
        drugName.font = Constants.Fonts.nunitoSemiBold16
        drugDose.font = Constants.Fonts.nunitoMedium12
        drugName.textColor = Constants.Colors.grayPrimary
        drugDose.textColor = Constants.Colors.graySecondary
        
        if isCompleted {
            var attributedString = NSAttributedString(string: name,
                                                      attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            drugName.attributedText = attributedString
            
            attributedString = NSAttributedString(string: "\(Constants.Texts.systemDoseSub) \(dose) · \(drug)",
                                                  attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            drugDose.attributedText = attributedString
            
            [drugName, drugDose].forEach({ $0.layer.opacity = 0.5 })
        } else {
            var attributedString = NSAttributedString(string: name,
                                                      attributes: [.strikethroughStyle: nil])
            drugName.attributedText = attributedString
            
            attributedString = NSAttributedString(string: "\(Constants.Texts.systemDoseSub) \(dose) · \(drug)",
                                                  attributes: [.strikethroughStyle: nil])
            drugDose.attributedText = attributedString
            
            [drugName, drugDose].forEach({ $0.layer.opacity = 1.0 })
            
        }
        
        let imageData = GetImages().byType(drug)
        drugImage.image = UIImage(data: imageData)
        drugImage.layer.cornerRadius = 10
    }
}
