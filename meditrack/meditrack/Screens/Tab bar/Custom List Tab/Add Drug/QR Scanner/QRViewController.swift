import UIKit
import AVFoundation
import SnapKit

// MARK: - Class
final class QRViewController: UIViewController {
    // MARK: Variables
    // Genaral variables
    private var viewModel: QRViewModelProtocol?
    private var captureSession: AVCaptureSession = AVCaptureSession()
    
    // UI elements
    private let preview = UIView()
    private var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    private let navigationBar = CustomNavigationBar()
    
    private let qrPointer = UIImageView()
    
    // MARK: Body
    // Initial
    convenience init(viewModel: QRViewModelProtocol?) {
        self.init()
        
        self.viewModel = viewModel
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession.isRunning == false) {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    // MARK: Private functions
    // Setting up constraints
    private func setupConstraints() {
        view.layer.addSublayer(previewLayer)
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    // Setting up ui elements
    private func setupUI() {
        view.backgroundColor = Constants.Colors.white
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            showAlert()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            showAlert()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        let leftIcon = Constants.Images.backIcon.withTintColor(Constants.Colors.white,
                                                               renderingMode: .alwaysOriginal)
        let rightIcon = Constants.Images.picturesIcon.withTintColor(Constants.Colors.white,
                                                                    renderingMode: .alwaysOriginal)
        navigationBar.setDelegate(self)
        navigationBar.setTitle(Constants.Texts.titleScanmedicationMain)
        navigationBar.setTitleColor(Constants.Colors.white)
        navigationBar.setImage(.left,
                               image: leftIcon)
        navigationBar.setImage(.right,
                               image: rightIcon)
        navigationBar.setBackgroundColor(.clear)
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    private func showAlert() {
        let attributes = [NSAttributedString.Key.font: Constants.Fonts.nunitoRegular16,
                          NSAttributedString.Key.foregroundColor: Constants.Colors.grayPrimary]
        let titleAttributedString = NSAttributedString(string: Constants.Texts.alertFailscanMain,
                                                       attributes: attributes)
        
        let alert = UIAlertController(title: titleAttributedString.string,
                                      message: "",
                                      preferredStyle: .alert)
        alert.setValue(titleAttributedString, forKey: "attributedTitle")
        
        let action = UIAlertAction(title: Constants.Texts.alertOkSub,
                                   style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // Hide keyboard action by gesture
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        
        api(code: code)
        print(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //
    private func api(code: String) {
        guard let url = URL(string: "https://api.fda.gov/drug/ndc.json?search=product_ndc:\(code)") else { return }
        URLSession.shared.dataTask(with: url) { data, resonse, error in
            if let error = error {
                print("error")
                return
            }
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print(json)
            print("--------------------")
            print(json?["results"] as? [[String: Any]])
        }
    }
    //
}

// MARK: - CustomNavigationBarDelegate
extension QRViewController: CustomNavigationBarDelegate {
    // MARK: Functions
    // Button action passing by button
    func tapped(_ button: ButtonType) {
        switch button {
        case .left:
            backButtonAction()
        case .right:
            break
        }
    }
    
    // MARK: Private functions
    // Button action
    @objc private func backButtonAction() {
        viewModel?.close(true)
    }
}
