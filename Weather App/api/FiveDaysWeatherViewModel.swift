import Foundation

class FiveDaysWeatherViewModel {
    struct ForecastData {
        let dateTime: String
        let weekday: String
        let temperature: Int
        let weatherDescription: String
        let icon: String
    }

    struct ForecastResponse: Decodable {
        struct ForecastItem: Decodable {
            struct Main: Decodable {
                let temp: Double
            }

            struct Weather: Decodable {
                let description: String
                let icon: String
            }

            let dt_txt: String
            let main: Main
            let weather: [Weather]
        }

        let list: [ForecastItem]
    }

    func fetchForecast(city: String, group: DispatchGroup, completion: @escaping ([ForecastData]?) -> Void) {
        let cityNoSpaces = city.replacingOccurrences(of: " ", with: "")
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityNoSpaces)&appid=\(API_KEY)&units=metric"
        fetchForecast(urlString: urlString, group: group, city: city, completion: completion)
    }

    func fetchForecast(latitude: Double, longitude: Double, group: DispatchGroup, completion: @escaping ([ForecastData]?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)&units=metric"
        fetchForecast(urlString: urlString, group: group, city: "Current Location", completion: completion)
    }

    private func fetchForecast(urlString: String, group: DispatchGroup, city: String, completion: @escaping ([ForecastData]?) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            print("❌ No internet connection before making request.")
            completion(nil)
            return
        }

        group.enter()
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL for \(city)")
            completion(nil)
            group.leave()
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("📡 API request started for \(city)")
            defer { group.leave() }

            if let httpResponse = response as? HTTPURLResponse {
                print("📩 HTTP Response Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 404 {
                    print("❌ City '\(city)' not found.")
                    completion(nil)
                    return
                }
            }

            if let error = error as? URLError {
                print("❌ Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ No data received from API.")
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                let forecastData = self.processForecastData(decoded)
                print("✅ Successfully decoded forecast for \(city)")
                completion(forecastData)
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }

        print("🚀 Starting API request for \(city)")
        task.resume()
    }

    private func processForecastData(_ response: ForecastResponse) -> [ForecastData] {
        return response.list.map { item in
            ForecastData(
                dateTime: getHour(dateString: item.dt_txt),
                weekday: getWeekday(dateString: item.dt_txt),
                temperature: Int(item.main.temp),
                weatherDescription: item.weather.first?.description ?? "Unknown",
                icon: item.weather.first?.icon ?? ""
            )
        }
    }

    func getWeekday(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: dateString) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            weekdayFormatter.locale = Locale(identifier: "en_US")
            return weekdayFormatter.string(from: date)
        }
        return ""
    }

    func getHour(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
