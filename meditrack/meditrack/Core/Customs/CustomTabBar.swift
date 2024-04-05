import UIKit

// MARK: - Delegate
protocol CustomTabBarDelegate {
    func tapped(_ button: ButtonType)
}

// MARK: - Class
final class CustomTabBar: UIView {
    // MARK: Variables
    // General variables
    private var delegate: CustomTabBarDelegate?
    private var tabBarController: UITabBarController? {
        if let tabBar = delegate as? UITabBarController {
            return tabBar
        } else if let tabBar = delegate as? UIViewController,
                  let tabBarController = tabBar.tabBarController {
            return tabBarController
        } else { return nil }
    }
    private var viewController: UIViewController? {
        return delegate as? UIViewController
    }
    private var view: UIView {
        guard let view = viewController?.view else { return UIView() }
        return view
    }
    
    // UI elements
    private let background = UIView()
    private var buttonsArray = [UIButton(),
                               UIButton(),
                               UIButton()]
    private let backgroundButtonsArray = [UIView(),
                                          UIView(),
                                          UIView()]
    
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
        
        let tagBackground0 = backgroundButtonsArray[0]
        let tagBackground1 = backgroundButtonsArray[1]
        let tagBackground2 = backgroundButtonsArray[2]
        let width = (view.frame.width - 48) / 2.875
        
        let tag0 = buttonsArray[0]
        let tag1 = buttonsArray[1]
        let tag2 = buttonsArray[2]
        
        background.addSubviews([tagBackground0,
                                tagBackground1,
                                tagBackground2])
        tagBackground0.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(40)
            make.centerY.equalTo(tag0.snp.centerY)
            make.centerX.equalTo(tag0.snp.centerX)
        }
        tagBackground1.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(40)
            make.centerY.equalTo(tag1.snp.centerY)
            make.centerX.equalTo(tag1.snp.centerX)
        }
        tagBackground2.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(40)
            make.centerY.equalTo(tag2.snp.centerY)
            make.centerX.equalTo(tag2.snp.centerX)
        }
        
        background.addSubviews([tag0,
                                tag1,
                                tag2])
        tag0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalTo(60)
            make.centerY.equalToSuperview()
        }
        tag1.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.centerX.equalToSuperview()
        }
        tag2.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalTo(-60)
            make.centerY.equalToSuperview()
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        background.backgroundColor = Constants.Colors.greenAccent
        
        backgroundButtonsArray.forEach {
            $0.backgroundColor = Constants.Colors.white
        }
    }
    
    // Tag 0 action
    @objc private func tag0Action() {
        tabBarController?.selectedIndex = 0
    }
    
    // Tag 1 action
    @objc private func tag1Action() {
        tabBarController?.selectedIndex = 1
    }
    
    // Tag 2 action
    @objc private func tag2Action() {
        tabBarController?.selectedIndex = 2
    }
    
    // MARK: Functions
    // Setting back
    func setBackgroundColor(_ color: UIColor) {
        background.backgroundColor = color
    }
    
    // Setting image for button
    func setImages(_ images: [UIImage],
                   for state: UIControl.State) {
        for imageIndex in 0...images.count - 1 {
            
        }
    }
    
    func setImage(_ images: [UIImage]) {
        setImages(images,
                  for: .normal)
    }
    
    // Setting title for label
//    func setTitle(_ title: String) {
//        titleLabel.text = title
//    }
//    
//    // Setting delegate
//    func setDelegate(_ view: CustomNavigationBarDelegate) {
//        delegate = view
//        
//        let gesture = UIPanGestureRecognizer(target: self,
//                                             action: #selector(handlePan))
//        gesture.cancelsTouchesInView = false
//        viewController?.view.addGestureRecognizer(gesture)
//    }
}
