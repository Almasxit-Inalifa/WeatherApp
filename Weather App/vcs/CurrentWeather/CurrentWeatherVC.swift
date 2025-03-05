import UIKit
import CoreLocation

class CurrentWeatherVC: UIViewController, UICollectionViewDelegate, ErrorVCDelegate, LocationManagerDelegate {
    
    private let locationService = LocationManagerService()
    
    var cities: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: "savedCities") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "savedCities")
        }
    }
    
    private let locationManager = CLLocationManager()
    private var hasRequestedLocation: Bool {
        get { UserDefaults.standard.bool(forKey: "hasRequestedLocation") }
        set { UserDefaults.standard.set(newValue, forKey: "hasRequestedLocation") }
    }
    
    var latitude: Double?
    var longitude: Double?
    var locationCity: String?

    
    let viewModel = CurrentWeatherViewModel()
    var weatherData: [CurrentWeatherViewModel.WeatherData] = []
    let activityIndicator = ActivityIndicator(style: .large)
    var currentIndex: Int = 0
    
    private lazy var dotsStackView: DotsStackView = {
        let stackView = DotsStackView(count: cities.count)
        return stackView
    }()

    var collectionView: UICollectionView = {
        let layout = CarouselFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = .fast 
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpNavBar()
        setUpActivityIndicator()
        setupUI()
        setupCollectionView()
        
        locationService.delegate = self
        if !hasRequestedLocation {
            DispatchQueue.global(qos: .background).async {
                self.locationService.requestLocationAccess()
            }
            hasRequestedLocation = true
        }
        
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setUpBackground() {
        let gradientBackground = GradientBackgroundView(frame: view.bounds, mainColor: MAIN_BACKGROUND)
        gradientBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(gradientBackground)
    }

    func validateAndAddCity(city: String, in addCityVC: AddCityVC) {
        CityManager.validateAndAddCity(city: city, in: addCityVC, for: self)
    }
    
    func setUpNavBar() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        
        refreshButton.tintColor = TINT_COLOR
        addButton.tintColor = TINT_COLOR
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = addButton
        navigationItem.titleView = CustomLabel(text: "Today", color: .white)
    }
    
    private func setupUI() {
        view.addSubview(dotsStackView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            dotsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dotsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dotsStackView.heightAnchor.constraint(equalToConstant: 20),
            
            collectionView.topAnchor.constraint(equalTo: dotsStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.identifier)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    func fetchWeatherData() {
        WeatherDataManager.fetchWeatherData(for: self)
    }
    
    func showErrorScreen() {
        let errorVC = ErrorVC()
        errorVC.delegate = self
        errorVC.modalPresentationStyle = .overFullScreen
        present(errorVC, animated: true)
    }

    func didTapReload() {
        refresh()
    }

    func setupDots() {
        let totalDots = cities.count + (latitude != nil ? 1 : 0)
        dotsStackView.updateDots(for: currentIndex, count: totalDots)
    }

    func showDeleteConfirmation(for city: String, at indexPath: IndexPath, sourceView: UIView?) {
        DeleteConfirmation.showDeleteConfirmation(
            from: self,
            for: city,
            at: indexPath,
            sourceView: sourceView
        ) { indexPath in
            self.deleteCity(city: city)
        }
    }

    private func deleteCity(city: String) {
        CityManager.deleteCity(city: city, for: self)
    }
    
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        print("User's Location: \(latitude), \(longitude)")
        self.latitude = latitude
        self.longitude = longitude
        
        fetchWeatherData()
    }
    
    func didFailWithError(error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func didDenyLocationAccess() {
        fetchWeatherData()
    }
}
