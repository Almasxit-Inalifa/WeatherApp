import UIKit

enum StatType {
    case cloudiness, humidity, windSpeed, windDirection

    var name: String {
        switch self {
        case .cloudiness: return "Cloudiness"
        case .humidity: return "Humidity"
        case .windSpeed: return "Wind Speed"
        case .windDirection: return "Wind Direction"
        }
    }

    var systemImage: UIImage? {
        switch self {
        case .cloudiness: return UIImage(systemName: "cloud.heavyrain")
        case .humidity: return UIImage(systemName: "drop")
        case .windSpeed: return UIImage(systemName: "wind")
        case .windDirection: return UIImage(systemName: "safari")
        }
    }
}

class CurrentStatView: UIView {
    private let type: StatType
    private let infoLabel = CustomLabel(fontSize: 20, color: TINT_COLOR, fontWeight: .bold)

    init(type: StatType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let imageView = UIImageView(image: type.systemImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.tintColor = TINT_COLOR

        let nameLabel = CustomLabel(text: type.name, color: .white)

        infoLabel.text = ""
        infoLabel.font = .systemFont(ofSize: 14, weight: .bold)
        infoLabel.textColor = TINT_COLOR
        
        let dataStack = UIStackView(arrangedSubviews: [imageView, nameLabel,])
        dataStack.axis = .horizontal
        dataStack.spacing = 5
        dataStack.alignment = .center
        dataStack.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [dataStack, infoLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }

    func updateInfo(_ newInfo: String) {
        infoLabel.text = newInfo
    }
}
