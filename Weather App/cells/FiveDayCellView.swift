import UIKit
import SDWebImage

class FiveDayCell: UITableViewCell {
    private let weatherIconImageView = UIImageView()
    private let dateTimeLabel = CustomLabel(fontSize: 15, color: .white, fontWeight: .medium)
    private let descriptionLabel = CustomLabel(fontSize: 15, color: .white, fontWeight: .medium)
    private let temperatureLabel = CustomLabel(fontSize: 20, color: TINT_COLOR, fontWeight: .bold)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dateTimeLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        
        let timeAndDesc = UIStackView(arrangedSubviews: [dateTimeLabel, descriptionLabel])
        timeAndDesc.axis = .vertical
        timeAndDesc.alignment = .leading
        timeAndDesc.spacing = 5
        timeAndDesc.translatesAutoresizingMaskIntoConstraints = false
        
        let firstHalf = UIStackView(arrangedSubviews: [weatherIconImageView, timeAndDesc])
        firstHalf.axis = .horizontal
        firstHalf.alignment = .center
        firstHalf.spacing = 5
        firstHalf.translatesAutoresizingMaskIntoConstraints = false
        
        let containerStackView = UIStackView(arrangedSubviews: [firstHalf, temperatureLabel])
        containerStackView.axis = .horizontal
        containerStackView.spacing = 10
        containerStackView.distribution = .equalSpacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: FiveDaysWeatherViewModel.ForecastData) {
        dateTimeLabel.text = forecast.dateTime
        temperatureLabel.text = "\(forecast.temperature)°C"
        descriptionLabel.text = forecast.weatherDescription.capitalized
        
        if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(forecast.icon)@2x.png") {
            weatherIconImageView.sd_setImage(with: iconURL, placeholderImage: UIImage(systemName: "cloud"))
        }
    }
}
