//
//  WeatherDetailsViewController.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelWeather: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelWind: UILabel!
    @IBOutlet weak var imageViewWeatherIcon: UIImageView!
    
    var coordinate: CLLocationCoordinate2D!
    var fromHistory = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initLabelValues()
        self.loadWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Current Weather"
    }
    
    func initLabelValues() {
        self.labelLocation.text = String(format: "(%.5f, %.5f)", self.coordinate.latitude, self.coordinate.longitude)
    }

}

extension WeatherDetailsViewController {
    
    func loadWeather() {
        
        if let weather = CacheManager.manager.load(for: self.coordinate, cacheTimeCheck: !self.fromHistory) {
            self.show(weather: weather)
        } else {
            WebServiceManager.manager.loadCurrentWeather(coordinate: coordinate) { (weather, err) in
                if let err = err {
                    AppUtils.showSimpleAlertMessage(for: self, title: nil, message: err)
                    self.show(weather: nil)
                } else {
                    guard let weather = weather else {
                        self.show(weather: nil)
                        return
                    }
                    CacheManager.manager.store(weather: weather, coord: self.coordinate)
                    self.show(weather: weather)
                }
            }
        }
    }
    
    func show(weather: Weather?) {
        if let weather = weather {
            self.labelWeather.text = weather.weatherText
            self.labelWind.text = String(format: "%gm/s", weather.windSpeed ?? 0)
            self.labelTemperature.text = String(format: "%g°C", weather.temp ?? 0)
            if let iconId = weather.weatherIcon {
                self.imageViewWeatherIcon.imageFromURL(urlString: AppConfig.ThirdPartyAPI.weatherIconBaseUrl(iconId))
            }
        } else {
            self.labelWeather.text = "Not available"
            self.labelWind.text = "Not available"
            self.labelTemperature.text = "Not available"
            self.imageViewWeatherIcon.image = nil
        }
    }
}
