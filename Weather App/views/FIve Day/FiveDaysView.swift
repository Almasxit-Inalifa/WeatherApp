import UIKit
import SDWebImage

protocol FiveDaysViewDelegate: AnyObject {
    func didFailToLoadForecast()
}

class FiveDaysView: UIView, UITableViewDelegate{
    weak var delegate: FiveDaysViewDelegate?  
    private let city: String
    var forecastSections: [(weekday: String, forecasts: [FiveDaysWeatherViewModel.ForecastData])] = []
    
    private var tableView = UITableView()
    
    init(city: String, forecast: [FiveDaysWeatherViewModel.ForecastData]) {
        self.city = city
        super.init(frame: .zero)
        setupUI()
        groupForecastByDay(forecast)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = .clear

        tableView = UITableView(frame: bounds, style: .grouped)
        tableView.sectionHeaderHeight = 50

        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FiveDayCell.self, forCellReuseIdentifier: "ForecastCell")

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func groupForecastByDay(_ forecast: [FiveDaysWeatherViewModel.ForecastData]) {
        if forecast.isEmpty {
            DispatchQueue.main.async {
                self.delegate?.didFailToLoadForecast()
            }
            return
        }

        let grouped = Dictionary(grouping: forecast, by: { $0.weekday })

        let todayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let sortedDays = Array(weekdays[todayIndex...] + weekdays[..<todayIndex])

        let availableDays = sortedDays.filter { grouped.keys.contains($0) }

        forecastSections = grouped.sorted {
            guard let firstIndex = availableDays.firstIndex(of: $0.key),
                  let secondIndex = availableDays.firstIndex(of: $1.key) else { return false }
            return firstIndex < secondIndex
        }.map { (key, value) in
            (weekday: key, forecasts: value.sorted { $0.dateTime < $1.dateTime })
        }
        
        tableView.reloadData()
    }

}
