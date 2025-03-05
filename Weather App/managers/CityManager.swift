import UIKit

class CityManager {
    
    static func validateAndAddCity(city: String, in addCityVC: AddCityVC, for viewController: CurrentWeatherVC) {
        addCityVC.setButtonLoader()
        
        CurrentWeatherViewModel().isCityValid(city: city) { isValid in
            DispatchQueue.main.async {
                if let isValid = isValid {
                    if isValid {
                        if !viewController.cities.contains(where: { $0.caseInsensitiveCompare(city) == .orderedSame }) {
                            
                            if viewController.latitude != nil && !viewController.weatherData.isEmpty && viewController.weatherData[0].city.lowercased() == city.lowercased() {
                                addCityVC.dismiss(animated: true)
                                return
                            }
                            
                            viewController.cities.append(city.capitalized)
                            viewController.fetchWeatherData()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewController.collectionView.reloadData()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    let newIndex = viewController.weatherData.count - 1
                                    print(newIndex)
                                    
                                    if newIndex >= 0 && newIndex < viewController.collectionView.numberOfItems(inSection: 0) {
                                        viewController.collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
                                    }
                                }
                            }
                        }
                        
                        addCityVC.dismiss(animated: true)
                    } else {
                        ErrorPopupManager.showErrorPopup(on: addCityVC.view, message: "City with that name not found!", width: ADD_POPUP_WIDTH, yOffset: 90)
                    }
                } else {
                    addCityVC.dismiss(animated: true) {
                        viewController.showErrorScreen()
                    }
                }
            }
        }
        
        addCityVC.removeButtonLoader()
    }
    
    static func deleteCity(city: String, for viewController: CurrentWeatherVC) {
        guard let index = viewController.cities.firstIndex(where: { $0.caseInsensitiveCompare(city) == .orderedSame }) else {
            print("City not found: \(city)")
            return
        }

        viewController.cities.remove(at: index)
        viewController.cities = viewController.cities

        UserDefaults.standard.set(viewController.cities, forKey: "savedCities")

        viewController.weatherData.removeAll { $0.city.caseInsensitiveCompare(city) == .orderedSame }

        if viewController.cities.isEmpty {
            viewController.collectionView.reloadData()
            viewController.setupDots()
        } else {
            viewController.refresh()
        }
    }
}
