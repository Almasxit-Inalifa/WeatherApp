import UIKit

class FiveDayWeatherVC: UIViewController, BackButtonHandler, ErrorVCDelegate {
    weak var delegate: CurrentWeatherVC?
    var city: String?
    var locationCity: String?
    var latitude: Double?
    var longitude: Double?
    
    private let activityIndicator = ActivityIndicator(style: .large)
    private let viewModel = FiveDaysWeatherViewModel()
    private var forecastView: FiveDaysView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpBackground()
        setUpActivityIndicator()
        fetchForecast()
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchForecast() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        let dispatchGroup = DispatchGroup()

        if let city = city, !city.isEmpty {
            // Fetch using city name
            viewModel.fetchForecast(city: city, group: dispatchGroup) { [weak self] forecast in
                self?.handleForecastResponse(forecast, dispatchGroup: dispatchGroup)
            }
        } else if let latitude = latitude, let longitude = longitude {
            // Fetch using location (latitude & longitude)
            viewModel.fetchForecast(latitude: latitude, longitude: longitude, group: dispatchGroup) { [weak self] forecast in
                self?.handleForecastResponse(forecast, dispatchGroup: dispatchGroup)
            }
        } else {
            print("❌ No valid city or location provided.")
            didFailToLoadForecast()
            return
        }
    }

    /// Handles forecast response after API call
    private func handleForecastResponse(_ forecast: [FiveDaysWeatherViewModel.ForecastData]?, dispatchGroup: DispatchGroup) {
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            
            let validForecast = forecast ?? []
            if validForecast.isEmpty {
                print("⚠️ No forecast data received, showing error screen.")
                self.didFailToLoadForecast()
            } else {
                self.loadForecastView(with: validForecast)
            }
        }
    }



    private func loadForecastView(with forecast: [FiveDaysWeatherViewModel.ForecastData]) {
        forecastView?.removeFromSuperview() // Remove any existing forecast view

        let forecastView = FiveDaysView(city: city ?? "", forecast: forecast)
        forecastView.delegate = self
        self.forecastView = forecastView
        view.addSubview(forecastView)
        forecastView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            forecastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            forecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showErrorScreen() {
        DispatchQueue.main.async {
            if self.presentedViewController == nil { // Prevent multiple error screens
                let errorVC = ErrorVC()
                errorVC.delegate = self
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true)
            }
        }
    }

    func didTapReload() {
        dismiss(animated: true) {
            self.activityIndicator.startAnimating()
            self.fetchForecast()
        }
    }

    func setUpNavBar() {
        navigationItem.leftBarButtonItem = BackButton(handler: self)
        var curCity = city
        
        if curCity == nil {
            curCity = locationCity
        }
        navigationItem.titleView = CustomLabel(text: curCity ?? "", color: .white)
    }

    func setUpBackground() {
        let gradientBackground = GradientBackgroundView(frame: view.bounds, mainColor: MAIN_BACKGROUND)
        gradientBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(gradientBackground)
    }
}

extension FiveDayWeatherVC: FiveDaysViewDelegate {
    func didFailToLoadForecast() {
        showErrorScreen()
    }
}
