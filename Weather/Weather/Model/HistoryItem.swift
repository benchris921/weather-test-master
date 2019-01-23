//
//  HistoryItem.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

class HistoryItem: Mappable {

    var time: TimeInterval?
    var weather: Weather?
    var coordString: String?
 
    init() {
        
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        time <- map["time"]
        weather <- map["weather"]
        coordString <- map["coordinate"]
    }
    
    func coordinate() -> CLLocationCoordinate2D {
        return coordString?.toCoord() ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

}
