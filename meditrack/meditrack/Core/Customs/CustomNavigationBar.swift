import UIKit

// MARK: - Delegate
protocol CustomNavigationBarDelegate {
    func tapped(_ button: ButtonType)
}

// MARK: - ButtonType Enum
enum ButtonType {
    case left, right
}

// MARK: - Class
final class CustomNavigationBar: UIView {
    // MARK: Variables
    // General variables
    private var delegate: CustomNavigationBarDelegate?
    
    // UI elements
    private let background = UIView()
    private let titleLabel = UILabel()
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    
    // MARK: Body
    // Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    // Setting up constaraints
    private func setupConstraints() {
        self.addSubview(background)
        background.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        
        background.addSubviews([leftButton, 
                                titleLabel,
                                rightButton])
        
        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalTo(24)
            make.top.equalTo(80)
            make.bottom.equalTo(-16)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftButton.snp.trailing).inset(-24)
            make.trailing.equalTo(rightButton.snp.leading).inset(-24)
            make.top.equalTo(80)
        }
        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(80)
            make.bottom.equalTo(-16)
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        background.backgroundColor = .white
        
        titleLabel.font = Constants.Fonts.nunitoMedium20
        titleLabel.textAlignment = .center
        titleLabel.textColor = Constants.Colors.grayPrimary
        
        leftButton.addTarget(self, 
                             action: #selector(leftButtonAction),
                             for: .touchUpInside)
        rightButton.addTarget(self, 
                              action: #selector(rightButtonAction),
                              for: .touchUpInside)
    }
    
    // Left button action
    @objc private func leftButtonAction() {
        delegate?.tapped(.left)
    }
    
    // Right button action
    @objc private func rightButtonAction() {
        delegate?.tapped(.right)
    }
    
    // MARK: Functions
    // Setting back
    func setBackgroundColor(_ color: UIColor) {
        background.backgroundColor = color
    }
    
    // Setting image for button
    func setImage(_ button: ButtonType,
                  image: UIImage,
                  for state: UIControl.State) {
        switch button {
        case .left:
            leftButton.setImage(image, 
                                for: state)
        case .right:
            rightButton.setImage(image, 
                                 for: state)
        }
    }
    
    func setImage(_ button: ButtonType,
                  image: UIImage) {
        setImage(button, 
                 image: image,
                 for: .normal)
    }
    
    // Setting title for label
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    // Setting delegate
    func setDelegate(_ view: CustomNavigationBarDelegate) {
        delegate = view
    }
}
