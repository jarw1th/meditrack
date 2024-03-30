import UIKit
import SnapKit

// Delegate 
protocol FilterDropDownDelegate {
    func tapped(_ type: DrugType?)
}

final class FilterDropDown: UIView {
    private var tapDelegate: FilterDropDownDelegate?
    
    private let background = UIView()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(background)
        background.snp.makeConstraints({ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        })
        background.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        })
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        background.layer.cornerRadius = 4
        background.backgroundColor = Constants.Colors.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(view: FilterDropDownDelegate) {
        tapDelegate = view
        self.isHidden = true
    }
    
    func appear(filterArray: [DrugType]) {
        filterArray.forEach({ type in
            let label = UILabel()
            let attributedString = NSAttributedString(string: type.rawValue,
                                                      attributes: [
                                                        NSAttributedString.Key.foregroundColor: Constants.Colors.graySecondary!,
                                                        NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16!
                                                      ])
            label.attributedText = attributedString
            label.textAlignment = .right
            stackView.addArrangedSubview(label)
        })
        
        self.isHidden.toggle()
    }
    
    func disappear() {
        self.isHidden = true
    }
}


