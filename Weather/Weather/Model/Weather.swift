//
//  Weather.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import ObjectMapper

class Weather: Mappable {

    var weatherIcon: String?
    var weatherText: String?
    var temp: Double?
    var windSpeed: Double?
    
    init() {
        
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        weatherIcon <- map["weather.0.icon"]
        weatherText <- map["weather.0.main"]
        temp <- map["main.temp"]
        windSpeed <- map["wind.speed"]
    }
    
}
