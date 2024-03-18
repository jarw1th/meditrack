import UIKit
import SnapKit

class CalendarTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let drugName = UILabel()
    private let doseNumber = UILabel()
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
        [drugName, doseNumber].forEach({ $0.text = nil })
        [drugName, doseNumber].forEach({ $0.attributedText = nil })
        [drugName, doseNumber].forEach({ $0.layer.opacity = 1.0 })
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
        stackView.addSubviews([drugName, doseNumber])
        drugName.snp.makeConstraints({ make in
            make.top.equalTo(12)
            make.leading.equalTo(24)
            make.trailing.equalTo(drugImage.snp.leading).inset(-16)
        })
        doseNumber.snp.makeConstraints({ make in
            make.top.equalTo(drugName.snp.bottom)
            make.bottom.equalTo(-12)
            make.leading.equalTo(24)
            make.trailing.equalTo(drugImage.snp.leading).inset(-16)
        })
        drugImage.snp.makeConstraints({ make in
            make.width.height.equalTo(60)
            make.centerY.equalTo(stackView)
            make.trailing.equalTo(-16)
        })
        
        stackView.axis = .vertical
        
        self.backgroundColor = Constants.Colors.grayBackground
        layer.cornerRadius = 20
        layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        layer.borderWidth = 5
    }
    
    // MARK: - Setup
    func setup(name: String, drug: DrugType, dose: Int, isCompleted: Bool) {
        drugName.font = Constants.Fonts.nunitoRegularTitle
        doseNumber.font = Constants.Fonts.nunitoRegularSubtitle
        [drugName, doseNumber].forEach({ $0.textColor = Constants.Colors.grayAccent })
        
        if isCompleted {
            var attributedString = NSAttributedString(string: name,
                                                      attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            drugName.attributedText = attributedString
            
            attributedString = NSAttributedString(string: "\(Constants.Texts.systemDoseSub) \(dose) · \(drug)",
                                                  attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            doseNumber.attributedText = attributedString
            
            [drugName, doseNumber].forEach({ $0.layer.opacity = 0.5 })
        } else {
            var attributedString = NSAttributedString(string: name,
                                                      attributes: [.strikethroughStyle: nil])
            drugName.attributedText = attributedString
            
            attributedString = NSAttributedString(string: "\(Constants.Texts.systemDoseSub) \(dose) · \(drug)",
                                                  attributes: [.strikethroughStyle: nil])
            doseNumber.attributedText = attributedString
            
            [drugName, doseNumber].forEach({ $0.layer.opacity = 1.0 })
            
        }
        
        let imageData = GetImages().byType(drug)
        drugImage.image = UIImage(data: imageData)
        drugImage.layer.cornerRadius = 10
    }
}
