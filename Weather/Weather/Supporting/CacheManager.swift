//
//  CacheManager.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationCoordinate2D {
    func toString() -> String {
        return String(format: "%g, %g", latitude, longitude)
    }
}

extension String {
    func toCoord() -> CLLocationCoordinate2D? {
        let components = self.components(separatedBy: ", ")
        if components.count == 2 {
            return CLLocationCoordinate2D(latitude: Double(components[0]) ?? 0, longitude: Double(components[1]) ?? 0)
        } else {
            return nil
        }
    }
}

class CacheManager: NSObject {
    
    
    // We should ignore the cache stored data 1 hr ago.
    // Need to refresh new weather data if cached data is old more than 1 hr.
    let cacheTime:Double = 1 * 3600
    
    static let manager = CacheManager()
    
    func store(weather: Weather, coord: CLLocationCoordinate2D) {
        UserDefaults.standard.set(["weather": weather.toJSON(), "time": Date().timeIntervalSince1970], forKey: String(format: "WT%.4g,%.4g", coord.latitude, coord.longitude))
        
        if var history = UserDefaults.standard.object(forKey: "history") as? [String] {
            history.append(coord.toString())
            UserDefaults.standard.set(history, forKey: "history")
        } else {
            UserDefaults.standard.set([coord.toString()], forKey: "history")
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    func load(for coord: CLLocationCoordinate2D) -> Weather? {
        if let stored = UserDefaults.standard.object(forKey: String(format: "WT%.4g,%.4g", coord.latitude, coord.longitude)) {
            if let data = stored as? [String: Any] {
                if let time = data["time"] as? TimeInterval {
                    let current = Date().timeIntervalSince1970
                    if current - time < cacheTime {
                        if let weatherData = data["weather"] as? [String:Any] {
                            return Weather(JSON: weatherData)
                        }
                    }
                }
            }
            return nil
        } else {
            return nil
        }
    }
}
