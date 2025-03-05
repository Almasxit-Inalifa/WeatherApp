//import UIKit
//
//class ViewController: UIViewController {
//    let currentView = CurrentView(cities: ["Miami", "Tbilisi", "London"])
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(currentView)
//        currentView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            currentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            currentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            currentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//            currentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
//        ])
//    }
//}

//import UIKit
//
//class ViewController: UIViewController {
//    let forecastView = FiveDaysView(city: "Tbilisi")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(forecastView)
//        forecastView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            forecastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            forecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            forecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            forecastView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
