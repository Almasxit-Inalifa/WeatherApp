import UIKit

class AddCityVC: UIViewController {
    
    var onCitySubmitted: ((String) -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = CustomLabel(text: "Add City", fontSize: 20, color: .white)

    private let subtitleLabel: UILabel = CustomLabel(text: "Enter City name you wish to add", fontSize: 12, color: .white, fontWeight: .medium)

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        let plusImage = UIImage(systemName: "plus.circle.fill",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        button.addTarget(nil, action: #selector(addCityTapped), for: .touchUpInside)
        return button
    }()
    
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffect()
        setupUI()
        setupDismissOnTapOutside()
    }
    
    func setUpBackground() {
        let gradientBackground = GradientBackgroundView(
            frame: CGRect(x: (view.bounds.width - ADD_POPUP_WIDTH) / 2,
                          y: (view.bounds.height - ADD_POPUP_HEIGHT) / 2,
                          width: ADD_POPUP_WIDTH,
                          height: ADD_POPUP_HEIGHT),
            mainColor: ADD_POPUP_BACKGROUND
        )
        gradientBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(gradientBackground)
    }

    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
    }

    private func setupUI() {
        setUpBackground()
        view.addSubview(containerView)
        containerView.addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(addButton)

        // Constrain containerView
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: ADD_POPUP_WIDTH * 0.6),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: ADD_POPUP_WIDTH),
            containerView.heightAnchor.constraint(equalToConstant: ADD_POPUP_HEIGHT),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -40)
        ])
    }


    @objc private func addCityTapped() {
        guard let city = textField.text, !city.isEmpty else { return }
        onCitySubmitted?(city)
    }
    
    func setButtonLoader() {
        loadingIndicator.startAnimating()
        addButton.setImage(nil, for: .normal)
        addButton.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
    
    func removeButtonLoader() {
        loadingIndicator.stopAnimating()
        addButton.setImage(UIImage(systemName: "plus.circle.fill",
                                             withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
    }


    
    private func setupDismissOnTapOutside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: view)
                
        if !containerView.frame.contains(tapLocation) {
            dismiss(animated: true)
        }
    }
    
}
