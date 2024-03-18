import UIKit
import SnapKit

protocol PickerEditedDelegate {
    func tap(_ value: Date)
}

final class TimePicker: UIView {
    private var tapDelegate: PickerEditedDelegate?
    
    private let backgroundView = UIView()
    private let nameLabel = UILabel()
    private let startLabel = UILabel()
    private let picker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubviews([backgroundView, nameLabel, startLabel, picker])
        backgroundView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        nameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        })
        startLabel.snp.makeConstraints({ make in
            make.trailing.equalTo(picker.snp.leading).inset(-16)
            make.centerY.equalToSuperview()
        })
        picker.snp.makeConstraints({ make in
            make.trailing.equalTo(-8)
            make.centerY.equalToSuperview()
        })
        
        backgroundView.backgroundColor = Constants.Colors.grayBackground
        backgroundView.layer.cornerRadius = 10
        
        nameLabel.textColor = Constants.Colors.grayAccent
        nameLabel.font = Constants.Fonts.nunitoRegularSubtitle
        nameLabel.layer.opacity = 0.6
        nameLabel.textAlignment = .left
        
        startLabel.text = Constants.Texts.labelTimepickerSub
        startLabel.textColor = Constants.Colors.grayAccent
        startLabel.font = Constants.Fonts.nunitoRegularSubtitle
        startLabel.layer.opacity = 0.6
        startLabel.textAlignment = .right
        
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(tapped), for: .valueChanged)
    }
    
    @objc private func tapped() {
        tapDelegate?.tap(picker.date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, view: PickerEditedDelegate) {
        tapDelegate = view
        nameLabel.text = name
    }
}
