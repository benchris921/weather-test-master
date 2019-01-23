//
//  CacheManager.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import CoreLocation

class CacheManager: NSObject {
    
    // We should ignore the cache stored data 1 hr ago.
    // Need to refresh new weather data if cached data is old more than 1 hr.
    let cacheTime:Double = 1 * 3600
    
    static let manager = CacheManager()
    
    func store(weather: Weather, coord: CLLocationCoordinate2D) {
        
        let item = HistoryItem()
        item.coordString = coord.toString()
        item.time = Date().timeIntervalSince1970
        item.weather = weather
        
        UserDefaults.standard.set(item.toJSON(), forKey: item.coordString!)
        
        if var history = UserDefaults.standard.object(forKey: "history") as? [String] {
            history.append(coord.toString())
            UserDefaults.standard.set(history, forKey: "history")
        } else {
            UserDefaults.standard.set([coord.toString()], forKey: "history")
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    func load(for coord: CLLocationCoordinate2D, cacheTimeCheck: Bool = true) -> Weather? {
        if let stored = UserDefaults.standard.object(forKey: coord.toString()) {
            if let data = stored as? [String: Any] {
                if let item = HistoryItem(JSON: data) {
                    if let time = item.time {
                        if cacheTimeCheck {
                            let current = Date().timeIntervalSince1970
                            if current - time < cacheTime {
                                return item.weather
                            }
                        } else {
                            return item.weather
                        }
                    }
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    func loadHistory() -> [HistoryItem]? {
        if let history = UserDefaults.standard.object(forKey: "history") as? [String] {
            var items = [HistoryItem]()
            for coord in history {
                if let data = UserDefaults.standard.object(forKey: coord) as? [String: Any] {
                    if let item = HistoryItem(JSON: data) {
                        items.append(item)
                    }
                }
            }
            return items.sorted(by: { (item1, item2) -> Bool in
                return item1.time! > item2.time!
            })
        } else {
            return nil
        }
    }
    
    func remove(_ coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.removeObject(forKey: coordinate.toString())
        if var history = UserDefaults.standard.object(forKey: "history") as? [String] {
            
            history.enumerated().forEach { (idx, item) in
                if item == coordinate.toString() {
                    history.remove(at: idx)
                    return
                }
            }
            
            UserDefaults.standard.set(history, forKey: "history")
        }
        UserDefaults.standard.synchronize()
    }
}
