import UIKit

class WeatherDataManager {
    static func fetchWeatherData(for viewController: CurrentWeatherVC) {
        let includeCurrentLocation = (viewController.latitude != nil && viewController.longitude != nil)
        
        print("Weather Data Count:", viewController.weatherData.count)
        for data in viewController.weatherData {
            print("Weather City:", data.city)
        }

        if !viewController.cities.isEmpty || includeCurrentLocation {
            viewController.viewModel.fetchWeather(cities: viewController.cities, latitude: viewController.latitude, longitude: viewController.longitude) { [weak viewController] weatherList in
                DispatchQueue.main.async {
                    guard let viewController = viewController else { return }
                    viewController.activityIndicator.startAnimating()
                    
                    if weatherList.isEmpty {
                        viewController.showErrorScreen()
                        return
                    }
                    
                    var orderedWeatherData: [CurrentWeatherViewModel.WeatherData] = []
                    
                    if let locationWeather = weatherList.first(where: { $0.isCurrentLocation }) {
                        orderedWeatherData.append(locationWeather)
                        viewController.locationCity = locationWeather.city
                    }
                    
                    let cityWeatherData = viewController.cities.compactMap { city in
                        weatherList.first(where: { $0.city.lowercased() == city.lowercased() })
                    }
                    
                    print("Fetched weather for:", weatherList.map { $0.city })

                    orderedWeatherData.append(contentsOf: cityWeatherData)

                    viewController.weatherData = orderedWeatherData
                    viewController.activityIndicator.stopAnimating()
                    viewController.collectionView.reloadData()
                    viewController.setupDots()
                }
            }
        }
    }
}
