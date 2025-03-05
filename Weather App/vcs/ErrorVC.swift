import UIKit

protocol ErrorVCDelegate: AnyObject {
    func didTapReload()
}

class ErrorVC: UIViewController {

    weak var delegate: ErrorVCDelegate?  // Delegate reference

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setupUI()
    }

    private func setupUI() {
        let cloudImageView = UIImageView(image: UIImage(named: "cloudWarning.png"))
        cloudImageView.tintColor = .white
        cloudImageView.translatesAutoresizingMaskIntoConstraints = false
        cloudImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cloudImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let errorLabel = CustomLabel(text: "Error occurred while loading data", color: .white, fontWeight: .medium)
        errorLabel.textAlignment = .center

        let reloadButton = UIButton(type: .system)
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.setTitleColor(.white, for: .normal)
        reloadButton.backgroundColor = TINT_COLOR
        reloadButton.layer.cornerRadius = 10
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.addTarget(self, action: #selector(reload), for: .touchUpInside)

        let vStack = UIStackView(arrangedSubviews: [cloudImageView, errorLabel, reloadButton])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 100),
            reloadButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func reload() {
        delegate?.didTapReload()  // Notify the delegate
        dismiss(animated: true)   // Close the error screen
    }
    
    func setUpBackground() {
        let gradientBackground = GradientBackgroundView(frame: view.bounds, mainColor: MAIN_BACKGROUND)
        gradientBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(gradientBackground)
    }
}
