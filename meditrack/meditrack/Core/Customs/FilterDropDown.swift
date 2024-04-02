import UIKit
import SnapKit

// MARK: - Delegate
protocol FilterDropDownDelegate {
    func tapped(_ type: DrugType?)
}

// MARK: - Class
final class FilterDropDown: UIView {
    // MARK: Variables
    // General variables
    private var tapDelegate: FilterDropDownDelegate?
    
    // UI elements
    private let background = UIView()
    private let stackView = UIStackView()
    
    // MARK: Body
    // Initial
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        self.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        background.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 4
        
        background.layer.cornerRadius = 4
        background.backgroundColor = Constants.Colors.white
    }
    
    // MARK: Internal functions
    // Setting up delegate
    func setup(view: FilterDropDownDelegate) {
        tapDelegate = view
        self.isHidden = true
    }
    
    // Appear function
    func appear(filterArray: [DrugType]) {
        filterArray.forEach { type in
            let label = UILabel()
            let attributedString = NSAttributedString(string: type.rawValue,
                                                      attributes: [
                                                        NSAttributedString.Key.foregroundColor: Constants.Colors.graySecondary,
                                                        NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16
                                                      ])
            label.attributedText = attributedString
            label.textAlignment = .right
            stackView.addArrangedSubview(label)
        }
        
        self.isHidden.toggle()
    }
    
    // Dissappear function
    func disappear() {
        self.isHidden = true
    }
}


