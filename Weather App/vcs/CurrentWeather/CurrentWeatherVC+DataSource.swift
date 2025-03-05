import UIKit

extension CurrentWeatherVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        let data = weatherData[indexPath.item]
        cell.configure(with: data, index: indexPath.item)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: centerX, y: collectionView.bounds.midY)) {
            currentIndex = indexPath.item
            setupDots()
        }
    }
    
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // Allow both gestures to be recognized simultaneously
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionView)

        if gesture.state == .ended || gesture.state == .recognized {
            guard let indexPath = collectionView.indexPathForItem(at: location) else {
                return
            }

            let fiveDayVC = FiveDayWeatherVC()
            if indexPath.item == 0 && latitude != nil && longitude != nil {
                fiveDayVC.latitude = latitude
                fiveDayVC.longitude = longitude
                fiveDayVC.locationCity = locationCity
            } else {
                let cityIndex = latitude != nil && longitude != nil ? indexPath.item - 1 : indexPath.item
                guard cityIndex >= 0, cityIndex < cities.count else { return }

                let city = cities[cityIndex]
                fiveDayVC.city = city
            }

            fiveDayVC.delegate = self
            navigationController?.pushViewController(fiveDayVC, animated: true)
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
        
        
        if indexPath.item == 0 && latitude != nil && longitude != nil {
            ErrorPopupManager.showErrorPopup(
                on: self.view,
                message: "You cannot remove your current location",
                width: ADD_POPUP_WIDTH,
                yOffset: 10
            )
        } else {
            let cityIndex = (latitude != nil && longitude != nil) ? indexPath.item - 1 : indexPath.item
            guard cityIndex >= 0, cityIndex < cities.count else { return }
                        
            let city = cities[cityIndex]
            showDeleteConfirmation(for: city, at: indexPath, sourceView: collectionView.cellForItem(at: indexPath))
        }
    }
    
    @objc func addCity() {
        if cities.count < MAX_AMOUNT_CITIES {
            let addCityVC = AddCityVC()
            addCityVC.modalPresentationStyle = .overFullScreen
            addCityVC.modalTransitionStyle = .crossDissolve
            
            addCityVC.onCitySubmitted = { city in
                self.validateAndAddCity(city: city, in: addCityVC)
            }
            
            present(addCityVC, animated: true)
        } else {
            ErrorPopupManager.showErrorPopup(on: self.view, message: "You cannot add more cities! Please, remove some first", width: ADD_POPUP_WIDTH, yOffset: 10)
        }
    }

    @objc func refresh() {
        fetchWeatherData()
    }
}
