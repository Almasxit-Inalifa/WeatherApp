import Foundation

class CurrentWeatherViewModel {
    struct WeatherData {
        var city: String
        let humidity: Int
        let cloudiness: Int
        let windSpeed: Double
        let windDirection: String
        let temperature: Int
        let weatherDescription: String
        let icon: String
        let country: String
        let isCurrentLocation: Bool
    }
    
    struct WeatherResponse: Decodable {
        struct Main: Decodable {
            let humidity: Int
            let temp: Double
        }
        
        struct Sys: Decodable {
            let country: String
        }
        
        struct Clouds: Decodable {
            let all: Int
        }
        
        struct Wind: Decodable {
            let speed: Double
            let deg: Int
        }
        
        struct Weather: Decodable {
            let description: String
            let icon: String
        }
        
        let main: Main
        let clouds: Clouds
        let wind: Wind
        let weather: [Weather]
        let name: String
        let sys: Sys
    }
    
    func isCityValid(city: String, completion: @escaping (Bool?) -> Void) {
        let group = DispatchGroup()
        
        if !Reachability.isConnectedToNetwork() {
            print("❌ No internet connection before making request.")
            completion(nil)
            return
        }
        
        fetchWeatherForCity(city: city, group: group) { weatherData in
            if let _ = weatherData {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchWeather(urlString: String, isCurrentLocation: Bool, group: DispatchGroup, completion: @escaping (WeatherData?) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            print("❌ No internet connection before making request.")
            completion(nil)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        group.enter()
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { group.leave() }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                print("Resource not found for URL: \(urlString)")
                completion(nil)
                return
            }
            
            guard let data = data, error == nil else {
                print("Network error while fetching weather: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                guard let weatherCondition = decoded.weather.first else {
                    completion(nil)
                    return
                }
                
                let weatherData = WeatherData(
                    city: decoded.name.capitalized,
                    humidity: decoded.main.humidity,
                    cloudiness: decoded.clouds.all,
                    windSpeed: decoded.wind.speed,
                    windDirection: self.windDirectorFromAngle(angle: decoded.wind.deg),
                    temperature: Int(decoded.main.temp),
                    weatherDescription: weatherCondition.description,
                    icon: weatherCondition.icon,
                    country: self.getCountryName(from: decoded.sys.country),
                    isCurrentLocation: isCurrentLocation
                )
                
                completion(weatherData)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    func fetchWeatherForCity(city: String, group: DispatchGroup, completion: @escaping (WeatherData?) -> Void) {
        let cityNoSpaces = city.replacingOccurrences(of: " ", with: "")
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityNoSpaces)&appid=\(API_KEY)&units=metric"
        fetchWeather(urlString: urlString, isCurrentLocation: false, group: group, completion: completion)
    }

    func fetchWeatherForLocation(latitude: Double, longitude: Double, group: DispatchGroup, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)&units=metric"
        fetchWeather(urlString: urlString, isCurrentLocation: true, group: group, completion: completion)
    }

    func fetchWeather(cities: [String], latitude: Double?, longitude: Double?, completion: @escaping ([WeatherData]) -> Void) {
        let group = DispatchGroup()
        var weatherResults: [WeatherData] = []
        let queue = DispatchQueue(label: "weatherQueue", attributes: .concurrent)
        
        if let lat = latitude, let lon = longitude {
            fetchWeatherForLocation(latitude: lat, longitude: lon, group: group) { weatherData in
                if let data = weatherData {
                    queue.sync { weatherResults.append(data) }
                }
            }
        }
        
        for city in cities {
            fetchWeatherForCity(city: city, group: group) { weatherData in
                if var data = weatherData {
                    queue.sync {
                        data.city = city.capitalized
                        weatherResults.append(data)
                        
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(weatherResults)
        }
    }

    func getCountryName(from countryCode: String) -> String {
        return Locale(identifier: "en_US").localizedString(forRegionCode: countryCode) ?? ""
    }
    
    func windDirectorFromAngle(angle: Int) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = (angle % 360) / 45 
        return directions[index]
    }
}
