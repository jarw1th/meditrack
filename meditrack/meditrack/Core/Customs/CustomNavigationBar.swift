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
    private var navigationController: UINavigationController? {
        if let navigation = delegate as? UINavigationController {
            return navigation
        } else if let navigation = delegate as? UIViewController,
                  let navigationConroller = navigation.navigationController {
            return navigationConroller
        } else { return nil }
    }
    private var viewController: UIViewController? {
        return delegate as? UIViewController
    }
    private var view: UIView {
        guard let view = viewController?.view else { return UIView() }
        return view
    }
    private var initPosition: CGPoint = .zero
    private var previousViewControllerSnapshot: UIView?
    
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
    
    // Swipe back animation
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            initPosition = view.center
            if let previousViewController = navigationController?.viewControllers.dropLast().last,
               let snapshot = previousViewController.view.snapshotView(afterScreenUpdates: true) {
                snapshot.frame = view.bounds
                view.addSubview(snapshot)
                view.sendSubviewToBack(snapshot)
                previousViewControllerSnapshot = snapshot
            }
        case .changed:
            let translation = gesture.translation(in: view)
            view.center.x = initPosition.x + translation.x
            view.center.x = max(view.center.x, view.bounds.width / 2)
            previousViewControllerSnapshot?.center.x = initPosition.x - translation.x
        case .ended, .cancelled:
            let shouldDismiss = (view.center.x > view.bounds.width * 0.75)
            UIView.animate(withDuration: 0.3) {
                if shouldDismiss {
                    self.view.center.x += self.view.bounds.width
                    self.previousViewControllerSnapshot?.center.x -= self.view.bounds.width
                } else {
                    self.view.center = self.initPosition
                    self.previousViewControllerSnapshot?.center = self.initPosition
                }
            } completion: { _ in
                if shouldDismiss {
                    self.navigationController?.popViewController(animated: false)
                }
            }
        default:
            break
        }
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
        
        let gesture = UIPanGestureRecognizer(target: self,
                                             action: #selector(handlePan))
        gesture.cancelsTouchesInView = false
        viewController?.view.addGestureRecognizer(gesture)
    }
}
