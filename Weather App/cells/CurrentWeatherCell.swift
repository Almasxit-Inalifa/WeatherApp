import UIKit
import SDWebImage

class WeatherCell: UICollectionViewCell {
    static let identifier = "WeatherCell"

    // MARK: - UI Elements
    private let cityLabel: UILabel = CustomLabel(color: .white)
    private let temperatureLabel: UILabel = CustomLabel(fontSize: 22, color: TINT_COLOR, fontWeight: .bold)
    private let descriptionLabel: UILabel = CustomLabel(fontSize: 22, color: TINT_COLOR, fontWeight: .bold)
    
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return imageView
    }()
    
    private let cloudiness = CurrentStatView(type: .cloudiness)
    private let humidity = CurrentStatView(type: .humidity)
    private let windSpeed = CurrentStatView(type: .windSpeed)
    private let windDirection = CurrentStatView(type: .windDirection)

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        let separatorLabel: UILabel = CustomLabel(text: "|", fontSize: 22, color: TINT_COLOR, fontWeight: .bold)
        
        let mainStack = UIStackView(arrangedSubviews: [temperatureLabel, separatorLabel, descriptionLabel])
        mainStack.axis = .horizontal
        mainStack.spacing = 5
        mainStack.alignment = .center
        
        let topStack = UIStackView(arrangedSubviews: [weatherIconImageView, cityLabel, mainStack])
        topStack.axis = .vertical
        topStack.spacing = 8
        topStack.alignment = .center
        
        let bottomStack = UIStackView(arrangedSubviews: [cloudiness, humidity, windSpeed, windDirection])
        bottomStack.axis = .vertical
        bottomStack.spacing = 5
        bottomStack.alignment = .fill
        bottomStack.distribution = .fillEqually
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let verticalStackView = UIStackView(arrangedSubviews: [topStack, spacerView, bottomStack])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.alignment = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(verticalStackView)

        // MARK: - Constraints
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }


    // MARK: - Configure Cell
    func configure(with weather: CurrentWeatherViewModel.WeatherData, index: Int) {
        cityLabel.text = "\(weather.city), \(weather.country)"
        temperatureLabel.text = "\(weather.temperature)°C"
        descriptionLabel.text = weather.weatherDescription.capitalized
        cloudiness.updateInfo("\(weather.cloudiness)%")
        humidity.updateInfo("\(weather.humidity)%")
        windSpeed.updateInfo("\(weather.windSpeed) m/s")
        windDirection.updateInfo(weather.windDirection)

        if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png") {
            weatherIconImageView.sd_setImage(with: iconURL, placeholderImage: UIImage(systemName: "photo"))
        }
        
        let gradientBackground = GradientBackgroundView(frame: bounds, mainColor: CURRENT_BACKGROUND_COLORS[index % CURRENT_BACKGROUND_COLORS.count])
        gradientBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView = gradientBackground // Set as background view
    }
}
