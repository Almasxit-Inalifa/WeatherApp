import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithError(error: Error)
    func didDenyLocationAccess()
}

class LocationManagerService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        DispatchQueue.global(qos: .background).async {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("✅ Location access granted")
            requestLocation()  // Now calling requestLocation() on a background thread
        } else if status == .denied || status == .restricted {
            print("❌ Location access denied")
            DispatchQueue.main.async {
                self.delegate?.didDenyLocationAccess()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.delegate?.didUpdateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.delegate?.didFailWithError(error: error)
        }
    }
}
